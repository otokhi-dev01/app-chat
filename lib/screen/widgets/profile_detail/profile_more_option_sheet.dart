import 'package:flutter/material.dart';

Future<void> showProfileMoreOptionsSheet({
  required BuildContext context,
  required String userName,
  VoidCallback? onShareProfile,
  VoidCallback? onNotifications,
  VoidCallback? onBlockUser,
  VoidCallback? onReportUser,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme = theme.colorScheme;

  bool isDark =
      theme.brightness == Brightness.dark;

  Color sheetColor = isDark
      ? Color(0xFF1B1D22)
      : Colors.white;

  Color borderColor = isDark
      ? Colors.white.withValues(
    alpha: 0.08,
  )
      : Colors.black.withValues(
    alpha: 0.06,
  );

  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(
      alpha: 0.38,
    ),
    builder: (
        BuildContext sheetContext,
        ) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          16,
          10,
          16,
          20,
        ),
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26),
          ),
          border: Border(
            top: BorderSide(
              color: borderColor,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ProfileMoreSheetHandle(),
            SizedBox(height: 16),
            _ProfileMoreSheetHeader(
              userName: userName,
              onClose: () {
                Navigator.of(
                  sheetContext,
                ).pop();
              },
            ),
            SizedBox(height: 16),
            ProfileMoreOptionTile(
              icon: Icons.share_outlined,
              title: 'Share Profile',
              subtitle:
              'Share this profile with others',
              onTap: () {
                _closeAndRun(
                  context: sheetContext,
                  action: onShareProfile,
                );
              },
            ),
            SizedBox(height: 6),
            ProfileMoreOptionTile(
              icon:
              Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle:
              'Manage notifications from this user',
              onTap: () {
                _closeAndRun(
                  context: sheetContext,
                  action: onNotifications,
                );
              },
            ),
            SizedBox(height: 6),
            ProfileMoreOptionTile(
              icon: Icons.block_rounded,
              title: 'Block User',
              subtitle:
              'Stop receiving messages and calls',
              isDanger: true,
              onTap: () {
                _closeAndRun(
                  context: sheetContext,
                  action: onBlockUser,
                );
              },
            ),
            SizedBox(height: 6),
            ProfileMoreOptionTile(
              icon: Icons.flag_outlined,
              title: 'Report User',
              subtitle:
              'Report this account',
              isDanger: true,
              onTap: () {
                _closeAndRun(
                  context: sheetContext,
                  action: onReportUser,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

void _closeAndRun({
  required BuildContext context,
  VoidCallback? action,
}) {
  Navigator.of(context).pop();

  if (action == null) {
    return;
  }

  Future<void>.delayed(
    Duration(
      milliseconds: 100,
    ),
        () {
      action();
    },
  );
}

class _ProfileMoreSheetHandle
    extends StatelessWidget {
  _ProfileMoreSheetHandle();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant
            .withValues(
          alpha: 0.25,
        ),
        borderRadius:
        BorderRadius.circular(20),
      ),
    );
  }
}

class _ProfileMoreSheetHeader
    extends StatelessWidget {
  final String userName;
  final VoidCallback onClose;

  _ProfileMoreSheetHeader({
    required this.userName,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary
                .withValues(
              alpha: 0.11,
            ),
            borderRadius:
            BorderRadius.circular(13),
          ),
          child: Icon(
            Icons.more_horiz_rounded,
            color: colorScheme.primary,
            size: 23,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'More options',
                style: theme
                    .textTheme.titleMedium
                    ?.copyWith(
                  color:
                  colorScheme.onSurface,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                userName,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: theme
                    .textTheme.bodySmall
                    ?.copyWith(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: colorScheme
              .surfaceContainerHighest,
          shape: CircleBorder(),
          child: InkWell(
            onTap: onClose,
            customBorder: CircleBorder(),
            splashColor: Colors.transparent,
            highlightColor:
            Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.close_rounded,
                color: colorScheme
                    .onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileMoreOptionTile
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDanger;
  final VoidCallback onTap;

  ProfileMoreOptionTile({
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
    ColorScheme colorScheme =
        theme.colorScheme;

    Color foregroundColor = isDanger
        ? colorScheme.error
        : colorScheme.onSurface;

    Color iconColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

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
      borderRadius:
      BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(16),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor:
        WidgetStateProperty.resolveWith(
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
            minHeight: 62,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 9,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 21,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme
                          .textTheme.bodyLarge
                          ?.copyWith(
                        color:
                        foregroundColor,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: isDanger
                    ? colorScheme.error
                    .withValues(
                  alpha: 0.70,
                )
                    : colorScheme
                    .onSurfaceVariant,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}