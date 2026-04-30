import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/TypedId.dart';
import '../../../features/ocr/presentation/OcrBloc.dart';

// =============================================================================
// 이벤트
// =============================================================================

sealed class EntryEvent {
  const EntryEvent();
}

/// 자연어 입력 텍스트 변경
class EntryNaturalTextChanged extends EntryEvent {
  const EntryNaturalTextChanged(this.text);
  final String text;
}

/// 자연어 파싱 실행 (V1)
class EntryParseNaturalText extends EntryEvent {
  const EntryParseNaturalText();
}

/// 숫자패드 입력 (V2)
class EntryNumPadPressed extends EntryEvent {
  const EntryNumPadPressed(this.digit);
  final String digit; // '0'~'9', '.', 'C', '⌫'
}

/// V2 계정 선택
class EntryDebitAccountSelected extends EntryEvent {
  const EntryDebitAccountSelected(this.accountId);
  final AccountId accountId;
}

class EntryCreditAccountSelected extends EntryEvent {
  const EntryCreditAccountSelected(this.accountId);
  final AccountId accountId;
}

/// OCR 결과 수신 (V3 → V1/V2 채우기)
class EntryOcrResultReceived extends EntryEvent {
  const EntryOcrResultReceived({
    required this.parsed,
    this.suggestedDebitId,
    this.suggestedCreditId,
  });
  final ParsedOcrData parsed;
  final AccountId? suggestedDebitId;
  final AccountId? suggestedCreditId;
}

/// 모드 전환 (V1/V2/V3)
class EntryModeChanged extends EntryEvent {
  const EntryModeChanged(this.mode);
  final EntryMode mode;
}

/// 저장 실행
class EntrySave extends EntryEvent {
  const EntrySave();
}

/// 저장 후 애니메이션 완료 → 닫기
class EntryAnimationFinished extends EntryEvent {
  const EntryAnimationFinished();
}

/// 초기화
class EntryReset extends EntryEvent {
  const EntryReset();
}

// =============================================================================
// 상태
// =============================================================================

enum EntryMode { v1Natural, v2NumPad, v3Ocr }

enum EntryStatus { idle, parsing, saving, done, error }

class EntryState {
  const EntryState({
    this.mode = EntryMode.v1Natural,
    this.status = EntryStatus.idle,
    this.naturalText = '',
    this.amountDisplay = '0',
    this.parsedAmount,
    this.parsedDescription,
    this.parsedDate,
    this.accountHint,
    this.debitAccountId,
    this.creditAccountId,
    this.errorMessage,
    this.savedTransactionDescription,
  });

  final EntryMode mode;
  final EntryStatus status;

  // V1 — 자연어
  final String naturalText;
  final int? parsedAmount;
  final String? parsedDescription;
  /// NLP로 추출된 날짜 힌트
  final DateTime? parsedDate;
  /// NLP로 추출된 차변 계정 추천 힌트 (예: '식비', '교통비')
  final String? accountHint;

  // V2 — 숫자패드
  final String amountDisplay;
  final AccountId? debitAccountId;
  final AccountId? creditAccountId;

  final String? errorMessage;
  /// 저장 완료 후 애니메이션에 사용할 거래 설명
  final String? savedTransactionDescription;

  bool get canSave {
    final amount = parsedAmount ?? _parseAmountDisplay();
    return amount != null && amount > 0 &&
        debitAccountId != null &&
        creditAccountId != null;
  }

  int? _parseAmountDisplay() {
    final v = int.tryParse(amountDisplay.replaceAll(',', ''));
    return v == 0 ? null : v;
  }

