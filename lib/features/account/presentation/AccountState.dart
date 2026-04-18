import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/Account.dart';
import '../../../core/models/TypedId.dart';

part 'AccountState.freezed.dart';

/// 계정과목 BLoC 상태
@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState({
    /// 최상위 계정 목록 (5대 분류: 자산/부채/자본/수익/비용)
    @Default([]) List<Account> listRoots,

    /// 펼쳐진 노드 ID 집합 — 렌더링 시 해당 노드만 자식 표시
    @Default({}) Set<AccountId> setExpandedIds,

    /// 검색 결과 — 검색어에 매칭되는 계정 목록
    @Default([]) List<Account> listSearchResults,

    /// 로딩 상태
    @Default(false) bool isLoading,

    /// 에러 메시지 (null이면 에러 없음)
    String? errorMessage,
  }) = _AccountState;
}
