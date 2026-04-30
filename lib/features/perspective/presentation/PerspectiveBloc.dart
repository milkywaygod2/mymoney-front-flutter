import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/Perspective.dart';
import '../../../core/interfaces/IPerspectiveRepository.dart';
import '../../../core/models/TypedId.dart';
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
    final mapDimFilters = <String, List<DimensionValueId>>{};
    event.mapDimensionFilters?.forEach((key, listIds) {
      mapDimFilters[key] = listIds.map((id) => DimensionValueId(id)).toList();
    });

    final listTagFilters = (event.listTagIds ?? [])
        .map((id) => TagId(id))
        .toList();

    final baseOwner = state.effectivePerspective?.ownerId ?? const OwnerId(1);

    final customPerspective = Perspective(
      id: const PerspectiveId(0),
      name: '커스텀 필터',
      ownerId: baseOwner,
      isSystem: false,
      mapDimensionFilters: mapDimFilters,
      mapAccountAttributeFilters: event.mapAttributeFilters ?? {},
      listTagFilters: listTagFilters,
    );

    emit(state.copyWith(
      effectivePerspective: customPerspective,
      isCustomFilterOpen: false,
    ));
  }

  Future<void> _onSaveAsPreset(SaveAsPreset event, Emitter<PerspectiveState> emit) async {
    final effective = state.effectivePerspective;
    if (effective == null) return;

    // 현재 effectivePerspective를 새 이름으로 복사하여 사용자 프리셋으로 저장
    // id=0 → insert (신규 프리셋), ownerId는 기존 유지
    final newPreset = Perspective(
      id: const PerspectiveId(0),
      name: event.name,
      ownerId: effective.ownerId,
      isSystem: false,
      mapDimensionFilters: effective.mapDimensionFilters,
      mapAccountAttributeFilters: effective.mapAccountAttributeFilters,
      listTagFilters: effective.listTagFilters,
      recordingDirection: effective.recordingDirection,
      baseCurrency: effective.baseCurrency,
      permissionLevel: effective.permissionLevel,
    );

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _repository.save(newPreset);
      add(const LoadPresets());
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeletePreset(DeletePreset event, Emitter<PerspectiveState> emit) async {
    await _repository.delete(event.id);
    add(const LoadPresets());
  }
}
