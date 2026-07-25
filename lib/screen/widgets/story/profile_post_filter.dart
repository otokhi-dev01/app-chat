import 'dart:ui';

import 'package:flutter/material.dart';

class ProfilePostFilter extends StatelessWidget {
  final bool showArchived;
  final ValueChanged<bool> onChanged;

  ProfilePostFilter({
    super.key,
    required this.showArchived,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color backgroundColor = isDark
        ? Color(0xFF17212B).withValues(
      alpha: 0.45,
    )
        : Colors.white.withValues(
      alpha: 0.50,
    );

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.05,
    );

    Color activeColor =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.18 : 0.12,
    );

    Color activeBorderColor =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.28 : 0.18,
    );

    Color shadowColor =
    Colors.black.withValues(
      alpha: isDark ? 0.15 : 0.04,
    );

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            20,
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
              width: 220,
              height: 48,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 12,
                    offset: Offset(
                      0,
                      4,
                    ),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                    ) {
                  double buttonGap = 4;

                  double buttonWidth =
                      (constraints.maxWidth -
                          buttonGap) /
                          2;

                  double indicatorLeft =
                  showArchived
                      ? buttonWidth +
                      buttonGap
                      : 0;

                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(
                          milliseconds: 260,
                        ),
                        curve:
                        Curves.easeOutCubic,
                        left: indicatorLeft,
                        top: 0,
                        bottom: 0,
                        width: buttonWidth,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration:
                            BoxDecoration(
                              color:
                              activeColor,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                16,
                              ),
                              border:
                              Border.all(
                                color:
                                activeBorderColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .stretch,
                        children: [
                          SizedBox(
                            width:
                            buttonWidth,
                            child:
                            _FilterButton(
                              title: 'Posts',
                              icon: Icons
                                  .grid_view_rounded,
                              selected:
                              !showArchived,
                              isDark: isDark,
                              onTap: () {
                                if (!showArchived) {
                                  return;
                                }

                                onChanged(false);
                              },
                            ),
                          ),
                          SizedBox(
                            width: buttonGap,
                          ),
                          SizedBox(
                            width:
                            buttonWidth,
                            child:
                            _FilterButton(
                              title: 'Archived',
                              icon: Icons
                                  .archive_outlined,
                              selected:
                              showArchived,
                              isDark: isDark,
                              onTap: () {
                                if (showArchived) {
                                  return;
                                }

                                onChanged(true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
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
    required this.title,
    required this.icon,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    Color inactiveTextColor = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    Color contentColor = selected
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
        highlightColor:
        Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<Color?>(
                duration: Duration(
                  milliseconds: 220,
                ),
                curve: Curves.easeOut,
                tween: ColorTween(
                  end: contentColor,
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
              SizedBox(width: 6),
              AnimatedDefaultTextStyle(
                duration: Duration(
                  milliseconds: 220,
                ),
                curve: Curves.easeOut,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 12,
                  height: 1,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
                child: Text(
                  title,
                  maxLines: 1,
                  softWrap: false,
                  overflow:
                  TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}