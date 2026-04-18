import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/interfaces/IPerspectiveRepository.dart';
import 'PerspectiveEvent.dart';
import 'PerspectiveState.dart';

/// Perspective BLoC - Lens Switcher 상태 관리
class PerspectiveBloc extends Bloc<PerspectiveEvent, PerspectiveState> {
  PerspectiveBloc({required IPerspectiveRepository repository})
      : _repository = repository,
        super(const PerspectiveState()) {
    on<LoadPresets>(_onLoadPresets);
    on<SelectPreset>(_onSelectPreset);
    on<OpenCustomFilter>(_onOpenCustomFilter);
    on<ApplyCustomFilter>(_onApplyCustomFilter);
    on<SaveAsPreset>(_onSaveAsPreset);
    on<DeletePreset>(_onDeletePreset);
  }

  final IPerspectiveRepository _repository;

  Future<void> _onLoadPresets(LoadPresets event, Emitter<PerspectiveState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final listSystem = await _repository.findSystem();
      emit(state.copyWith(listPresets: listSystem, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSelectPreset(SelectPreset event, Emitter<PerspectiveState> emit) async {
    final selected = await _repository.findById(event.id);
    emit(state.copyWith(activePresetId: event.id, effectivePerspective: selected));
  }

  void _onOpenCustomFilter(OpenCustomFilter event, Emitter<PerspectiveState> emit) {
    emit(state.copyWith(isCustomFilterOpen: !state.isCustomFilterOpen));
  }

  void _onApplyCustomFilter(ApplyCustomFilter event, Emitter<PerspectiveState> emit) {
    // TODO: 커스텀 필터 → effectivePerspective 생성
    emit(state.copyWith(isCustomFilterOpen: false));
  }

  Future<void> _onSaveAsPreset(SaveAsPreset event, Emitter<PerspectiveState> emit) async {
    // TODO: effectivePerspective를 이름 붙여 저장
  }

  Future<void> _onDeletePreset(DeletePreset event, Emitter<PerspectiveState> emit) async {
    await _repository.delete(event.id);
    add(const LoadPresets());
  }
}
