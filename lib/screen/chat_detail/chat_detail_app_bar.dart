import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';
import '../widgets/chat_detail/chat_details_popup_menu.dart';
import 'chat_detail_app_bar_button.dart';

class ChatDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ChatModel chat;
  final VoidCallback? onAudioCall;
  final VoidCallback? onVideoCall;
  final ValueChanged<String>? onMenuSelected;
  final VoidCallback? onProfileTap;

  ChatDetailAppBar({
    super.key,
    required this.chat,
    this.onAudioCall,
    this.onVideoCall,
    this.onMenuSelected,
    this.onProfileTap,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(68);
  }

  String get firstLetter {
    String name = chat.name.trim();

    if (name.isEmpty) {
      return '?';
    }

    return name[0].toUpperCase();
  }

  String get statusText {
    if (chat.isTyping) {
      return 'Typing...';
    }

    if (chat.isOnline) {
      return 'Online';
    }

    if (chat.type == 'group') {
      return 'Group conversation';
    }

    return 'Offline';
  }

  SystemUiOverlayStyle _overlayStyle(
      ThemeData theme,
      bool isDark,
      ) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor:
        theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
        Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
      Brightness.dark,
    );
  }

  Future<void> _showCallOptions(
      BuildContext context,
      ) async {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
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
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: 0.42,
      ),
      builder: (
          BuildContext sheetContext,
          ) {
        return Material(
          color: cardColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            side: BorderSide(
              color: borderColor,
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              18,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme
                        .onSurfaceVariant
                        .withValues(
                      alpha: 0.25,
                    ),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    4,
                    18,
                    4,
                    16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.primary
                              .withValues(
                            alpha: 0.11,
                          ),
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.call_rounded,
                          color: colorScheme.primary,
                          size: 24,
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start a call',
                              style: theme
                                  .textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              'Choose how you want to call',
                              style: theme
                                  .textTheme.bodySmall
                                  ?.copyWith(
                                color: colorScheme
                                    .onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  color: borderColor,
                ),

                SizedBox(height: 8),

                _CallOptionTile(
                  icon: Icons.call_outlined,
                  title: 'Audio call',
                  subtitle:
                  'Start a voice conversation',
                  onTap: () {
                    Navigator.of(sheetContext).pop();

                    onAudioCall?.call();
                  },
                ),

                _CallOptionTile(
                  icon: Icons.videocam_outlined,
                  title: 'Video call',
                  subtitle:
                  'Start a video conversation',
                  onTap: () {
                    Navigator.of(sheetContext).pop();

                    onVideoCall?.call();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.94,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color solidSurfaceColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFE7E9ED);

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    Color avatarBackground =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.15 : 0.10,
    );

    Color avatarBorder =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.24 : 0.17,
    );

    Color statusColor =
    chat.isTyping || chat.isOnline
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return AppBar(
      toolbarHeight: 68,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leadingWidth: 56,
      systemOverlayStyle: _overlayStyle(
        theme,
        isDark,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
      actionsIconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: appBarColor,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.only(
          left: 8,
          top: 12,
          bottom: 12,
        ),
        child: ChatDetailAppBarButton(
          tooltip: 'Back',
          icon: Icons.arrow_back_ios_new_rounded,
          iconSize: 18,
          backgroundColor: actionBackground,
          foregroundColor: colorScheme.onSurface,
          onPressed: () {
            FocusManager.instance.primaryFocus
                ?.unfocus();

            Get.back();
          },
        ),
      ),
      title: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onProfileTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 7,
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: avatarBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: avatarBorder,
                        ),
                      ),
                      child: Text(
                        firstLetter,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    if (chat.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: Color(0xFF32C766),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: solidSurfaceColor,
                              width: 2.2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 11),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme
                            .textTheme.titleMedium
                            ?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.1,
                        ),
                      ),

                      SizedBox(height: 4),

                      AnimatedSwitcher(
                        duration: Duration(
                          milliseconds: 180,
                        ),
                        child: Text(
                          statusText,
                          key: ValueKey<String>(
                            statusText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme
                              .textTheme.bodySmall
                              ?.copyWith(
                            color: statusColor,
                            fontSize: 11.5,
                            height: 1,
                            fontWeight:
                            chat.isTyping ||
                                chat.isOnline
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: ChatDetailAppBarButton(
            tooltip: 'Call',
            icon: Icons.call_outlined,
            iconSize: 21,
            backgroundColor: actionBackground,
            foregroundColor: colorScheme.primary,
            onPressed: () {
              _showCallOptions(context);
            },
          ),
        ),

        SizedBox(width: 4),

        ChatDetailPopupMenu(
          chat: chat,
          buttonBackground: actionBackground,
          onSelected: (String value) {
            onMenuSelected?.call(value);
          },
        ),
      ],
    );
  }
}

class _CallOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _CallOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
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
                  icon,
                  color: colorScheme.primary,
                  size: 22,
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
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme
                    .onSurfaceVariant
                    .withValues(
                  alpha: 0.65,
                ),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}