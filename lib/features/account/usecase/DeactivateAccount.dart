import '../../../core/domain/Account.dart';
import '../../../core/errors/DomainErrors.dart';
import '../../../core/interfaces/IAccountRepository.dart';
import '../../../core/models/TypedId.dart';

/// 계정과목 비활성화 (CW 섹션 12.2: 삭제 불가, 비활성화만)
class DeactivateAccount {
  DeactivateAccount(this._repository);
  final IAccountRepository _repository;

  Future<Account> execute({required AccountId id}) async {
    final account = await _repository.findById(id);
    if (account == null) {
      throw InvariantViolationError('계정을 찾을 수 없습니다: id=$id');
    }
    if (!account.isActive) {
      throw InvariantViolationError('이미 비활성화된 계정입니다: id=$id');
    }
    final deactivated = account.deactivate();
    await _repository.save(deactivated);
    return deactivated;
  }
}
