import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// REPLACED: Custom interactive CallFilterSegment with sliding indicator pill, drag gestures, and unit UI styling
class CallFilterSegment extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const CallFilterSegment({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<CallFilterSegment> createState() {
    return _CallFilterSegmentState();
  }
}

class _CallFilterSegmentState extends State<CallFilterSegment> {
  // UPDATED: Indicator position tracking for interactive long-press dragging
  double? _dragIndicatorLeft;
  bool _isDragging = false;

  double get itemGap => 3.0;
  double get itemHeight => 38.0;

  // ADDED: Call filter items ("All Calls" & "Missed") paired with Cupertino icons
  List<CallFilterItem> get filterItems {
    return <CallFilterItem>[
      CallFilterItem(
        index: 0,
        title: 'All Calls',
        icon: CupertinoIcons.phone,
      ),
      CallFilterItem(
        index: 1,
        title: 'Missed',
        icon: CupertinoIcons.phone_down_fill,
      ),
    ];
  }

  int get selectedIndex {
    int index = filterItems.indexWhere(
          (CallFilterItem item) => item.index == widget.selectedIndex,
    );
    return index < 0 ? 0 : index;
  }

  void _startDragging({
    required LongPressStartDetails details,
    required double itemWidth,
  }) {
    double selectedLeft = selectedIndex * (itemWidth + itemGap);

    Rect activeArea = Rect.fromLTWH(
      selectedLeft,
      0,
      itemWidth,
      itemHeight,
    );

    if (!activeArea.contains(details.localPosition)) {
      return;
    }

    setState(() {
      _isDragging = true;
      _dragIndicatorLeft = selectedLeft;
    });
  }

  void _updateDragging({
    required LongPressMoveUpdateDetails details,
    required double itemWidth,
    required double maximumLeft,
  }) {
    if (!_isDragging) {
      return;
    }

    double nextLeft = details.localPosition.dx - itemWidth / 2;
    nextLeft = nextLeft.clamp(0.0, maximumLeft).toDouble();

    double indicatorCenter = nextLeft + itemWidth / 2;
    int nextIndex = (indicatorCenter / (itemWidth + itemGap)).floor();
    nextIndex = nextIndex.clamp(0, filterItems.length - 1).toInt();

    setState(() {
      _dragIndicatorLeft = nextLeft;
    });

    int nextFilterIndex = filterItems[nextIndex].index;
    if (widget.selectedIndex != nextFilterIndex) {
      widget.onIndexChanged(nextFilterIndex);
    }
  }

  void _stopDragging() {
    if (!_isDragging) return;
    setState(() {
      _isDragging = false;
      _dragIndicatorLeft = null;
    });
  }

  void _cancelDragging() {
    if (!_isDragging) return;
    setState(() {
      _isDragging = false;
      _dragIndicatorLeft = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    // UPDATED: Theme-aware colors matching unit UI glass container and active indicator borders
    Color backgroundColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color activeColor = colorScheme.primary.withValues(alpha: 0.11);

    Color activeBorderColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.28 : 0.18,
    );

    Color shadowColor = Colors.black.withValues(
      alpha: isDark ? 0.15 : 0.04,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        height: 48,
        padding: const EdgeInsets.all(4),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double totalGap = itemGap * (filterItems.length - 1);
            double itemWidth =
                (constraints.maxWidth - totalGap) / filterItems.length;

            double normalIndicatorLeft = selectedIndex * (itemWidth + itemGap);

            double indicatorLeft = _isDragging && _dragIndicatorLeft != null
                ? _dragIndicatorLeft!
                : normalIndicatorLeft;

            double maximumLeft = constraints.maxWidth - itemWidth;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPressStart: (LongPressStartDetails details) {
                _startDragging(
                  details: details,
                  itemWidth: itemWidth,
                );
              },
              onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
                _updateDragging(
                  details: details,
                  itemWidth: itemWidth,
                  maximumLeft: maximumLeft,
                );
              },
              onLongPressEnd: (LongPressEndDetails details) {
                _stopDragging();
              },
              onLongPressCancel: _cancelDragging,
              child: Stack(
                children: [
                  // UPDATED: Sliding active indicator pill with animated positioning and 18px radius
                  AnimatedPositioned(
                    duration: _isDragging
                        ? Duration.zero
                        : const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    left: indicatorLeft,
                    top: 0,
                    width: itemWidth,
                    height: itemHeight,
                    child: IgnorePointer(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: activeBorderColor),
                          boxShadow: _isDragging
                              ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(
                                alpha: 0.12,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                              : [],
                        ),
                      ),
                    ),
                  ),

                  // UPDATED: Filter item buttons row
                  Row(
                    children: _buildButtons(itemWidth: itemWidth),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildButtons({required double itemWidth}) {
    List<Widget> widgets = <Widget>[];

    for (int index = 0; index < filterItems.length; index++) {
      CallFilterItem item = filterItems[index];

      widgets.add(
        SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: _CallFilterButton(
            title: item.title,
            icon: item.icon,
            selected: widget.selectedIndex == item.index,
            onTap: () {
              if (_isDragging || widget.selectedIndex == item.index) return;
              widget.onIndexChanged(item.index);
            },
          ),
        ),
      );

      if (index < filterItems.length - 1) {
        widgets.add(SizedBox(width: itemGap));
      }
    }

    return widgets;
  }
}

class CallFilterItem {
  final int index;
  final String title;
  final IconData icon;

  CallFilterItem({
    required this.index,
    required this.title,
    required this.icon,
  });
}

class _CallFilterButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CallFilterButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.60)
        : Colors.black.withValues(alpha: 0.60);

    Color contentColor = selected ? colorScheme.primary : inactiveColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                tween: ColorTween(end: contentColor),
                builder: (context, Color? color, child) {
                  return Icon(
                    icon,
                    color: color,
                    size: 15,
                  );
                },
              ),
              const SizedBox(width: 4),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 12,
                    height: 1,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}