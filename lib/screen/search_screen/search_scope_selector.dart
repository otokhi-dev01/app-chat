import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/search/search_controller.dart';

/// ADDED: Interactive category filter bar with sliding indicator pill and drag gesture support
class SearchScopeSelector extends StatefulWidget {
  final SearchScope selectedScope;
  final ValueChanged<SearchScope> onScopeChanged;

  const SearchScopeSelector({
    super.key,
    required this.selectedScope,
    required this.onScopeChanged,
  });

  @override
  State<SearchScopeSelector> createState() {
    return _SearchScopeSelectorState();
  }
}

class _SearchScopeSelectorState extends State<SearchScopeSelector> {
  // ADDED: Drag position state for interactive sliding indicator
  double? _dragIndicatorLeft;
  bool _isDragging = false;

  double get itemGap => 3.0;
  double get itemHeight => 38.0;

  // ADDED: Search scopes paired with Cupertino icons
  List<_SearchScopeItem> get filterItems {
    return <_SearchScopeItem>[
      _SearchScopeItem(
        type: SearchScope.chats,
        title: 'chats'.tr,
        icon: CupertinoIcons.chat_bubble_2,
      ),
      _SearchScopeItem(
        type: SearchScope.contacts,
        title: 'contacts'.tr,
        icon: CupertinoIcons.person_2,
      ),
      _SearchScopeItem(
        type: SearchScope.all,
        title: 'all'.tr,
        icon: CupertinoIcons.square_grid_2x2,
      ),
    ];
  }

  int get selectedIndex {
    int index = filterItems.indexWhere(
          (_SearchScopeItem item) => item.type == widget.selectedScope,
    );
    return index < 0 ? 0 : index;
  }

  void _startDragging({
    required LongPressStartDetails details,
    required double itemWidth,
  }) {
    double selectedLeft = selectedIndex * (itemWidth + itemGap);
    Rect activeArea = Rect.fromLTWH(selectedLeft, 0, itemWidth, itemHeight);

    if (!activeArea.contains(details.localPosition)) return;

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
    if (!_isDragging) return;

    double nextLeft = details.localPosition.dx - itemWidth / 2;
    nextLeft = nextLeft.clamp(0.0, maximumLeft).toDouble();

    double indicatorCenter = nextLeft + itemWidth / 2;
    int nextIndex = (indicatorCenter / (itemWidth + itemGap)).floor();
    nextIndex = nextIndex.clamp(0, filterItems.length - 1).toInt();

    setState(() {
      _dragIndicatorLeft = nextLeft;
    });

    SearchScope nextScope = filterItems[nextIndex].type;
    if (widget.selectedScope != nextScope) {
      widget.onScopeChanged(nextScope);
    }
  }

  void _stopDragging() {
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

    // UPDATED: Unit UI colors for filter container and active sliding pill
    Color backgroundColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color activeColor = colorScheme.primary.withValues(alpha: 0.11);

    Color activeBorderColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.28 : 0.18,
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
              color: Colors.black.withValues(
                alpha: isDark ? 0.15 : 0.04,
              ),
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
              onLongPressStart: (details) => _startDragging(
                details: details,
                itemWidth: itemWidth,
              ),
              onLongPressMoveUpdate: (details) => _updateDragging(
                details: details,
                itemWidth: itemWidth,
                maximumLeft: maximumLeft,
              ),
              onLongPressEnd: (_) => _stopDragging(),
              onLongPressCancel: _stopDragging,
              child: Stack(
                children: [
                  // ADDED: Animated sliding active pill indicator
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
                        ),
                      ),
                    ),
                  ),

                  // Filter Buttons Row
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
      _SearchScopeItem item = filterItems[index];

      widgets.add(
        SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: _FilterButton(
            title: item.title,
            icon: item.icon,
            selected: widget.selectedScope == item.type,
            onTap: () {
              if (_isDragging || widget.selectedScope == item.type) return;
              widget.onScopeChanged(item.type);
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

class _SearchScopeItem {
  final SearchScope type;
  final String title;
  final IconData icon;

  _SearchScopeItem({
    required this.type,
    required this.title,
    required this.icon,
  });
}

class _FilterButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterButton({
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
                  return Icon(icon, color: color, size: 15);
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