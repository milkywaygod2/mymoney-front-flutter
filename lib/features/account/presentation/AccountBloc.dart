import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/Account.dart';
import '../../../core/interfaces/IAccountRepository.dart';
import '../../../core/models/TypedId.dart';
import 'AccountEvent.dart';
import 'AccountState.dart';

/// 계정과목 BLoC — 트리 CRUD + 펼치기/접기 + 검색
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc(this._repository) : super(const AccountState()) {
    on<LoadAccountTree>(_onLoadTree);
    on<CreateAccount>(_onCreateAccount);
    on<DeactivateAccount>(_onDeactivateAccount);
    on<ExpandNode>(_onExpandNode);
    on<CollapseNode>(_onCollapseNode);
    on<SearchAccounts>(_onSearchAccounts);
  }

  final IAccountRepository _repository;

  /// 계정과목 트리 로딩 — 활성 계정만 조회 후 nature별 루트 구성
  Future<void> _onLoadTree(
    LoadAccountTree event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final listAccounts = await _repository.findActive();
      // nature별 최상위 계정만 루트로 — 하위 계정은 equityTypePath로 판별
      final listRoots = listAccounts
          .where((a) => !a.equityTypePath.contains('.'))
          .toList();
      emit(state.copyWith(listRoots: listRoots, isLoading: false));
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// 계정과목 생성 — Account.create 팩토리 호출 후 저장, 트리 리로드
  Future<void> _onCreateAccount(
    CreateAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final account = Account.create(
        id: const AccountId(0), // DB auto-increment 대기
        name: event.name,
        nature: event.nature,
        equityTypeId: event.equityTypeId,
        equityTypePath: event.equityTypePath,
        liquidityId: event.liquidityId,
        liquidityPath: event.liquidityPath,
        assetTypeId: event.assetTypeId,
        assetTypePath: event.assetTypePath,
        ownerId: event.ownerId,
        defaultActivityTypeId: event.defaultActivityTypeId,
        defaultIncomeTypeId: event.defaultIncomeTypeId,
        productType: event.productType,
        financialInstitution: event.financialInstitution,
      );
      await _repository.save(account);
      // 트리 리로드
      add(const AccountEvent.loadTree());
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// 계정 비활성화 — 조회 후 deactivate, 트리 리로드
  Future<void> _onDeactivateAccount(
    DeactivateAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final account = await _repository.findById(event.id);
      if (account != null) {
        await _repository.save(account.deactivate());
      }
      add(const AccountEvent.loadTree());
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// 트리 노드 펼치기 — expandedIds에 추가
  void _onExpandNode(
    ExpandNode event,
    Emitter<AccountState> emit,
  ) {
    final setUpdated = {...state.setExpandedIds, event.id};
    emit(state.copyWith(setExpandedIds: setUpdated));
  }

  /// 트리 노드 접기 — expandedIds에서 제거
  void _onCollapseNode(
    CollapseNode event,
    Emitter<AccountState> emit,
  ) {
    final setUpdated = {...state.setExpandedIds}..remove(event.id);
    emit(state.copyWith(setExpandedIds: setUpdated));
  }

  /// 계정과목 검색 — 이름에 검색어 포함된 활성 계정 필터링
  Future<void> _onSearchAccounts(
    SearchAccounts event,
    Emitter<AccountState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(listSearchResults: []));
      return;
    }
    try {
      final listAll = await _repository.findActive();
      final listFiltered = listAll
          .where((a) => a.name.contains(event.query))
          .toList();
      emit(state.copyWith(listSearchResults: listFiltered));
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
