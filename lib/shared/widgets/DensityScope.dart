import 'package:flutter/material.dart';

enum UiDensity { minimal, normal, dense }

/// minimal/normal/dense 밀도 컨텍스트 InheritedWidget
class DensityScope extends InheritedWidget {
  const DensityScope({
    super.key,
    required this.density,
    required super.child,
  });

  final UiDensity density;

  static UiDensity of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DensityScope>();
    return scope?.density ?? UiDensity.normal;
  }

  @override
  bool updateShouldNotify(DensityScope oldWidget) => density != oldWidget.density;
}
