import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/auth/auth_controller.dart';
import '../phone_input/country_picker_sheet.dart';
import '../telegram_login_controller.dart';

/// ADDED: Standalone phone input row with country flag picker for RegisterScreen
class RegisterPhoneInputRow extends StatelessWidget {
  final AuthController controller;
  final TelegramLoginController phoneCtrl;
  final Color fieldColor;
  final Color borderColor;

  const RegisterPhoneInputRow({
    super.key,
    required this.controller,
    required this.phoneCtrl,
    required this.fieldColor,
    required this.borderColor,
  });

  Future<void> _openCountryPicker(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!context.mounted) return;

    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }
    if (!context.mounted) return;

    await CountryPickerSheet.show(
      context: context,
      controller: phoneCtrl,
      favoriteIsoCodes: const ['KH', 'US', 'CN', 'GB'],
    );

    controller.registerCountryCode.value = phoneCtrl.selectedCountryCode.value;
    controller.registerCountryName.value = phoneCtrl.selectedCountryName.value;
  }

  String _resolveFlagEmoji() {
    try {
      final cleanCode =
      phoneCtrl.selectedCountryCode.value.replaceAll('+', '').trim();
      if (cleanCode.isNotEmpty) {
        final country = CountryService().findByPhoneCode(cleanCode);
        if (country != null) return country.flagEmoji;
      }
    } catch (_) {}
    return '🌐';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'phone_number'.tr,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Code Button with Flag Emoji
            Obx(() {
              final String flag = _resolveFlagEmoji();

              return GestureDetector(
                onTap: () => _openCountryPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 52,
                  decoration: BoxDecoration(
                    color: fieldColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        phoneCtrl.selectedCountryCode.value,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        CupertinoIcons.chevron_down,
                        color: colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(width: 12),

            // Phone Number Text Field
            Expanded(
              child: TextFormField(
                controller: controller.registerPhoneController,
                focusNode: controller.registerPhoneFocusNode,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                cursorColor: colorScheme.primary,
                onFieldSubmitted: (_) {
                  controller.registerPasswordFocusNode.requestFocus();
                },
                validator: controller.validatePhone,
                decoration: InputDecoration(
                  hintText: 'enter_phone_number'.tr,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Icon(
                    CupertinoIcons.phone,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: fieldColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.8,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.error,
                      width: 1.8,
                    ),
                  ),
                  errorStyle: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}