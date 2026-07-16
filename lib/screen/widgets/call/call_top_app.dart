import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String name;
  final String avatarUrl;
  final bool isVideoCall;
  final bool isConnecting;
  final VoidCallback onBack;

  CallTopBar({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isVideoCall,
    required this.isConnecting,
    required this.onBack,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(68);
  }

  String get firstLetter {
    String cleanName = name.trim();

    if (cleanName.isEmpty) {
      return '?';
    }

    return cleanName[0].toUpperCase();
  }

  String get statusText {
    if (isConnecting) {
      return isVideoCall
          ? 'Video calling...'
          : 'Calling...';
    }

    return isVideoCall
        ? 'Video call connected'
        : 'Voice call connected';
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
        child: _CallAppBarButton(
          tooltip: 'Back',
          icon: Icons.arrow_back_ios_new_rounded,
          iconSize: 18,
          backgroundColor: actionBackground,
          foregroundColor: colorScheme.onSurface,
          onPressed: onBack,
        ),
      ),
      title: Padding(
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
                  child: ClipOval(
                    child: avatarUrl.trim().isEmpty
                        ? _buildAvatarFallback(
                      context,
                    )
                        : Image.network(
                      avatarUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                          ) {
                        return _buildAvatarFallback(
                          context,
                        );
                      },
                    ),
                  ),
                ),
                if (!isConnecting)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
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
                    name,
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
                    child: Row(
                      key: ValueKey<String>(
                        statusText,
                      ),
                      children: [
                        if (isConnecting) ...[
                          SizedBox(
                            width: 11,
                            height: 11,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 1.6,
                              color:
                              colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            statusText,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: theme
                                .textTheme.bodySmall
                                ?.copyWith(
                              color:
                              colorScheme.primary,
                              fontSize: 11.5,
                              height: 1,
                              fontWeight:
                              FontWeight.w600,
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
      actions: [
        Padding(
          padding: EdgeInsets.only(
            top: 12,
            bottom: 12,
            right: 10,
          ),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.11,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color:
                colorScheme.primary.withValues(
                  alpha: 0.15,
                ),
              ),
            ),
            child: Icon(
              isVideoCall
                  ? Icons.videocam_outlined
                  : Icons.call_outlined,
              color: colorScheme.primary,
              size: 21,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarFallback(
      BuildContext context,
      ) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      color: colorScheme.primary.withValues(
        alpha: 0.12,
      ),
      child: Text(
        firstLetter,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CallAppBarButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final double iconSize;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  _CallAppBarButton({
    required this.tooltip,
    required this.icon,
    required this.iconSize,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
              color: foregroundColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}