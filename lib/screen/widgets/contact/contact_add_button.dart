import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/contact_controller.dart';
import '../../contact/qr_scan/qr_contact_scanner_binding.dart';
import 'show_add_contact_sheet.dart';

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
    // 1. Await the dynamic result of the binding's route (removing <String> to avoid GetX cast error)
    final dynamic scannedValueResult = await QrContactScannerBinding.open();

    if (scannedValueResult == null || !context.mounted) {
      return;
    }

    // 2. Perform a safe runtime type-check on the returned value
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
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'This QR code does not contain a phone number',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.error,
          margin: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
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
              duration: const Duration(
                milliseconds: 220,
              ),
              curve: Curves.easeOutCubic,
              offset: isVisible ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(
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
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Tooltip(
                    message: 'Add contact',
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
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 23,
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