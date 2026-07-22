import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/qr_contact_scanner_controller.dart';
import '../../widgets/qr_code/qr_scanner_buttons.dart';

class QrScannerBottomPanel
    extends StatelessWidget {
  final QrContactScannerController
  controller;

  QrScannerBottomPanel({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1B1D22)
                .withValues(
              alpha: 0.90,
            ),
            borderRadius:
            BorderRadius.circular(
              24,
            ),
            border: Border.all(
              color: Colors.white
                  .withValues(
                alpha: 0.10,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(
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
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment:
                    Alignment.center,
                    decoration:
                    BoxDecoration(
                      color: colorScheme
                          .primary
                          .withValues(
                        alpha: 0.14,
                      ),
                      borderRadius:
                      BorderRadius
                          .circular(
                        15,
                      ),
                    ),
                    child: Icon(
                      Icons
                          .center_focus_strong_rounded,
                      color: colorScheme
                          .primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          'Place the QR code in the frame',
                          style: theme
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                            color:
                            Colors.white,
                            fontSize: 14,
                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'The border follows the QR code automatically',
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: Colors.white
                                .withValues(
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
                        bool isTorchOn =
                            controller
                                .isTorchOn
                                .value;

                        return QrScannerActionButton(
                          icon: isTorchOn
                              ? Icons
                              .flash_on_rounded
                              : Icons
                              .flash_off_rounded,
                          label: isTorchOn
                              ? 'Flash on'
                              : 'Flash off',
                          isActive:
                          isTorchOn,
                          onTap: controller
                              .toggleTorch,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                          () {
                        bool isSwitching =
                            controller
                                .isSwitchingCamera
                                .value;

                        return QrScannerActionButton(
                          icon: Icons
                              .cameraswitch_rounded,
                          label: isSwitching
                              ? 'Switching...'
                              : 'Flip camera',
                          isActive: false,
                          isLoading:
                          isSwitching,
                          onTap: controller
                              .switchCamera,
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