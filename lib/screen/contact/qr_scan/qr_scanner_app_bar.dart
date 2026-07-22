import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/qr_code/qr_scanner_buttons.dart';
class QrScannerAppBar
    extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  QrScannerAppBar({
    super.key,
    required this.onBack,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(68);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    return AppBar(
      toolbarHeight: 68,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor:
      Colors.transparent,
      foregroundColor:
      Colors.white,
      surfaceTintColor:
      Colors.transparent,
      shadowColor:
      Colors.transparent,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leadingWidth: 60,
      systemOverlayStyle:
      SystemUiOverlayStyle.light,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Container(
            decoration: BoxDecoration(
              color:
              Colors.black.withValues(
                alpha: 0.38,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white
                      .withValues(
                    alpha: 0.10,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.only(
          left: 10,
          top: 12,
          bottom: 12,
        ),
        child: QrScannerCircleButton(
          tooltip: 'Back',
          icon: Icons
              .arrow_back_ios_new_rounded,
          onTap: onBack,
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Scan QR code',
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme.titleMedium
                ?.copyWith(
              color: Colors.white,
              fontSize: 17,
              fontWeight:
              FontWeight.w700,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Scan a contact QR code',
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme.bodySmall
                ?.copyWith(
              color: Colors.white
                  .withValues(
                alpha: 0.72,
              ),
              fontSize: 11,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            top: 12,
            bottom: 12,
            right: 10,
          ),
          child: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withValues(
                alpha: 0.18,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary
                    .withValues(
                  alpha: 0.35,
                ),
              ),
            ),
            child: Icon(
              Icons.qr_code_scanner_rounded,
              color:
              colorScheme.primary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}