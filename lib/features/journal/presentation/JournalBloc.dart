import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/Transaction.dart';
import '../../../core/interfaces/ITransactionRepository.dart';
import '../usecase/CreateTransaction.dart';
import '../usecase/PostTransaction.dart';
import 'JournalEvent.dart';
import 'JournalState.dart';

/// 거래 관리 BLoC
class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc({
    required ITransactionRepository repository,
    required CreateTransaction createTransaction,
    required PostTransaction postTransaction,
  })  : _repository = repository,
        _createTransaction = createTransaction,
        _postTransaction = postTransaction,
        super(const JournalState()) {
    on<LoadTransactions>(_onLoad);
    on<SelectTransaction>(_onSelect);
    on<CreateTransactionEvent>(_onCreate);
    on<PostTransactionEvent>(_onPost);
    on<DeleteTransactionEvent>(_onDelete);
  }

  final ITransactionRepository _repository;
  final CreateTransaction _createTransaction;
  final PostTransaction _postTransaction;

  Future<void> _onLoad(
    LoadTransactions event,
    Emitter<JournalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final now = DateTime.now();
      final threeMonthsAgo = now.subtract(const Duration(days: 90));
      final List<Transaction> listTransactions;
      if (event.perspective != null) {
        listTransactions = await _repository.findByPerspective(
          event.perspective!,
          from: threeMonthsAgo,
          to: now,
          limit: event.limit,
        );
      } else {
        listTransactions = await _repository.findByDateRange(
          threeMonthsAgo,
          now,
        );
      }
      emit(state.copyWith(
        listTransactions: listTransactions,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSelect(
    SelectTransaction event,
    Emitter<JournalState> emit,
  ) async {
    final tx = await _repository.findById(event.id);
    emit(state.copyWith(selectedTransaction: tx));
  }

  Future<void> _onCreate(
    CreateTransactionEvent event,
    Emitter<JournalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _createTransaction.execute(
        date: event.date,
        description: event.description,
        listLineInputs: event.listLineInputs,
        counterpartyId: event.counterpartyId,
        counterpartyName: event.counterpartyName,
      );
      add(const LoadTransactions()); // 목록 새로고침
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onPost(
    PostTransactionEvent event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await _postTransaction.execute(id: event.id, periodId: event.periodId);
      add(const LoadTransactions());
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteTransactionEvent event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await _repository.delete(event.id);
      add(const LoadTransactions());
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
