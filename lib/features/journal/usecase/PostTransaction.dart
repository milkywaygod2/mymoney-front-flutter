import '../../../core/domain/Transaction.dart';
import '../../../core/errors/DomainErrors.dart';
import '../../../core/interfaces/ITransactionRepository.dart';
import '../../../core/models/TypedId.dart';

/// Draft→Posted 전환 UseCase
/// INV-T1~T7 전체 검증은 Transaction.post()에서 수행
class PostTransaction {
  PostTransaction(this._repository);
  final ITransactionRepository _repository;

  /// Draft 조회 → post() → 저장 → 반환
  Future<Transaction> execute({
    required TransactionId id,
    required PeriodId periodId,
  }) async {
    final transaction = await _repository.findById(id);
    if (transaction == null) {
      throw InvariantViolationError('거래를 찾을 수 없습니다: id=$id');
    }

    // INV-T1~T7 전체 검증 (실패 시 DomainError throw)
    final posted = transaction.post(periodId: periodId);

    await _repository.save(posted);
    return posted;
  }
}
