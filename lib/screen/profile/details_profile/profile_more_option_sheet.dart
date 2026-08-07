import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showProfileMoreOptionsSheet({
  required BuildContext context,
  required String userName,
  VoidCallback? onShareProfile,
  VoidCallback? onNotifications,
  VoidCallback? onBlockUser,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  return showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) {
      return CupertinoActionSheet(
        title: Text(
          'more_options'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        message: Text(
          userName,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              if (onShareProfile != null) {
                Future<void>.delayed(
                  Duration(milliseconds: 100),
                  onShareProfile,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.share,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('share_profile'.tr),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              if (onNotifications != null) {
                Future<void>.delayed(
                  Duration(milliseconds: 100),
                  onNotifications,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.bell,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('notifications'.tr),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(sheetContext);
              if (onBlockUser != null) {
                Future<void>.delayed(
                  Duration(milliseconds: 100),
                  onBlockUser,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.slash_circle,
                  size: 20,
                  color: CupertinoColors.destructiveRed,
                ),
                SizedBox(width: 8),
                Text('block_user'.tr),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(sheetContext);
          },
          child: Text('cancel'.tr),
        ),
      );
    },
  );
}

class ProfileMoreOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDanger;
  final VoidCallback onTap;

  const ProfileMoreOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color foregroundColor =
    isDanger ? colorScheme.error : colorScheme.onSurface;

    Color iconColor = isDanger ? colorScheme.error : colorScheme.primary;

    Color iconBackground = isDanger
        ? colorScheme.error.withValues(
      alpha: 0.09,
    )
        : colorScheme.primary.withValues(
      alpha: 0.10,
    );

    Color pressedColor = isDanger
        ? colorScheme.error.withValues(
      alpha: 0.05,
    )
        : colorScheme.primary.withValues(
      alpha: 0.04,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith(
              (
              Set<WidgetState> states,
              ) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return pressedColor;
            }

            return Colors.transparent;
          },
        ),
        child: Container(
          constraints: BoxConstraints(
            minHeight: 52,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 9,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(
                    13,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: foregroundColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(
                CupertinoIcons.chevron_right,
                color: isDanger
                    ? colorScheme.error.withValues(
                  alpha: 0.70,
                )
                    : colorScheme.onSurfaceVariant,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}