import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/Transaction.dart';

part 'JournalState.freezed.dart';

/// 거래 관리 상태
@freezed
abstract class JournalState with _$JournalState {
  const factory JournalState({
    @Default([]) List<Transaction> listTransactions,
    Transaction? selectedTransaction,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _JournalState;
}
