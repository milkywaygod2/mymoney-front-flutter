import 'package:drift/drift.dart';

import '../../../core/models/TypedId.dart';
import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/ClassificationRuleTable.dart';

/// OCR 텍스트 → 계정과목/거래처 자동 매핑 결과
class ClassificationResult {
  final AccountId accountId;
  final CounterpartyId? counterpartyId;

  /// 매칭 신뢰도 (0.0 ~ 1.0)
  final double confidence;

  /// 매칭에 사용된 규칙 ID (디버깅/피드백용)
  final ClassificationRuleId matchedRuleId;

  const ClassificationResult({
    required this.accountId,
    this.counterpartyId,
    required this.confidence,
    required this.matchedRuleId,
  });
}

/// 로직트리 분류 엔진 — ClassificationRules 테이블 기반 패턴 매칭
///
/// 매칭 순서: priority DESC → 첫 번째 매칭 규칙 반환 (short-circuit)
/// 패턴 유형:
///   EXACT    — rawText == pattern (대소문자 무시)
///   CONTAINS — rawText.contains(pattern) (대소문자 무시)
///   REGEX    — RegExp(pattern).hasMatch(rawText)
class ClassificationEngine {
  ClassificationEngine(this._db);
  final AppDatabase _db;

  /// [rawText] OCR/CSV 원시 텍스트로 규칙 매칭 시도.
  /// 매칭 성공 시 [ClassificationResult] 반환, 실패 시 null.
  Future<ClassificationResult?> classify(String rawText) async {
    // 우선순위 내림차순으로 전체 활성 규칙 조회
    final listRules = await (_db.select(_db.classificationRules)
          ..orderBy([(r) => OrderingTerm(
                expression: r.priority,
                mode: OrderingMode.desc,
              )]))
        .get();

    for (final rule in listRules) {
      if (_matches(rawText, rule.pattern, rule.patternType)) {
        // 시스템 규칙보다 사용자 규칙이 신뢰도 높음
        final isUserRule = rule.isUserRule;
        final confidence = isUserRule ? 0.9 : 0.75;

        return ClassificationResult(
          accountId: AccountId(rule.accountId),
          counterpartyId: rule.counterpartyId != null
              ? CounterpartyId(rule.counterpartyId!)
              : null,
          confidence: confidence,
          matchedRuleId: ClassificationRuleId(rule.id),
        );
      }
    }
    return null;
  }

  /// "이 패턴 기억하기" — 사용자 정의 규칙 저장
  ///
  /// 동일 pattern+patternType 조합이 이미 있으면 accountId만 갱신 (upsert 효과).
  Future<void> rememberPattern({
    required String pattern,
    required String patternType,
    required AccountId accountId,
    CounterpartyId? counterpartyId,
  }) async {
    // 기존 사용자 규칙 중 같은 패턴이 있는지 확인
    final existing = await (_db.select(_db.classificationRules)
          ..where((r) => r.pattern
              .equals(pattern)
              .and(r.patternType.equals(patternType))
              .and(r.isUserRule.equals(true))))
        .getSingleOrNull();

    if (existing != null) {
      // 기존 규칙 accountId 갱신
      await (_db.update(_db.classificationRules)
            ..where((r) => r.id.equals(existing.id)))
          .write(ClassificationRulesCompanion(
        accountId: Value(accountId.value),
        counterpartyId: counterpartyId != null
            ? Value(counterpartyId.value)
            : const Value.absent(),
      ));
    } else {
      // 사용자 규칙은 priority=100으로 시스템 규칙(priority=0)보다 우선
      await _db.into(_db.classificationRules).insert(
            ClassificationRulesCompanion.insert(
              pattern: pattern,
              patternType: patternType,
              accountId: accountId.value,
              counterpartyId: counterpartyId != null
                  ? Value(counterpartyId.value)
                  : const Value.absent(),
              priority: const Value(100),
              isSystemRule: const Value(false),
              isUserRule: const Value(true),
            ),
          );
    }
  }

  // ---------------------------------------------------------------------------
  // 내부 매칭 로직
  // ---------------------------------------------------------------------------

  bool _matches(String rawText, String pattern, String patternType) {
    final textLower = rawText.toLowerCase();
    final patternLower = pattern.toLowerCase();

    switch (patternType) {
      case 'EXACT':
        return textLower == patternLower;
      case 'CONTAINS':
        return textLower.contains(patternLower);
      case 'REGEX':
        // REGEX는 대소문자 구분 그대로 적용 (패턴 작성자의 의도 존중)
        return RegExp(pattern).hasMatch(rawText);
      default:
        // 알 수 없는 패턴 유형은 CONTAINS로 fallback
        return textLower.contains(patternLower);
    }
  }
}
