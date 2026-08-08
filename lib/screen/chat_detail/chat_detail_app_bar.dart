import 'dart:ui';

import 'package:appchat/screen/chat_detail/widgets/chat_details_popup_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';
import 'chat_call_option_sheet.dart';

class ChatDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ChatModel chat;
  final VoidCallback? onAudioCall;
  final VoidCallback? onVideoCall;
  final ValueChanged<String>? onMenuSelected;
  final VoidCallback? onProfileTap;

  const ChatDetailAppBar({
    super.key,
    required this.chat,
    this.onAudioCall,
    this.onVideoCall,
    this.onMenuSelected,
    this.onProfileTap,
  });

  @override
  Size get preferredSize {
    return const Size.fromHeight(60);
  }

  String get firstLetter {
    String name = chat.name.trim();
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  String get statusText {
    if (chat.isTyping) return 'Typing...';
    if (chat.isOnline) return 'Online';
    if (chat.type == 'group') return 'Group conversation';
    return 'Offline';
  }

  SystemUiOverlayStyle _overlayStyle(ThemeData theme, bool isDark) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    Color actionBackground = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color solidSurfaceColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color avatarBackground = colorScheme.primary.withValues(
      alpha: isDark ? 0.15 : 0.10,
    );

    Color avatarBorder = colorScheme.primary.withValues(
      alpha: isDark ? 0.24 : 0.17,
    );

    Color statusColor = chat.isTyping || chat.isOnline
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return AppBar(
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      titleSpacing: 0,
      leadingWidth: 58,
      systemOverlayStyle: _overlayStyle(theme, isDark),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
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
        padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
        child: Tooltip(
          message: 'Back',
          child: Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: actionBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
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
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 40),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              },
              child: Icon(
                CupertinoIcons.chevron_left,
                size: 20,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
      title: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onProfileTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 4,
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
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
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF32C766),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: solidSurfaceColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          statusText,
                          key: ValueKey<String>(statusText),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: statusColor,
                            fontSize: 11.5,
                            height: 1,
                            fontWeight: chat.isTyping || chat.isOnline
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
          padding: const EdgeInsets.fromLTRB(0, 10, 6, 10),
          child: Tooltip(
            message: 'Call',
            child: Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: actionBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: borderColor,
                  width: 1.0,
                ),
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
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 40),
                onPressed: () {
                  ChatCallOptionsSheet.show(
                    context: context,
                    onAudioCall: onAudioCall,
                    onVideoCall: onVideoCall,
                  );
                },
                child: Icon(
                  CupertinoIcons.phone,
                  size: 19,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        ChatDetailPopupMenu(
          chat: chat,
          buttonBackground: actionBackground,
          onSelected: (String value) {
            onMenuSelected?.call(value);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}