import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';

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

  String get _firstLetter {
    String name = chat.name.trim();

    if (name.isEmpty) {
      return '?';
    }

    return name.substring(0, 1).toUpperCase();
  }

  String get _statusText {
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.92,
    )
        : Colors.white.withValues(
      alpha: 0.95,
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

    Color primaryBackground =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.15 : 0.10,
    );

    Color primaryBorder =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.24 : 0.17,
    );

    Color statusColor =
    chat.isTyping || chat.isOnline
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    SystemUiOverlayStyle overlayStyle = isDark
        ? SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      statusBarIconBrightness:
      Brightness.light,
      statusBarBrightness:
      Brightness.dark,
    )
        : SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      statusBarIconBrightness:
      Brightness.dark,
      statusBarBrightness:
      Brightness.light,
    );

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
      systemOverlayStyle: overlayStyle,

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
        child: _AppBarActionButton(
          tooltip: 'Back',
          icon:
          Icons.arrow_back_ios_new_rounded,
          iconSize: 18,
          backgroundColor:
          actionBackground,
          foregroundColor:
          colorScheme.onSurface,
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
          borderRadius:
          BorderRadius.circular(16),
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
                      alignment:
                      Alignment.center,
                      decoration: BoxDecoration(
                        color:
                        primaryBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryBorder,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _firstLetter,
                        style: TextStyle(
                          color:
                          colorScheme.primary,
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w700,
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
                          decoration:
                          BoxDecoration(
                            color:
                            Color(0xFF32C766),
                            shape:
                            BoxShape.circle,
                            border:
                            Border.all(
                              color:
                              solidSurfaceColor,
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
                    mainAxisSize:
                    MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme
                            .textTheme.titleMedium
                            ?.copyWith(
                          color:
                          colorScheme.onSurface,
                          fontWeight:
                          FontWeight.w700,
                          fontSize: 16,
                          height: 1.1,
                        ),
                      ),

                      SizedBox(height: 4),

                      AnimatedSwitcher(
                        duration: Duration(
                          milliseconds: 180,
                        ),
                        switchInCurve:
                        Curves.easeOutCubic,
                        switchOutCurve:
                        Curves.easeInCubic,
                        child: Row(
                          key: ValueKey(
                            _statusText,
                          ),
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            if (chat.isTyping)
                              Container(
                                width: 5,
                                height: 5,
                                margin:
                                EdgeInsets.only(
                                  right: 5,
                                ),
                                decoration:
                                BoxDecoration(
                                  color: colorScheme
                                      .primary,
                                  shape:
                                  BoxShape.circle,
                                ),
                              ),

                            Flexible(
                              child: Text(
                                _statusText,
                                maxLines: 1,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                style: theme
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color:
                                  statusColor,
                                  fontSize: 11.5,
                                  height: 1,
                                  fontWeight:
                                  chat.isTyping ||
                                      chat
                                          .isOnline
                                      ? FontWeight
                                      .w600
                                      : FontWeight
                                      .w500,
                                ),
                              ),
                            ),
                          ],
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
          child: _AppBarActionButton(
            tooltip: 'Audio call',
            icon: Icons.call_outlined,
            iconSize: 21,
            backgroundColor:
            actionBackground,
            foregroundColor:
            colorScheme.primary,
            onPressed: onAudioCall,
          ),
        ),

        SizedBox(width: 4),

        PopupMenuButton<String>(
          tooltip: 'More',
          onSelected: onMenuSelected,
          padding: EdgeInsets.zero,
          color: solidSurfaceColor,
          surfaceTintColor:
          Colors.transparent,
          elevation: 10,
          shadowColor: Colors.black.withValues(
            alpha: isDark ? 0.30 : 0.12,
          ),
          position:
          PopupMenuPosition.under,
          offset: Offset(-8, 4),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
            side: BorderSide(
              color: borderColor,
            ),
          ),
          icon: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: actionBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.more_vert_rounded,
              color: colorScheme.onSurface,
              size: 22,
            ),
          ),
          itemBuilder:
              (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'view_profile',
                child: _PopupMenuRow(
                  icon: Icons
                      .person_outline_rounded,
                  title: 'View profile',
                  iconColor:
                  colorScheme.primary,
                ),
              ),

              PopupMenuItem<String>(
                value: 'search',
                child: _PopupMenuRow(
                  icon: Icons.search_rounded,
                  title: 'Search messages',
                  iconColor:
                  colorScheme.primary,
                ),
              ),

              PopupMenuItem<String>(
                value: 'mute',
                child: _PopupMenuRow(
                  icon: chat.isMuted
                      ? Icons
                      .notifications_outlined
                      : Icons
                      .notifications_off_outlined,
                  title: chat.isMuted
                      ? 'Unmute notifications'
                      : 'Mute notifications',
                  iconColor:
                  colorScheme.primary,
                ),
              ),

              PopupMenuDivider(
                height: 10,
              ),

              PopupMenuItem<String>(
                value: 'clear',
                child: _PopupMenuRow(
                  icon: Icons
                      .delete_sweep_outlined,
                  title:
                  'Clear conversation',
                  iconColor:
                  colorScheme.error,
                  textColor:
                  colorScheme.error,
                ),
              ),
            ];
          },
        ),

        SizedBox(width: 8),
      ],
    );
  }
}

class _AppBarActionButton
    extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final double iconSize;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  _AppBarActionButton({
    required this.tooltip,
    required this.icon,
    required this.iconSize,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = onPressed == null
        ? foregroundColor.withValues(
      alpha: 0.40,
    )
        : foregroundColor;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        shape: CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: CircleBorder(),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

class _PopupMenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color? textColor;

  _PopupMenuRow({
    required this.icon,
    required this.title,
    required this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: iconColor.withValues(
              alpha: 0.11,
            ),
            borderRadius:
            BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style:
            theme.textTheme.bodyMedium
                ?.copyWith(
              color: textColor ??
                  colorScheme.onSurface,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}