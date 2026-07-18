import 'package:flutter/material.dart';

import 'profile_qr_card.dart';
import 'profile_qr_info_card.dart';

class ProfileQrContent
    extends StatelessWidget {
  final String name;
  final String username;
  final String qrData;
  final String firstLetter;
  final bool hasUsername;
  final VoidCallback onCopy;
  final Future<void> Function() onDownload;

  ProfileQrContent({
    super.key,
    required this.name,
    required this.username,
    required this.qrData,
    required this.firstLetter,
    required this.hasUsername,
    required this.onCopy,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return SafeArea(
      top: false,
      child: ListView(
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior
            .onDrag,
        physics: BouncingScrollPhysics(
          parent:
          AlwaysScrollableScrollPhysics(),
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
            style: theme
                .textTheme.headlineSmall
                ?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Let someone scan this QR code to find your AppChat profile.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(
              color:
              colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          SizedBox(height: 24),
          ProfileQrCard(
            name: name,
            username: username,
            qrData: qrData,
            firstLetter: firstLetter,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _CopyProfileButton(
                  hasUsername: hasUsername,
                  onPressed: onCopy,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SaveQrButton(
                  onDownload: onDownload,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ProfileQrInfoCard(),
        ],
      ),
    );
  }
}

class _CopyProfileButton
    extends StatelessWidget {
  final bool hasUsername;
  final VoidCallback onPressed;

  _CopyProfileButton({
    required this.hasUsername,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size(
          double.infinity,
          52,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        backgroundColor:
        colorScheme.primary,
        foregroundColor:
        colorScheme.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            Icons.copy_rounded,
            size: 19,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              hasUsername
                  ? 'Copy Username'
                  : 'Copy Link',
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveQrButton extends StatefulWidget {
  final Future<void> Function() onDownload;

  _SaveQrButton({
    required this.onDownload,
  });

  @override
  State<_SaveQrButton> createState() {
    return _SaveQrButtonState();
  }
}

class _SaveQrButtonState
    extends State<_SaveQrButton> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onDownload();
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color buttonColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : colorScheme.primary.withValues(
      alpha: 0.08,
    );

    Color borderColor =
    colorScheme.primary.withValues(
      alpha: isDark ? 0.22 : 0.18,
    );

    return Material(
      color: buttonColor,
      borderRadius:
      BorderRadius.circular(16),
      child: InkWell(
        onTap:
        _isSaving ? null : _handleSave,
        borderRadius:
        BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 52,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              if (_isSaving)
                SizedBox(
                  width: 18,
                  height: 18,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                    colorScheme.primary,
                  ),
                )
              else
                Icon(
                  Icons.download_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  _isSaving
                      ? 'Saving...'
                      : 'Save QR',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                    colorScheme.primary,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}