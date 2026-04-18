import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/TypedId.dart';

part 'PerspectiveEvent.freezed.dart';

@freezed
abstract class PerspectiveEvent with _$PerspectiveEvent {
  const factory PerspectiveEvent.loadPresets() = LoadPresets;
  const factory PerspectiveEvent.selectPreset({required PerspectiveId id}) = SelectPreset;
  const factory PerspectiveEvent.openCustomFilter() = OpenCustomFilter;
  const factory PerspectiveEvent.applyCustomFilter({
    Map<String, List<int>>? mapDimensionFilters,
    Map<String, List<String>>? mapAttributeFilters,
    List<int>? listTagIds,
  }) = ApplyCustomFilter;
  const factory PerspectiveEvent.saveAsPreset({required String name}) = SaveAsPreset;
  const factory PerspectiveEvent.deletePreset({required PerspectiveId id}) = DeletePreset;
}
