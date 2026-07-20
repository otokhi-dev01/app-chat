import 'dart:ui';
import 'package:flutter/material.dart';

class ProfilePostFilter extends StatefulWidget {
  final bool showArchived;
  final int postCount;
  final int archivedCount;
  final ValueChanged<bool> onChanged;

  ProfilePostFilter({
    super.key,
    required this.showArchived,
    required this.postCount,
    required this.archivedCount,
    required this.onChanged,
  });

  @override
  State<ProfilePostFilter> createState() {
    return _ProfilePostFilterState();
  }
}

class _ProfilePostFilterState extends State<ProfilePostFilter> {
  final GlobalKey _postsKey = GlobalKey();
  final GlobalKey _archivedKey = GlobalKey();
  final GlobalKey _stackKey = GlobalKey();

  Rect? _indicatorRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
    });
  }

  @override
  void didUpdateWidget(ProfilePostFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
    });
  }

  void _measure() {
    if (!mounted) {
      return;
    }

    GlobalKey activeKey = widget.showArchived ? _archivedKey : _postsKey;
    BuildContext? stackContext = _stackKey.currentContext;
    BuildContext? activeContext = activeKey.currentContext;

    if (stackContext == null || activeContext == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
      return;
    }

    RenderBox? stackBox = stackContext.findRenderObject() as RenderBox?;
    RenderBox? activeBox = activeContext.findRenderObject() as RenderBox?;

    if (stackBox == null || activeBox == null || !stackBox.hasSize || !activeBox.hasSize) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
      return;
    }

    Offset offset = activeBox.localToGlobal(
      Offset.zero,
      ancestor: stackBox,
    );

    Rect rect = offset & activeBox.size;

    if (rect != _indicatorRect) {
      setState(() {
        _indicatorRect = rect;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color backgroundColor = isDark
        ? Color(0xFF17212B).withValues(alpha: 0.45)
        : Colors.white.withValues(alpha: 0.50);

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.05);

    Color activeColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.18 : 0.12,
    );

    Color activeBorder = colorScheme.primary.withValues(
      alpha: 0.18,
    );

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
              height: 48,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.15 : 0.04,
                    ),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                key: _stackKey,
                alignment: Alignment.center,
                children: [
                  if (_indicatorRect != null)
                    AnimatedPositioned(
                      duration: Duration(
                        milliseconds: 260,
                      ),
                      curve: Curves.easeOutCubic,
                      left: _indicatorRect!.left,
                      top: _indicatorRect!.top,
                      width: _indicatorRect!.width,
                      height: _indicatorRect!.height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color: activeBorder,
                          ),
                        ),
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _FilterButton(
                        key: _postsKey,
                        title: 'Posts',
                        icon: Icons.grid_view_rounded,
                        selected: !widget.showArchived,
                        isDark: isDark,
                        onTap: () {
                          widget.onChanged(false);
                        },
                      ),
                      SizedBox(width: 4),
                      _FilterButton(
                        key: _archivedKey,
                        title: 'Archived',
                        icon: Icons.archive_outlined,
                        selected: widget.showArchived,
                        isDark: isDark,
                        onTap: () {
                          widget.onChanged(true);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  _FilterButton({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color inactiveTextColor = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    Color textColor = selected
        ? colorScheme.primary
        : inactiveTextColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(
        16,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          16,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          height: 40,
          constraints: BoxConstraints(
            minWidth: 82,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<Color?>(
                duration: Duration(
                  milliseconds: 220,
                ),
                curve: Curves.easeOut,
                tween: ColorTween(
                  end: textColor,
                ),
                builder: (
                  BuildContext context,
                  Color? color,
                  Widget? child,
                ) {
                  return Icon(
                    icon,
                    color: color,
                    size: 15,
                  );
                },
              ),
              SizedBox(width: 5),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: Duration(
                    milliseconds: 220,
                  ),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    height: 1,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
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