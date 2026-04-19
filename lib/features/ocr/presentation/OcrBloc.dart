import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/domain/Transaction.dart';
import '../../../core/interfaces/ICounterpartyMatcher.dart';
import '../../../core/models/TypedId.dart';
import '../../../features/journal/usecase/CreateTransaction.dart';
import '../data/ClassificationEngine.dart';
import '../data/OcrService.dart';

part 'OcrBloc.freezed.dart';

// =============================================================================
// OCR 처리 단계 enum
// =============================================================================

/// OCR 파이프라인의 현재 처리 단계
enum OcrPhase {
  idle,           // 대기 — 초기 상태
  capturing,      // 이미지 캡처 중
  recognizing,    // ML Kit / 서버 OCR 텍스트 인식 중
  parsing,        // 원시 텍스트 파싱 (날짜/금액/가맹점 추출)
  classifying,    // 로직트리 분류 (계정과목/거래처 자동 매핑)
  reviewing,      // 사용자 리뷰 대기 — 분류 결과 확인/수정
  saving,         // Draft 저장 중
  done,           // 완료 — Draft 생성 성공
  error,          // 오류
}

// =============================================================================
// 파싱 결과 VO
// =============================================================================

/// OCR 원시 텍스트에서 추출된 구조화 데이터
class ParsedOcrData {
  const ParsedOcrData({
    required this.rawText,
    this.date,
    this.amount,
    this.merchantName,
    this.description,
  });

  /// OCR 인식 원문
  final String rawText;

  /// 추출된 날짜 (실패 시 null)
  final DateTime? date;

  /// 추출된 금액 — KRW 원 단위 int (실패 시 null)
  final int? amount;

  /// 추출된 가맹점/거래처명 (실패 시 null)
  final String? merchantName;

  /// 거래 설명 (OCR 원문 요약)
  final String? description;
}

// =============================================================================
// 이벤트
// =============================================================================

@freezed
abstract class OcrEvent with _$OcrEvent {
  /// 이미지 캡처 완료 → OCR 인식 시작
  const factory OcrEvent.captureImage({required File image}) = CaptureImage;

  /// OCR 인식 결과 파싱 시작
  const factory OcrEvent.processOcr({required String rawText}) = ProcessOcr;

  /// 파싱 결과 확인 → 분류 시작
  const factory OcrEvent.classifyTransaction({
    required ParsedOcrData parsed,
  }) = ClassifyTransaction;

  /// 사용자가 파싱 결과 필드 수정
  const factory OcrEvent.updateField({
    DateTime? date,
    int? amount,
    String? merchantName,
    String? description,
    AccountId? accountId,
  }) = UpdateOcrField;

  /// "이 패턴 기억하기" 토글
  const factory OcrEvent.toggleRememberPattern({required bool remember}) =
      ToggleRememberPattern;

  /// Draft 저장 확정
  const factory OcrEvent.saveAsDraft() = SaveAsDraft;

  /// 재시도 (오류 상태에서 초기화)
  const factory OcrEvent.retryCapture() = RetryCapture;
}

// =============================================================================
// 상태
// =============================================================================

@freezed
abstract class OcrState with _$OcrState {
  const factory OcrState({
    @Default(OcrPhase.idle) OcrPhase phase,

    /// OCR 파싱 결과
    ParsedOcrData? parsed,

    /// 분류 엔진 결과
    ClassificationResult? classified,

    /// 분류 신뢰도 (0.0 ~ 1.0)
    @Default(0.0) double confidence,

    /// "이 패턴 기억하기" 체크 여부
    @Default(false) bool rememberPattern,

    /// 사용자가 수동 수정한 accountId (분류 결과 override)
    AccountId? overriddenAccountId,

    /// 최종 저장된 Draft
    Transaction? savedDraft,

    /// 오류 메시지
    String? errorMessage,
  }) = _OcrState;
}

// =============================================================================
// BLoC
// =============================================================================

