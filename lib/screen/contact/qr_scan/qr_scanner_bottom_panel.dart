import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/qr_contact_scanner_controller.dart';
import '../../widgets/qr_code/qr_scanner_buttons.dart';

class QrScannerBottomPanel extends StatelessWidget {
  final QrContactScannerController controller;

  const QrScannerBottomPanel({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1B1D22).withValues(
              alpha: 0.88,
            ),
            borderRadius: BorderRadius.circular(
              24,
            ),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.28,
                ),
                blurRadius: 26,
                offset: Offset(
                  0,
                  12,
                ),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(
                        alpha: 0.14,
                      ),
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Icon(
                      CupertinoIcons.viewfinder,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'place_qr_in_frame'.tr,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'qr_auto_follow_desc'.tr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(
                              alpha: 0.65,
                            ),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                          () {
                        bool isTorchOn = controller.isTorchOn.value;

                        return QrScannerActionButton(
                          icon: isTorchOn
                              ? CupertinoIcons.bolt_fill
                              : CupertinoIcons.bolt_slash_fill,
                          label: isTorchOn ? 'flash_on'.tr : 'flash_off'.tr,
                          isActive: isTorchOn,
                          onTap: controller.toggleTorch,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                          () {
                        bool isSwitching =
                            controller.isSwitchingCamera.value;

                        return QrScannerActionButton(
                          icon: CupertinoIcons.camera_rotate,
                          label: isSwitching
                              ? 'switching'.tr
                              : 'flip_camera'.tr,
                          isActive: false,
                          isLoading: isSwitching,
                          onTap: controller.switchCamera,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}