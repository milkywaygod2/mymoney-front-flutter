import '../../../core/constants/Enums.dart';
import '../../../core/interfaces/ITransactionRepository.dart';
import '../../../core/models/TypedId.dart';

/// 중복 탐지 결과
class DuplicateCandidate {
  const DuplicateCandidate({required this.transactionId, required this.score, required this.listReasons});
  final TransactionId transactionId;
  final int score;
  final List<String> listReasons;
  bool get isSuspected => score >= 70;
  bool get isAlmostCertain => score >= 90;
}

/// 거래 중복 탐지 - 점수 기반 (CW 섹션 8)
class DetectDuplicate {
  DetectDuplicate(this._repository);
  final ITransactionRepository _repository;

  Future<List<DuplicateCandidate>> execute({
    required DateTime date, required int baseAmount,
    String? counterpartyName, String? source,
  }) async {
    final from = date.subtract(const Duration(days: 1));
    final to = date.add(const Duration(days: 1));
    final listCandidates = await _repository.findByDateRange(from, to);
    final List<DuplicateCandidate> listResults = [];
    for (final candidate in listCandidates) {
      // 섹션 8.2: Draft 상태에서만 탐지
      if (candidate.status != TransactionStatus.draft) continue;
      int score = 0;
      final List<String> listReasons = [];
      final dayDiff = candidate.date.difference(date).inDays.abs();
      if (dayDiff == 0) { score += 40; listReasons.add('날짜 동일'); }
      else if (dayDiff <= 1) { score += 20; listReasons.add('날짜 +-1일'); }
      final debitSum = candidate.listLines
          .where((l) => l.entryType == EntryType.debit)
          .fold<int>(0, (s, l) => s + l.baseAmount);
      if (debitSum == baseAmount) { score += 30; listReasons.add('금액 동일'); }
      if (counterpartyName != null && candidate.counterpartyName != null &&
          candidate.counterpartyName!.contains(counterpartyName)) {
        score += 20; listReasons.add('거래처 일치');
      }
      if (source != null && candidate.source.name != source) {
        score += 10; listReasons.add('거래원천 상이');
      }
      if (score >= 70) {
        listResults.add(DuplicateCandidate(transactionId: candidate.id, score: score, listReasons: listReasons));
      }
    }
    listResults.sort((a, b) => b.score.compareTo(a.score));
    return listResults;
  }
}
