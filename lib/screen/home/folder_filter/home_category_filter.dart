import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/chat/chat_controller.dart';
import '../../../controllers/settings/chat_folder_controller.dart';
import '../../../models/chat_folder_model.dart';

class HomeCategoryFilter extends StatefulWidget {
  final ChatController controller;

  const HomeCategoryFilter({
    super.key,
    required this.controller,
  });

  @override
  State<HomeCategoryFilter> createState() => _HomeCategoryFilterState();
}

class _HomeCategoryFilterState extends State<HomeCategoryFilter> {
  final GlobalKey _stackKey = GlobalKey();
  final Map<String, GlobalKey> _itemKeys = {};
  final ScrollController _scrollController = ScrollController();

  Rect? _indicatorRect;

  ChatFolderController get folderController => Get.find<ChatFolderController>();

  @override
  void initState() {
    super.initState();
    _measure();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _measure() {
    if (!mounted) return;

    // Safely wait for frame layout to finish before accessing RenderBox.size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      String activeFolderId = widget.controller.selectedFolderId.value;
      GlobalKey? activeKey = _itemKeys[activeFolderId];

      BuildContext? stackContext = _stackKey.currentContext;
      BuildContext? activeContext = activeKey?.currentContext;

      if (stackContext == null || activeContext == null) return;

      final RenderBox? stackBox = stackContext.findRenderObject() as RenderBox?;
      final RenderBox? activeBox = activeContext.findRenderObject() as RenderBox?;

      if (stackBox == null || activeBox == null) return;
      if (!stackBox.hasSize || !activeBox.hasSize) return;

      final Offset offset = activeBox.localToGlobal(Offset.zero, ancestor: stackBox);
      final Rect rect = offset & activeBox.size;

      if (rect != _indicatorRect) {
        setState(() {
          _indicatorRect = rect;
        });
      }
    });
  }

  void _scrollToActive(BuildContext itemContext) {
    Scrollable.ensureVisible(
      itemContext,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      alignment: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final ColorScheme colorScheme = theme.colorScheme;

    final Color backgroundColor =
    isDark ? const Color(0xFF1B1D22) : Colors.white;
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final Color activeBackground = colorScheme.primary.withValues(alpha: 0.11);

    return Obx(
          () {
        List<ChatFolderModel> folders = folderController.folders.toList();
        String activeFolderId = widget.controller.selectedFolderId.value;

        _measure();

        if (folderController.isLoading.value && folders.isEmpty) {
          return _FolderFilterLoading(
            backgroundColor: backgroundColor,
            borderColor: borderColor,
          );
        }

        if (folders.isEmpty) {
          return const SizedBox.shrink();
        }

        for (var folder in folders) {
          _itemKeys.putIfAbsent(folder.id, () => GlobalKey());
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
            ),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                _measure();
                return false;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                child: Stack(
                  key: _stackKey,
                  children: [
                    _buildIndicator(activeBackground),
                    Row(
                      children: List.generate(folders.length, (index) {
                        ChatFolderModel folder = folders[index];
                        bool isActive = activeFolderId == folder.id;
                        int count = widget.controller.getFolderCount(folder);
                        GlobalKey itemKey = _itemKeys[folder.id]!;

                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == folders.length - 1 ? 0 : 4,
                          ),
                          child: _CategoryItem(
                            key: itemKey,
                            label: folder.name,
                            count: count,
                            isActive: isActive,
                            isDark: isDark,
                            isCustom: !folder.isSystem,
                            primaryColor: colorScheme.primary,
                            onTap: () {
                              if (isActive) return;
                              widget.controller.selectFolder(folder);

                              BuildContext? ctx = itemKey.currentContext;
                              if (ctx != null) {
                                _scrollToActive(ctx);
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator(Color activeBackground) {
    if (_indicatorRect == null) return const SizedBox.shrink();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      left: _indicatorRect!.left,
      top: _indicatorRect!.top,
      width: _indicatorRect!.width,
      height: _indicatorRect!.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: activeBackground,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final bool isDark;
  final bool isCustom;
  final Color primaryColor;
  final VoidCallback onTap;

  const _CategoryItem({
    super.key,
    required this.label,
    required this.count,
    required this.isActive,
    required this.isDark,
    required this.isCustom,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color inactiveTextColor = isDark
        ? Colors.white.withValues(alpha: 0.60)
        : Colors.black.withValues(alpha: 0.60);

    final Color textColor = isActive ? primaryColor : inactiveTextColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: primaryColor.withValues(alpha: 0.12),
        highlightColor: primaryColor.withValues(alpha: 0.06),
        child: Container(
          constraints: const BoxConstraints(minWidth: 76),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCustom) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.folder_outlined,
                    size: 14,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    height: 1,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  constraints: const BoxConstraints(minWidth: 18),
                  height: 18,
                  padding: EdgeInsets.symmetric(
                    horizontal: count > 99 ? 5 : 4,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: isActive
                        ? primaryColor.withValues(alpha: 0.18)
                        : isDark
                        ? Colors.white.withValues(alpha: 0.10)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: TextStyle(
                      color: textColor,
                      fontSize: count > 99 ? 8 : 9,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FolderFilterLoading extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;

  const _FolderFilterLoading({
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}