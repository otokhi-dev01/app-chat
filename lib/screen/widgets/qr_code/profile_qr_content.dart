import 'package:appchat/screen/widgets/qr_code/profile_qr_action_button.dart';
import 'package:flutter/material.dart';

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

  ProfileQrContent({
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

    bool isDark =
        theme.brightness == Brightness.dark;

    Color pageColor = isDark
        ? Color(0xFF131519)
        : Color(0xFFF6F7F9);

    return ColoredBox(
      color: pageColor,
      child: ListView(
        controller: scrollController,
        primary: scrollController == null,
        shrinkWrap: scrollController == null,
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
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
            title: 'Quick Actions',
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
            title: 'Security',
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

  _QrSectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 3,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}