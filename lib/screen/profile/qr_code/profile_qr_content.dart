import 'package:appchat/screen/profile/qr_code/profile_qr_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_qr_card.dart';
import 'profile_qr_info_card.dart';

class ProfileQrContent extends StatelessWidget {
  final String name;
  final String username;
  final String qrData;
  final String firstLetter;
  final bool hasUsername;
  final VoidCallback onCopy;
  final Future<void> Function() onDownload;
  final ScrollController? scrollController;

  const ProfileQrContent({
    super.key,
    required this.name,
    required this.username,
    required this.qrData,
    required this.firstLetter,
    required this.hasUsername,
    required this.onCopy,
    required this.onDownload,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark = theme.brightness == Brightness.dark;

    Color pageColor = isDark ? Color(0xFF131519) : Color(0xFFF6F7F9);

    return ColoredBox(
      color: pageColor,
      child: ListView(
        controller: scrollController,
        primary: scrollController == null,
        shrinkWrap: scrollController == null,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(
          16,
          18,
          16,
          32,
        ),
        children: [
          ProfileQrCard(
            name: name,
            username: username,
            qrData: qrData,
            firstLetter: firstLetter,
          ),
          SizedBox(height: 24),
          _QrSectionTitle(
            title: 'quick_actions'.tr,
            icon: CupertinoIcons.bolt_fill,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CopyProfileButton(
                  hasUsername: hasUsername,
                  onPressed: onCopy,
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: SaveQrButton(
                  onDownload: onDownload,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _QrSectionTitle(
            title: 'security'.tr,
            icon: CupertinoIcons.shield_fill,
          ),
          SizedBox(height: 10),
          ProfileQrInfoCard(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _QrSectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;

  const _QrSectionTitle({
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 3,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: colorScheme.primary,
              size: 18,
            ),
            SizedBox(width: 8),
          ],
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}