/// OCR 파이프라인 BLoC
///
/// 흐름: CaptureImage → ProcessOcr → ClassifyTransaction → SaveAsDraft
/// 각 단계에서 phase enum이 갱신되어 UI가 진행 상태를 표시
class OcrBloc extends Bloc<OcrEvent, OcrState> {
  OcrBloc({
    required IOcrService ocrService,
    required ClassificationEngine classificationEngine,
    required ICounterpartyMatcher counterpartyMatcher,
    required CreateTransaction createTransaction,
  })  : _ocrService = ocrService,
        _classificationEngine = classificationEngine,
        _counterpartyMatcher = counterpartyMatcher,
        _createTransaction = createTransaction,
        super(const OcrState()) {
    on<CaptureImage>(_onCapture);
    on<ProcessOcr>(_onProcess);
    on<ClassifyTransaction>(_onClassify);
    on<UpdateOcrField>(_onUpdateField);
    on<ToggleRememberPattern>(_onToggleRemember);
    on<SaveAsDraft>(_onSave);
    on<RetryCapture>(_onRetry);
  }

  final IOcrService _ocrService;
  final ClassificationEngine _classificationEngine;
  final ICounterpartyMatcher _counterpartyMatcher;
  final CreateTransaction _createTransaction;

  // ---------------------------------------------------------------------------
  // 이벤트 핸들러
  // ---------------------------------------------------------------------------

  Future<void> _onCapture(
    CaptureImage event,
    Emitter<OcrState> emit,
  ) async {
    emit(state.copyWith(phase: OcrPhase.recognizing, errorMessage: null));
    try {
      final rawText = await _ocrService.recognizeText(event.image);
      if (rawText.isEmpty) {
        emit(state.copyWith(
          phase: OcrPhase.error,
          errorMessage: 'OCR 인식 결과가 없습니다. 이미지를 다시 촬영해 주세요.',
        ));
        return;
      }
      // 인식 성공 → 파싱 단계로 진행
      add(OcrEvent.processOcr(rawText: rawText));
    } catch (e) {
      emit(state.copyWith(
        phase: OcrPhase.error,
        errorMessage: 'OCR 처리 중 오류: $e',
      ));
    }
  }

  Future<void> _onProcess(
    ProcessOcr event,
    Emitter<OcrState> emit,
  ) async {
    emit(state.copyWith(phase: OcrPhase.parsing));
    // 원시 텍스트에서 날짜/금액/가맹점명 추출
    final parsed = _parseRawText(event.rawText);
    emit(state.copyWith(parsed: parsed));
    // 파싱 즉시 분류 시작
    add(OcrEvent.classifyTransaction(parsed: parsed));
  }

  Future<void> _onClassify(
    ClassifyTransaction event,
    Emitter<OcrState> emit,
  ) async {
    emit(state.copyWith(phase: OcrPhase.classifying));
    try {
      final merchantName = event.parsed.merchantName ?? '';

      // 1단계: 거래처 매칭 (결과는 classified에 counterpartyId로 반영됨)
      await (merchantName.isNotEmpty
          ? _counterpartyMatcher.matchByText(merchantName)
          : Future.value(null));

      // 2단계: 계정과목 분류 (merchantName 또는 description으로 시도)
      final searchText =
          merchantName.isNotEmpty ? merchantName : (event.parsed.rawText);
      final classified = await _classificationEngine.classify(searchText);

      emit(state.copyWith(
        phase: OcrPhase.reviewing,
        parsed: event.parsed,
        classified: classified,
        confidence: classified?.confidence ?? 0.0,
        // 거래처 매칭 신뢰도도 반영 (두 신뢰도의 평균)
      ));
    } catch (e) {
      emit(state.copyWith(
        phase: OcrPhase.error,
        errorMessage: '분류 중 오류: $e',
      ));
    }
  }

  void _onUpdateField(
    UpdateOcrField event,
    Emitter<OcrState> emit,
  ) {
    final current = state.parsed;
    if (current == null) return;

    emit(state.copyWith(
      parsed: ParsedOcrData(
        rawText: current.rawText,
        date: event.date ?? current.date,
        amount: event.amount ?? current.amount,
        merchantName: event.merchantName ?? current.merchantName,
        description: event.description ?? current.description,
      ),
      overriddenAccountId: event.accountId ?? state.overriddenAccountId,
    ));
  }

  void _onToggleRemember(
    ToggleRememberPattern event,
    Emitter<OcrState> emit,
  ) {
    emit(state.copyWith(rememberPattern: event.remember));
  }

