import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/contact_controller.dart';
import '../qr_scan/qr_contact_scanner_binding.dart';
import '../../widgets/app_feedback.dart';
import '../show_add_contact_sheet.dart';

class ContactAddButton extends StatelessWidget {
  final ContactController controller;

  const ContactAddButton({
    super.key,
    required this.controller,
  });

  void _openAddContactSheet(
      BuildContext context, {
        String initialPhoneNumber = '',
      }) {
    FocusManager.instance.primaryFocus?.unfocus();

    showAddContactSheet(
      context: context,
      initialPhoneNumber: initialPhoneNumber,
      onAdd: (AddContactData contact) {
        controller.addContact(
          name: contact.fullName,
          phoneNumber: contact.phoneNumber,
        );
      },
      onAddViaQrCode: () {
        _openQrScanner(context);
      },
    );
  }

  Future<void> _openQrScanner(
      BuildContext context,
      ) async {
    final dynamic scannedValueResult = await QrContactScannerBinding.open();

    if (scannedValueResult == null || !context.mounted) {
      return;
    }

    if (scannedValueResult is String) {
      final String scannedValue = scannedValueResult;

      if (scannedValue.trim().isEmpty) {
        return;
      }

      String phoneNumber = _extractPhoneNumber(
        scannedValue,
      );

      if (phoneNumber.isEmpty) {
        _showInvalidQrMessage(
          context,
        );
        return;
      }

      _openAddContactSheet(
        context,
        initialPhoneNumber: phoneNumber,
      );
    }
  }

  String _extractPhoneNumber(
      String scannedValue,
      ) {
    String value = scannedValue.trim();

    Uri? uri = Uri.tryParse(value);

    if (uri != null && uri.scheme.toLowerCase() == 'tel') {
      return uri.path.trim();
    }

    RegExpMatch? phoneMatch = RegExp(
      r'\+?[0-9][0-9\s\-()]{6,}',
    ).firstMatch(value);

    if (phoneMatch == null) {
      return '';
    }

    return phoneMatch.group(0)?.trim() ?? '';
  }

  void _showInvalidQrMessage(
      BuildContext context,
      ) {
    AppFeedback.showMessage(
      title: 'invalid_qr_code'.tr,
      message: 'qr_no_phone_number'.tr,
      icon: CupertinoIcons.exclamationmark_circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color shadowColor = isDark
        ? Colors.black.withValues(
      alpha: 0.32,
    )
        : colorScheme.primary.withValues(
      alpha: 0.24,
    );

    return Positioned(
      right: 16,
      bottom: 110,
      child: Obx(
            () {
          bool isVisible = controller.showAddButton.value;

          return IgnorePointer(
            ignoring: !isVisible,
            child: AnimatedSlide(
              duration: Duration(
                milliseconds: 220,
              ),
              curve: Curves.easeOutCubic,
              offset: isVisible ? Offset.zero : Offset(0, 2),
              child: AnimatedOpacity(
                duration: Duration(
                  milliseconds: 180,
                ),
                curve: Curves.easeOutCubic,
                opacity: isVisible ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Tooltip(
                    message: 'add_contact'.tr,
                    child: FloatingActionButton(
                      heroTag: 'add_contact_fab',
                      elevation: 0,
                      highlightElevation: 0,
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      onPressed: () {
                        _openAddContactSheet(
                          context,
                        );
                      },
                      shape: CircleBorder(),
                      child: Icon(
                        CupertinoIcons.person_badge_plus,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}