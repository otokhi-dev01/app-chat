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
  final ValueChanged<String>? onMenuSelected;
  final VoidCallback? onProfileTap;

  ChatDetailAppBar({
    super.key,
    required this.chat,
    this.onAudioCall,
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
                        style: theme.textTheme.titleMedium
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
                          key: ValueKey(statusText),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall
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
            tooltip: 'Audio call',
            icon: Icons.call_outlined,
            iconSize: 21,
            backgroundColor: actionBackground,
            foregroundColor: colorScheme.primary,
            onPressed: onAudioCall,
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