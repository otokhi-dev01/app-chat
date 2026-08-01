import 'dart:ui';

import 'package:flutter/material.dart';

enum ProfileContentFilterType {
  posts,
  media,
  links,
  files,
  voice,
}

class ProfileContentFilter extends StatefulWidget {
  final ProfileContentFilterType selectedFilter;
  final ValueChanged<ProfileContentFilterType> onChanged;

  ProfileContentFilter({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  State<ProfileContentFilter> createState() {
    return _ProfileContentFilterState();
  }
}

class _ProfileContentFilterState
    extends State<ProfileContentFilter> {
  double? _dragIndicatorLeft;
  bool _isDragging = false;

  double get itemGap {
    return 3;
  }

  double get itemHeight {
    return 38;
  }

  List<ProfileContentFilterItem> get filterItems {
    return <ProfileContentFilterItem>[
      ProfileContentFilterItem(
        type: ProfileContentFilterType.posts,
        title: 'Posts',
        icon: Icons.grid_view_rounded,
      ),
      ProfileContentFilterItem(
        type: ProfileContentFilterType.media,
        title: 'Media',
        icon: Icons.perm_media_outlined,
      ),
      ProfileContentFilterItem(
        type: ProfileContentFilterType.links,
        title: 'Links',
        icon: Icons.link_rounded,
      ),
      ProfileContentFilterItem(
        type: ProfileContentFilterType.files,
        title: 'Files',
        icon: Icons.insert_drive_file_outlined,
      ),
      ProfileContentFilterItem(
        type: ProfileContentFilterType.voice,
        title: 'Voice',
        icon: Icons.mic_none_rounded,
      ),
    ];
  }

  int get selectedIndex {
    int index = filterItems.indexWhere(
          (
          ProfileContentFilterItem item,
          ) {
        return item.type ==
            widget.selectedFilter;
      },
    );

    return index < 0 ? 0 : index;
  }

  void _startDragging({
    required LongPressStartDetails details,
    required double itemWidth,
  }) {
    double selectedLeft = selectedIndex *
        (itemWidth + itemGap);

    Rect activeArea = Rect.fromLTWH(
      selectedLeft,
      0,
      itemWidth,
      itemHeight,
    );

    if (!activeArea.contains(
      details.localPosition,
    )) {
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

    double nextLeft =
        details.localPosition.dx -
            itemWidth / 2;

    nextLeft = nextLeft
        .clamp(
      0.0,
      maximumLeft,
    )
        .toDouble();

    double indicatorCenter =
        nextLeft + itemWidth / 2;

    int nextIndex =
    (indicatorCenter /
        (itemWidth + itemGap))
        .floor();

    nextIndex = nextIndex
        .clamp(
      0,
      filterItems.length - 1,
    )
        .toInt();

    setState(() {
      _dragIndicatorLeft = nextLeft;
    });

    ProfileContentFilterType nextFilter =
        filterItems[nextIndex].type;

    if (widget.selectedFilter !=
        nextFilter) {
      widget.onChanged(nextFilter);
    }
  }

  void _stopDragging() {
    if (!_isDragging) {
      return;
    }

    setState(() {
      _isDragging = false;
      _dragIndicatorLeft = null;
    });
  }

  void _cancelDragging() {
    if (!_isDragging) {
      return;
    }

    setState(() {
      _isDragging = false;
      _dragIndicatorLeft = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness ==
            Brightness.dark;

    Color backgroundColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.88,
    )
        : Colors.white.withValues(
      alpha: 0.90,
    );

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color activeColor =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.18 : 0.10,
    );

    Color activeBorderColor =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.28 : 0.18,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
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
            width: double.infinity,
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
              ),
            ),
            child: LayoutBuilder(
              builder: (
                  BuildContext context,
                  BoxConstraints constraints,
                  ) {
                double totalGap =
                    itemGap *
                        (filterItems.length -
                            1);

                double itemWidth =
                    (constraints.maxWidth -
                        totalGap) /
                        filterItems.length;

                double normalIndicatorLeft =
                    selectedIndex *
                        (itemWidth + itemGap);

                double indicatorLeft =
                _isDragging &&
                    _dragIndicatorLeft !=
                        null
                    ? _dragIndicatorLeft!
                    : normalIndicatorLeft;

                double maximumLeft =
                    constraints.maxWidth -
                        itemWidth;

                return GestureDetector(
                  behavior:
                  HitTestBehavior.opaque,
                  onLongPressStart: (
                      LongPressStartDetails
                      details,
                      ) {
                    _startDragging(
                      details: details,
                      itemWidth: itemWidth,
                    );
                  },
                  onLongPressMoveUpdate: (
                      LongPressMoveUpdateDetails
                      details,
                      ) {
                    _updateDragging(
                      details: details,
                      itemWidth: itemWidth,
                      maximumLeft:
                      maximumLeft,
                    );
                  },
                  onLongPressEnd: (
                      LongPressEndDetails details,
                      ) {
                    _stopDragging();
                  },
                  onLongPressCancel:
                  _cancelDragging,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: _isDragging
                            ? Duration.zero
                            : Duration(
                          milliseconds:
                          240,
                        ),
                        curve:
                        Curves.easeOutCubic,
                        left: indicatorLeft,
                        top: 0,
                        width: itemWidth,
                        height: itemHeight,
                        child: IgnorePointer(
                          child:
                          AnimatedContainer(
                            duration: Duration(
                              milliseconds:
                              160,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              activeColor,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                15,
                              ),
                              border:
                              Border.all(
                                color:
                                activeBorderColor,
                              ),
                              boxShadow:
                              _isDragging
                                  ? [
                                BoxShadow(
                                  color: colorScheme
                                      .primary
                                      .withValues(
                                    alpha:
                                    0.12,
                                  ),
                                  blurRadius:
                                  8,
                                  offset:
                                  Offset(
                                    0,
                                    2,
                                  ),
                                ),
                              ]
                                  : [],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: _buildButtons(
                          itemWidth: itemWidth,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons({
    required double itemWidth,
  }) {
    List<Widget> widgets =
    <Widget>[];

    for (
    int index = 0;
    index < filterItems.length;
    index++
    ) {
      ProfileContentFilterItem item =
      filterItems[index];

      widgets.add(
        SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: _ProfileFilterButton(
            title: item.title,
            icon: item.icon,
            selected:
            widget.selectedFilter ==
                item.type,
            onTap: () {
              if (_isDragging) {
                return;
              }

              if (widget.selectedFilter ==
                  item.type) {
                return;
              }

              widget.onChanged(
                item.type,
              );
            },
          ),
        ),
      );

      if (index <
          filterItems.length - 1) {
        widgets.add(
          SizedBox(
            width: itemGap,
          ),
        );
      }
    }

    return widgets;
  }
}

class ProfileContentFilterItem {
  final ProfileContentFilterType type;
  final String title;
  final IconData icon;

  ProfileContentFilterItem({
    required this.type,
    required this.title,
    required this.icon,
  });
}

class _ProfileFilterButton
    extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  _ProfileFilterButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness ==
            Brightness.dark;

    Color inactiveColor = isDark
        ? colorScheme.onSurfaceVariant
        .withValues(
      alpha: 0.82,
    )
        : colorScheme.onSurfaceVariant;

    Color contentColor = selected
        ? colorScheme.primary
        : inactiveColor;

    return Material(
      color: Colors.transparent,
      borderRadius:
      BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(15),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 3,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize:
            MainAxisSize.min,
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<Color?>(
                duration: Duration(
                  milliseconds: 180,
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
                    size: 14,
                  );
                },
              ),
              SizedBox(width: 4),
              Flexible(
                child:
                AnimatedDefaultTextStyle(
                  duration: Duration(
                    milliseconds: 180,
                  ),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 10,
                    height: 1,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
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