import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/Perspective.dart';
import '../../../core/models/TypedId.dart';

part 'PerspectiveState.freezed.dart';

@freezed
abstract class PerspectiveState with _$PerspectiveState {
  const factory PerspectiveState({
    @Default([]) List<Perspective> listPresets,
    PerspectiveId? activePresetId,
    Perspective? effectivePerspective,
    @Default(false) bool isCustomFilterOpen,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _PerspectiveState;
}
