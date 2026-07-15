import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileQrCodeScreen extends StatelessWidget {
  final String name;
  final String username;

  ProfileQrCodeScreen({
    super.key,
    required this.name,
    required this.username,
  });

  String get cleanName {
    String value = name.trim();

    if (value.isEmpty) {
      return 'AppChat User';
    }

    return value;
  }

  String get cleanUsername {
    return username.trim().replaceFirst('@', '');
  }

  String get displayUsername {
    if (cleanUsername.isEmpty) {
      return 'No username';
    }

    return '@$cleanUsername';
  }

  String get profileQrData {
    String profileKey = cleanUsername.isNotEmpty
        ? cleanUsername
        : cleanName;

    return 'appchat://profile/${Uri.encodeComponent(profileKey)}';
  }

  String get firstLetter {
    return cleanName[0].toUpperCase();
  }

  void _copyUsername(BuildContext context) {
    String value = cleanUsername.isNotEmpty
        ? '@$cleanUsername'
        : profileQrData;

    Clipboard.setData(
      ClipboardData(text: value),
    );

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            cleanUsername.isNotEmpty
                ? 'Username copied'
                : 'Profile link copied',
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
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

    Color headerColor = isDark
        ? Color(0xFF1B1D22).withValues(alpha: 0.96)
        : Colors.white.withValues(alpha: 0.98);

    Color solidHeaderColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFE5E7EB);

    Color actionBackground = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFF2F4F7);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 64,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leadingWidth: 60,
        systemOverlayStyle: _overlayStyle(
          theme,
          isDark,
        ),
        iconTheme: IconThemeData(
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
                color: headerColor,
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
          padding: EdgeInsets.fromLTRB(
            10,
            10,
            6,
            10,
          ),
          child: Material(
            color: actionBackground,
            shape: CircleBorder(),
            child: InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus
                    ?.unfocus();

                Navigator.of(context).maybePop();
              },
              customBorder: CircleBorder(),
              child: SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: colorScheme.onSurface,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'My QR Code',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(
            18,
            24,
            18,
            30,
          ),
          children: [
            Text(
              'Share your profile',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(height: 7),

            Text(
              'Let someone scan this QR code to find your AppChat profile.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                20,
                24,
                20,
                22,
              ),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: borderColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.18 : 0.05,
                    ),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(
                        alpha: 0.13,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(
                          alpha: 0.22,
                        ),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      firstLetter,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    cleanName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    displayUsername,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 22),

                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.black.withValues(
                          alpha: 0.07,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.04,
                          ),
                          blurRadius: 14,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: profileQrData,
                      version: QrVersions.auto,
                      size: 230,
                      padding: EdgeInsets.all(8),
                      backgroundColor: Colors.white,
                      eyeStyle: QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape:
                        QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                      errorStateBuilder: (
                          BuildContext context,
                          Object? error,
                          ) {
                        return SizedBox(
                          width: 230,
                          height: 230,
                          child: Center(
                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons
                                      .error_outline_rounded,
                                  color:
                                  colorScheme.error,
                                  size: 40,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Unable to create QR code',
                                  textAlign:
                                  TextAlign.center,
                                  style: TextStyle(
                                    color:
                                    colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 18),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner_rounded,
                        color:
                        colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          'Scan with another phone',
                          textAlign: TextAlign.center,
                          style: theme
                              .textTheme.bodyMedium
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            FilledButton.icon(
              onPressed: () {
                _copyUsername(context);
              },
              icon: Icon(
                Icons.copy_rounded,
              ),
              label: Text(
                cleanUsername.isNotEmpty
                    ? 'Copy Username'
                    : 'Copy Profile Link',
              ),
              style: FilledButton.styleFrom(
                minimumSize: Size(
                  double.infinity,
                  52,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),
              ),
            ),

            SizedBox(height: 12),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(
                  alpha: isDark ? 0.10 : 0.07,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.primary.withValues(
                    alpha: 0.13,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: colorScheme.primary,
                    size: 21,
                  ),

                  SizedBox(width: 11),

                  Expanded(
                    child: Text(
                      'Only share this QR code with people you trust.',
                      style: theme
                          .textTheme.bodyMedium
                          ?.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}