  EntryState copyWith({
    EntryMode? mode,
    EntryStatus? status,
    String? naturalText,
    String? amountDisplay,
    int? parsedAmount,
    String? parsedDescription,
    DateTime? parsedDate,
    String? accountHint,
    AccountId? debitAccountId,
    AccountId? creditAccountId,
    String? errorMessage,
    String? savedTransactionDescription,
  }) {
    return EntryState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      naturalText: naturalText ?? this.naturalText,
      amountDisplay: amountDisplay ?? this.amountDisplay,
      parsedAmount: parsedAmount ?? this.parsedAmount,
      parsedDescription: parsedDescription ?? this.parsedDescription,
      parsedDate: parsedDate ?? this.parsedDate,
      accountHint: accountHint ?? this.accountHint,
      debitAccountId: debitAccountId ?? this.debitAccountId,
      creditAccountId: creditAccountId ?? this.creditAccountId,
      errorMessage: errorMessage,
      savedTransactionDescription:
          savedTransactionDescription ?? this.savedTransactionDescription,
    );
  }
}

// =============================================================================
// BLoC
// =============================================================================

/// EntryBloc — 거래 입력 관리 (V1 자연어 / V2 숫자패드 / V3 OCR)
class EntryBloc extends Bloc<EntryEvent, EntryState> {
  EntryBloc() : super(const EntryState()) {
    on<EntryNaturalTextChanged>(_onTextChanged);
    on<EntryParseNaturalText>(_onParseText);
    on<EntryNumPadPressed>(_onNumPad);
    on<EntryDebitAccountSelected>(_onDebitSelected);
    on<EntryCreditAccountSelected>(_onCreditSelected);
    on<EntryOcrResultReceived>(_onOcrResult);
    on<EntryModeChanged>(_onModeChanged);
    on<EntrySave>(_onSave);
    on<EntryAnimationFinished>(_onAnimationFinished);
    on<EntryReset>(_onReset);
  }

  void _onTextChanged(EntryNaturalTextChanged e, Emitter<EntryState> emit) {
    emit(state.copyWith(naturalText: e.text));
  }

  static const Map<String, String> _keywordMap = {
    '카드': '신용카드',
    '신용': '신용카드',
    '현금': '현금',
    '식사': '식비',
    '음식': '식비',
    '밥': '식비',
    '카페': '식비',
    '커피': '식비',
    '점심': '식비',
    '저녁': '식비',
    '아침': '식비',
    '교통': '교통비',
    '버스': '교통비',
    '지하철': '교통비',
    '택시': '교통비',
    '마트': '생활용품비',
    '쇼핑': '쇼핑비',
    '편의점': '생활용품비',
    '병원': '의료비',
    '약': '의료비',
    '통신': '통신비',
    '구독': '통신비',
  };

  /// 자연어 파서 — 금액·날짜·상점·계정 키워드 추출
  void _onParseText(EntryParseNaturalText _, Emitter<EntryState> emit) {
    emit(state.copyWith(status: EntryStatus.parsing));

    final text = state.naturalText;
    final now = DateTime.now();

    // ── 금액 추출 ──────────────────────────────────────────
    final amountMatch = RegExp(r'(\d[\d,.]*)(\s*원)?').firstMatch(text);
    int? amount;
    if (amountMatch != null) {
      final raw = amountMatch.group(1)!.replaceAll(',', '').replaceAll('.', '');
      amount = int.tryParse(raw);
    }

    // ── 날짜 추출 ──────────────────────────────────────────
    DateTime? parsedDate;
    if (text.contains('오늘')) {
      parsedDate = DateTime(now.year, now.month, now.day);
    } else if (text.contains('어제')) {
      final y = now.subtract(const Duration(days: 1));
      parsedDate = DateTime(y.year, y.month, y.day);
    } else {
      final daysAgoMatch = RegExp(r'(\d+)\s*일\s*전').firstMatch(text);
      if (daysAgoMatch != null) {
        final days = int.tryParse(daysAgoMatch.group(1)!) ?? 0;
        final d = now.subtract(Duration(days: days));
        parsedDate = DateTime(d.year, d.month, d.day);
      } else {
        final mdMatch = RegExp(r'(\d{1,2})[/.](\d{1,2})').firstMatch(text)
            ?? RegExp(r'(\d{1,2})월\s*(\d{1,2})일').firstMatch(text);
        if (mdMatch != null) {
          parsedDate = DateTime(now.year, int.parse(mdMatch.group(1)!), int.parse(mdMatch.group(2)!));
        }
      }
    }

    // ── 상점/설명 추출 ─────────────────────────────────────
    var descText = text
        .replaceAll(RegExp(r'\d[\d,.]*\s*원?'), '')
        .replaceAll(RegExp(r'\d+\s*일\s*전'), '')
        .replaceAll(RegExp(r'\d{1,2}[/.]\d{1,2}'), '')
        .replaceAll(RegExp(r'\d{1,2}월\s*\d{1,2}일'), '')
        .replaceAll(RegExp(r'오늘|어제'), '')
        .replaceAll(RegExp(r'에서|에게|한테|으로|를|을|이|가|은|는|샀어|결제|지불|냈어'), '')
        .trim();
    if (descText.isEmpty) descText = text;
    final description = descText.length > 20 ? descText.substring(0, 20) : descText;

    // ── 계정 키워드 추출 (키워드 맵 순차 매칭) ─────────────
    String? accountHint;
    for (final entry in _keywordMap.entries) {
      if (text.contains(entry.key)) {
        accountHint = entry.value;
        break;
      }
    }

    emit(state.copyWith(
      status: EntryStatus.idle,
      parsedAmount: amount,
      parsedDescription: description.isEmpty ? null : description,
      parsedDate: parsedDate,
      accountHint: accountHint,
      amountDisplay: amount != null ? _formatAmount(amount) : '0',
    ));
  }

