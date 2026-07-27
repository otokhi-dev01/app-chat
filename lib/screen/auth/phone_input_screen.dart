import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/auth/country_picker_sheet.dart';
import 'telegram_login_controller.dart';

class PhoneInputScreen extends StatelessWidget {
  const PhoneInputScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TelegramLoginController controller =
    Get.isRegistered<TelegramLoginController>()
        ? Get.find<TelegramLoginController>()
        : Get.put(TelegramLoginController());

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Color fieldColor = theme.inputDecorationTheme.fillColor ??
        colorScheme.surfaceContainerHighest;

    final Color borderColor =
    colorScheme.outlineVariant.withValues(alpha: 0.75);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: controller.isLoading.value
              ? null
              : () {
            FocusManager.instance.primaryFocus?.unfocus();
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
            size: 21,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    20,
                    24,
                    24,
                  ),
                  child: Form(
                    key: controller.phoneFormKey,
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(
                          theme: theme,
                          colorScheme: colorScheme,
                        ),

                        const SizedBox(height: 38),

                        Text(
                          'Country',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _CountrySelector(
                          controller: controller,
                          fieldColor: fieldColor,
                          borderColor: borderColor,
                          onPressed: () {
                            _showCountryPicker(
                              context,
                              controller,
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        Text(
                          'Phone Number',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CountryCodeButton(
                              controller: controller,
                              fieldColor: fieldColor,
                              borderColor: borderColor,
                              onPressed: () {
                                _showCountryPicker(
                                  context,
                                  controller,
                                );
                              },
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: TextFormField(
                                controller:
                                controller.phoneTextController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [
                                  AutofillHints.telephoneNumber,
                                ],
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly,
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                style:
                                theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                cursorColor: colorScheme.primary,
                                onFieldSubmitted: (_) {
                                  if (!controller.isLoading.value) {
                                    controller.sendCode();
                                  }
                                },
                                validator: _validatePhone,
                                decoration: InputDecoration(
                                  hintText: 'Enter phone number',
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    color:
                                    colorScheme.onSurfaceVariant,
                                    size: 21,
                                  ),
                                  filled: true,
                                  fillColor: fieldColor,
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 17,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: borderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: colorScheme.primary,
                                      width: 1.6,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: colorScheme.error,
                                    ),
                                  ),
                                  focusedErrorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: colorScheme.error,
                                      width: 1.6,
                                    ),
                                  ),
                                  errorStyle:
                                  theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'We will send a 6-digit verification code to this number.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              _BottomActions(
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String? _validatePhone(String? value) {
    final String phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Please enter your phone number';
    }

    if (phone.length < 8) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  void _showCountryPicker(
      BuildContext context,
      TelegramLoginController controller,
      ) {
    FocusManager.instance.primaryFocus?.unfocus();

    controller.countrySearchController.clear();
    controller.filterCountries('');

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor:
      theme.bottomSheetTheme.backgroundColor ?? colorScheme.surface,
      barrierColor: colorScheme.scrim.withValues(alpha: 0.45),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return CountryPickerSheet(
          controller: controller,
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _Header({
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.phone_iphone_rounded,
            color: colorScheme.onPrimaryContainer,
            size: 38,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'Your Number Phone',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 9),

        Text(
          'Enter the phone number connected to your account to receive an OTP code.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _CountrySelector extends StatelessWidget {
  final TelegramLoginController controller;
  final Color fieldColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const _CountrySelector({
    required this.controller,
    required this.fieldColor,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: fieldColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 56,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.public_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 21,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Obx(
                      () => Text(
                    controller.selectedCountryName.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryCodeButton extends StatelessWidget {
  final TelegramLoginController controller;
  final Color fieldColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const _CountryCodeButton({
    required this.controller,
    required this.fieldColor,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: fieldColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 92,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
            ),
          ),
          alignment: Alignment.center,
          child: Obx(
                () => Text(
              controller.selectedCountryCode.value,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final TelegramLoginController controller;

  const _BottomActions({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        12,
        24,
        20,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(
              alpha: 0.35,
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          Obx(
                () => SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.sendCode,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  disabledBackgroundColor:
                  colorScheme.primary.withValues(alpha: 0.48),
                  disabledForegroundColor:
                  colorScheme.onPrimary.withValues(alpha: 0.75),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: controller.isLoading.value
                      ? Row(
                    key: const ValueKey('sending-otp'),
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Sending...',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                      : Row(
                    key: const ValueKey('send-otp'),
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        'Send OTP',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          TextButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Get.back();
            },
            child: Text(
              'Back to Login',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}