  Future<void> _onSave(
    SaveAsDraft event,
    Emitter<OcrState> emit,
  ) async {
    final parsed = state.parsed;
    if (parsed == null) return;

    final effectiveAccountId =
        state.overriddenAccountId ?? state.classified?.accountId;
    if (effectiveAccountId == null) {
      emit(state.copyWith(
        phase: OcrPhase.error,
        errorMessage: '계정과목을 선택해 주세요.',
      ));
      return;
    }

    emit(state.copyWith(phase: OcrPhase.saving, errorMessage: null));
    try {
      // "이 패턴 기억하기" 선택 시 사용자 규칙 저장
      if (state.rememberPattern && parsed.merchantName != null) {
        await _classificationEngine.rememberPattern(
          pattern: parsed.merchantName!,
          patternType: 'CONTAINS',
          accountId: effectiveAccountId,
          counterpartyId: state.classified?.counterpartyId,
        );
      }

      // Draft 생성 — KRW 단일 통화, 거래 금액 기반 JEL 2개(차변/대변)
      // 실제 JEL 구성은 계정과목의 nature에 따라 결정되어야 하나,
      // OCR에서는 비용(차변)/카드미지급금(대변) 패턴을 기본으로 사용
      final amount = parsed.amount ?? 0;
      final draft = await _createTransaction.execute(
        date: parsed.date ?? DateTime.now(),
        description: parsed.description ?? parsed.rawText,
        listLineInputs: [
          JournalEntryLineInput(
            accountId: effectiveAccountId,
            entryType: EntryType.debit,
            originalAmount: amount,
            originalCurrency: CurrencyCode.KRW,
            exchangeRateAtTrade: 1000000, // KRW→KRW 환율 1.0 (배율 1,000,000)
            baseCurrency: CurrencyCode.KRW,
            baseAmount: amount,
          ),
          // 대변(카드미지급금 등)은 사용자가 리뷰 후 추가하도록 빈 자리 마련
          // TODO: 카드 미지급금 계정과목 자동 조회 후 대변 JEL 자동 생성
        ],
        counterpartyId: state.classified?.counterpartyId,
        counterpartyName: parsed.merchantName,
        source: TransactionSource.ocr,
        confidence: state.confidence,
      );

      emit(state.copyWith(
        phase: OcrPhase.done,
        savedDraft: draft,
      ));
    } catch (e) {
      emit(state.copyWith(
        phase: OcrPhase.error,
        errorMessage: 'Draft 저장 실패: $e',
      ));
    }
  }

  void _onRetry(
    RetryCapture event,
    Emitter<OcrState> emit,
  ) {
    // 상태 초기화 → 재촬영 대기
    emit(const OcrState());
  }

  // ---------------------------------------------------------------------------
  // 파싱 헬퍼
  // ---------------------------------------------------------------------------

  /// 원시 OCR 텍스트에서 날짜/금액/가맹점명을 추출하는 간단한 파서.
  ///
  /// 실제 운영에서는 정교한 정규식 또는 AI 분류 모델로 대체.
  /// 현재는 기본 패턴만 처리하고, 실패 시 null로 둔다.
  ParsedOcrData _parseRawText(String rawText) {
    // 날짜 패턴: YYYY.MM.DD 또는 YYYY-MM-DD 또는 MM/DD/YY
    final dateRegex = RegExp(r'(\d{4})[.\-/](\d{2})[.\-/](\d{2})');
    final dateMatch = dateRegex.firstMatch(rawText);
    DateTime? date;
    if (dateMatch != null) {
      date = DateTime.tryParse(
        '${dateMatch.group(1)}-${dateMatch.group(2)}-${dateMatch.group(3)}',
      );
    }

    // 금액 패턴: 숫자 + 원 (예: 4,500원 → 4500)
    final amountRegex = RegExp(r'([\d,]+)원');
    final amountMatch = amountRegex.firstMatch(rawText);
    int? amount;
    if (amountMatch != null) {
      amount = int.tryParse(amountMatch.group(1)!.replaceAll(',', ''));
    }

    // 가맹점명: 첫 줄 또는 상호명 키워드 다음 텍스트
    // 단순화: 첫 줄을 가맹점명으로 간주
    final lines = rawText.split('\n').where((l) => l.trim().isNotEmpty).toList();
    final merchantName = lines.isNotEmpty ? lines.first.trim() : null;

    return ParsedOcrData(
      rawText: rawText,
      date: date,
      amount: amount,
      merchantName: merchantName,
      description: rawText.length > 50 ? rawText.substring(0, 50) : rawText,
    );
  }
}
