import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/TypedId.dart';
import '../constants/Enums.dart';
import '../errors/DomainErrors.dart';
import 'CounterpartyAlias.dart';

part 'Counterparty.freezed.dart';

/// 고유번호 유형 (사업자번호/주민번호 등)
enum IdentifierType { none, business, personal }

/// 거래처 매칭 신뢰도 수준
enum ConfidenceLevel { unknown, low, medium, high, verified }

/// Counterparty(거래처) — 거래 상대방 마스터 데이터.
/// OCR 별칭 매칭, 세무 연동(사업자번호), 특수관계자 판정에 사용.
@freezed
class Counterparty with _$Counterparty {
  const Counterparty._();

  const factory Counterparty._internal({
    required CounterpartyId id,

    /// 거래처 정식 명칭
    required String name,

    /// 고유번호 (사업자번호/주민번호 등)
    String? identifier,

    /// 고유번호 유형
    @Default(IdentifierType.none) IdentifierType identifierType,

    /// 연락처 (보조 매칭)
    String? phone,

    /// 주소 (보조 매칭)
    String? address,

    /// 신뢰도 수준 — OCR 매칭 정확성
    @Default(ConfidenceLevel.unknown) ConfidenceLevel confidenceLevel,

    /// 특수관계자 여부 (세무 확장 시 활성화)
    bool? isRelatedParty,

    /// 거래처 유형 (개인/법인/정부기관, 원천징수 판정용)
    String? counterpartyType,

    /// 국가 코드 (해외 확장 시)
    String? countryCode,

    /// OCR 표기 변형 목록 ("스타벅스", "STARBUCKS" 등)
    @Default([]) List<CounterpartyAlias> listAliases,
  }) = _Counterparty;

  /// 팩토리 메서드 — INV-C1, C2 강제 검증
  static Counterparty create({
    required CounterpartyId id,
    required String name,
    String? identifier,
    IdentifierType identifierType = IdentifierType.none,
    String? phone,
    String? address,
    ConfidenceLevel confidenceLevel = ConfidenceLevel.unknown,
    bool? isRelatedParty,
    String? counterpartyType,
    String? countryCode,
    List<CounterpartyAlias> listAliases = const [],
  }) {
    if (name.isEmpty) {
      throw InvariantViolationError('INV-C1: 거래처명은 비어있을 수 없습니다');
    }
    if (identifier != null && identifierType == IdentifierType.none) {
      throw InvariantViolationError('INV-C2: 고유번호가 있으면 identifierType을 지정해야 합니다');
    }
    return Counterparty._internal(
      id: id,
      name: name,
      identifier: identifier,
      identifierType: identifierType,
      phone: phone,
      address: address,
      confidenceLevel: confidenceLevel,
      isRelatedParty: isRelatedParty,
      counterpartyType: counterpartyType,
      countryCode: countryCode,
      listAliases: listAliases,
    );
  }

  /// 사업자번호 보유 여부 (세금계산서 발행 가능 판단)
  bool get hasBizNumber =>
      identifier != null && identifierType == IdentifierType.business;
}
