import '../../../core/interfaces/ILegalParameterRepository.dart';
import '../../../infrastructure/database/AppDatabase.dart';
import 'LegalParameterDao.dart';

/// ILegalParameterRepository 구현체 — Drift LegalParameter row 반환
class LegalParameterRepository implements ILegalParameterRepository {
  LegalParameterRepository(this._dao);
  final LegalParameterDao _dao;

  /// 특정 시점에 유효한 법률 변수 조회
  ///
  /// 반환: [LegalParameter] Drift DataClass, 미존재 시 null
  @override
  Future<LegalParameter?> findEffective(
    String key,
    DateTime asOfDate, {
    String countryCode = 'KR',
  }) async {
    return _dao.findEffective(key, asOfDate, countryCode: countryCode);
  }

  /// 법률 변수 저장
  @override
  Future<void> save(LegalParametersCompanion legalParameter) async {
    await _dao.upsert(legalParameter);
  }
}
