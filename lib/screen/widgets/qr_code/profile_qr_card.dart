import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileQrCard
    extends StatelessWidget {
  final String name;
  final String username;
  final String qrData;
  final String firstLetter;

  ProfileQrCard({
    super.key,
    required this.name,
    required this.username,
    required this.qrData,
    required this.firstLetter,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        24,
        20,
        22,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
        BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha:
              isDark ? 0.18 : 0.05,
            ),
            blurRadius: 24,
            offset: Offset(
              0,
              10,
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileQrAvatar(
            firstLetter: firstLetter,
          ),
          SizedBox(height: 12),
          Text(
            name,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme.titleLarge
                ?.copyWith(
              color:
              colorScheme.onSurface,
              fontWeight:
              FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            username,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme.bodyMedium
                ?.copyWith(
              color:
              colorScheme.primary,
              fontWeight:
              FontWeight.w600,
            ),
          ),
          SizedBox(height: 22),
          LayoutBuilder(
            builder: (
                BuildContext context,
                BoxConstraints constraints,
                ) {
              double qrSize =
              (constraints.maxWidth - 24)
                  .clamp(
                180.0,
                230.0,
              )
                  .toDouble();

              return _ProfileQrImage(
                qrData: qrData,
                size: qrSize,
              );
            },
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                Icons
                    .qr_code_scanner_rounded,
                color: colorScheme
                    .onSurfaceVariant,
                size: 18,
              ),
              SizedBox(width: 7),
              Flexible(
                child: Text(
                  'Scan with another phone',
                  textAlign:
                  TextAlign.center,
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
    );
  }
}

class _ProfileQrAvatar
    extends StatelessWidget {
  final String firstLetter;

  _ProfileQrAvatar({
    required this.firstLetter,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 74,
      height: 74,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.primary
            .withValues(
          alpha: 0.13,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary
              .withValues(
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
    );
  }
}

class _ProfileQrImage
    extends StatelessWidget {
  final String qrData;
  final double size;

  _ProfileQrImage({
    required this.qrData,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(24),
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
            offset: Offset(
              0,
              5,
            ),
          ),
        ],
      ),
      child: QrImageView(
        data: qrData,
        version: QrVersions.auto,
        size: size,
        padding: EdgeInsets.all(8),
        backgroundColor: Colors.white,
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle:
        QrDataModuleStyle(
          dataModuleShape:
          QrDataModuleShape.square,
          color: Colors.black,
        ),
        errorStateBuilder: (
            BuildContext context,
            Object? error,
            ) {
          return SizedBox(
            width: size,
            height: size,
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
    );
  }
}