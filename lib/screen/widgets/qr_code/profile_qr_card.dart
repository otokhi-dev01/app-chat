import 'package:appchat/screen/widgets/qr_code/qr_design_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../controllers/qr_code/qr_design_controller.dart';

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

  QrDesignController get _designController {
    if (!Get.isRegistered<QrDesignController>()) {
      Get.put(QrDesignController(), permanent: true);
    }

    return Get.find<QrDesignController>();
  }

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

    QrDesignController designController =
        _designController;

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
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: _ProfileQrAvatar(
                  firstLetter: firstLetter,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: _CustomizeButton(
                  onTap: () {
                    showQrDesignSheet(context);
                  },
                ),
              ),
            ],
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

              return Obx(
                    () => _ProfileQrImage(
                  qrData: qrData,
                  size: qrSize,
                  moduleShape: designController
                      .moduleShape.value,
                  eyeShape:
                  designController.eyeShape.value,
                  foregroundColor: designController
                      .qrColor.value,
                  backgroundColor: designController
                      .qrBackground.value,
                ),
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

class _CustomizeButton extends StatelessWidget {
  final VoidCallback onTap;

  _CustomizeButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.primary.withValues(
        alpha: 0.10,
      ),
      shape: CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            Icons.palette_outlined,
            size: 18,
            color: colorScheme.primary,
          ),
        ),
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
  final QrDataModuleShape moduleShape;
  final QrEyeShape eyeShape;
  final Color foregroundColor;
  final Color backgroundColor;

  _ProfileQrImage({
    required this.qrData,
    required this.size,
    required this.moduleShape,
    required this.eyeShape,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: Duration(milliseconds: 220),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
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
        backgroundColor: backgroundColor,
        eyeStyle: QrEyeStyle(
          eyeShape: eyeShape,
          color: foregroundColor,
        ),
        dataModuleStyle:
        QrDataModuleStyle(
          dataModuleShape: moduleShape,
          color: foregroundColor,
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