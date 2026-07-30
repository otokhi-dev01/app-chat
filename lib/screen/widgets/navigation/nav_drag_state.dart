import 'package:flutter/gestures.dart';

/// Holds and computes drag state for the hold-and-move nav indicator.
/// No widget code here — just math, so it's trivial to test or fix
/// without touching any UI.
class NavDragState {
  final bool isDragging;
  final double? indicatorLeft;
  final int? hoveredIndex;

  const NavDragState({
    this.isDragging = false,
    this.indicatorLeft,
    this.hoveredIndex,
  });

  static const NavDragState idle = NavDragState();

  NavDragState start({required double startLeft, required int startIndex}) {
    return NavDragState(
      isDragging: true,
      indicatorLeft: startLeft,
      hoveredIndex: startIndex,
    );
  }

  /// Computes the next drag state from a raw pointer position, clamping
  /// the indicator so it never overshoots the first/last tab.
  NavDragState update({
    required LongPressMoveUpdateDetails details,
    required double totalWidth,
    required double indicatorWidth,
    required int itemCount,
  }) {
    double rawLeft = details.localPosition.dx - (indicatorWidth / 2);
    double clampedLeft = rawLeft.clamp(0.0, totalWidth - indicatorWidth);

    double itemWidth = totalWidth / itemCount;
    int nextIndex = (details.localPosition.dx / itemWidth)
        .floor()
        .clamp(0, itemCount - 1);

    return NavDragState(
      isDragging: true,
      indicatorLeft: clampedLeft,
      hoveredIndex: nextIndex,
    );
  }
}