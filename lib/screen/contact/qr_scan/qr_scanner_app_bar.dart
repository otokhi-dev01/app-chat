import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class QrScannerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const QrScannerAppBar({
    super.key,
    required this.onBack,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(60);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    return AppBar(
      toolbarHeight: 60,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leadingWidth: 58,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: 0.40,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(
                    alpha: 0.10,
                  ),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.fromLTRB(12, 10, 6, 10),
        child: Tooltip(
          message: 'back'.tr,
          child: Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.20),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.25 : 0.10,
                  ),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size(40, 40),
              onPressed: onBack,
              child: Icon(
                CupertinoIcons.chevron_left,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'scan_qr_code'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'scan_contact_qr_code'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(
                alpha: 0.72,
              ),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(6, 10, 12, 10),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.20,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.primary.withValues(
                  alpha: 0.40,
                ),
                width: 1.0,
              ),
            ),
            child: Icon(
              CupertinoIcons.qrcode_viewfinder,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}