  void _onNumPad(EntryNumPadPressed e, Emitter<EntryState> emit) {
    final current = state.amountDisplay.replaceAll(',', '');

    String next;
    switch (e.digit) {
      case 'C':
        next = '0';
      case '⌫':
        next = current.length <= 1 ? '0' : current.substring(0, current.length - 1);
      case '.':
        next = current.contains('.') ? current : '$current.';
      default:
        next = current == '0' ? e.digit : current + e.digit;
    }

    // 최대 12자리 제한
    if (next.replaceAll('.', '').length > 12) return;

    final parsed = int.tryParse(next.replaceAll('.', ''));
    emit(state.copyWith(
      amountDisplay: _formatAmount(parsed ?? 0),
      parsedAmount: parsed,
    ));
  }

  void _onDebitSelected(EntryDebitAccountSelected e, Emitter<EntryState> emit) {
    emit(state.copyWith(debitAccountId: e.accountId));
  }

  void _onCreditSelected(EntryCreditAccountSelected e, Emitter<EntryState> emit) {
    emit(state.copyWith(creditAccountId: e.accountId));
  }

  void _onOcrResult(EntryOcrResultReceived e, Emitter<EntryState> emit) {
    final parsed = e.parsed;
    emit(state.copyWith(
      naturalText: parsed.rawText,
      parsedAmount: parsed.amount,
      parsedDescription: parsed.description,
      amountDisplay: parsed.amount != null
          ? _formatAmount(parsed.amount!)
          : state.amountDisplay,
      debitAccountId: e.suggestedDebitId ?? state.debitAccountId,
      creditAccountId: e.suggestedCreditId ?? state.creditAccountId,
    ));
  }

  void _onModeChanged(EntryModeChanged e, Emitter<EntryState> emit) {
    emit(state.copyWith(mode: e.mode));
  }

  Future<void> _onSave(EntrySave _, Emitter<EntryState> emit) async {
    if (!state.canSave) return;
    emit(state.copyWith(status: EntryStatus.saving));

    // TODO: CreateTransaction UseCase 연동 (DI 구성 후)
    // 현재는 1초 stub 딜레이로 저장 시뮬레이션
    await Future<void>.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(
      status: EntryStatus.done,
      savedTransactionDescription: state.parsedDescription ?? '거래 입력',
    ));
  }

  void _onAnimationFinished(EntryAnimationFinished _, Emitter<EntryState> emit) {
    emit(const EntryState());
  }

  void _onReset(EntryReset _, Emitter<EntryState> emit) {
    emit(const EntryState());
  }

  String _formatAmount(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
