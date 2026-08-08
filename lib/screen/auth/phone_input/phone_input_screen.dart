import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../telegram_login_controller.dart';
import 'country_picker_sheet.dart';

class PhoneInputScreen extends StatelessWidget {
  const PhoneInputScreen({
    super.key,
  });

  SystemUiOverlayStyle _overlayStyle(ThemeData theme, bool isDark) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TelegramLoginController controller =
    Get.isRegistered<TelegramLoginController>()
        ? Get.find<TelegramLoginController>()
        : Get.put(TelegramLoginController());

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color appBarColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    final Color actionBackground =
    isDark ? const Color(0xFF1B1D22) : Colors.white;

    final Color fieldColor =
    isDark ? const Color(0xFF1B1D22) : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final SystemUiOverlayStyle overlayStyle = _overlayStyle(theme, isDark);
    final double topPadding = MediaQuery.of(context).padding.top + 68;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          forceMaterialTransparency: true,
          leadingWidth: 58,
          titleSpacing: 0,
          systemOverlayStyle: overlayStyle,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 18,
                sigmaY: 18,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: appBarColor,
                  border: Border(
                    bottom: BorderSide(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
            child: Tooltip(
              message: 'Back',
              child: Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: actionBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: borderColor,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.15 : 0.04,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 40),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Get.back();
                  },
                  child: Icon(
                    CupertinoIcons.chevron_left,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            'Phone Number',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
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
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(24, topPadding, 24, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - topPadding - 24,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: controller.phoneFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Your Phone Number',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Enter the phone number connected to your account to receive an OTP code.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
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
                                    controller: controller.phoneTextController,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [
                                      AutofillHints.telephoneNumber,
                                    ],
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    style: theme.textTheme.bodyLarge?.copyWith(
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
                                      hintStyle:
                                      theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.6),
                                      ),
                                      prefixIcon: Icon(
                                        CupertinoIcons.phone,
                                        color: colorScheme.onSurfaceVariant,
                                        size: 20,
                                      ),
                                      filled: true,
                                      fillColor: fieldColor,
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 15,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: borderColor,
                                        ),
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
                                        borderSide: BorderSide(
                                          color: colorScheme.error,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: colorScheme.error,
                                          width: 1.8,
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

                            const Spacer(),

                            const SizedBox(height: 24),

                            Obx(
                                  () => SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: FilledButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.sendCode,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    disabledBackgroundColor: colorScheme.primary
                                        .withValues(alpha: 0.48),
                                    disabledForegroundColor: colorScheme.onPrimary
                                        .withValues(alpha: 0.75),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
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
                                          width: 20,
                                          height: 20,
                                          child:
                                          CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: colorScheme.onPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Sending...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onPrimary,
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
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          CupertinoIcons.arrow_right,
                                          color: colorScheme.onPrimary,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: TextButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Get.back();
                                },
                                child: Text(
                                  'Back to Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
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

  Future<void> _showCountryPicker(
      BuildContext context,
      TelegramLoginController controller,
      ) async {
    // Unfocus active keyboard first
    FocusManager.instance.primaryFocus?.unfocus();

    // If keyboard is currently open, wait 80ms for smooth dismissal without layout clash
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }

    if (!context.mounted) return;

    await CountryPickerSheet.show(
      context: context,
      controller: controller,
      favoriteIsoCodes: const ['KH', 'US', 'CN', 'GB'],
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
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 52,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Obx(() {
                final String flag = _resolveFlagEmoji(controller);
                return Text(
                  flag,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                );
              }),

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
                CupertinoIcons.chevron_down,
                color: colorScheme.onSurfaceVariant,
                size: 18,
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
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
            ),
          ),
          alignment: Alignment.center,
          child: Obx(() {
            final String flag = _resolveFlagEmoji(controller);
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  flag,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 6),
                Text(
                  controller.selectedCountryCode.value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

/// Helper function to resolve country flag emoji dynamically.
String _resolveFlagEmoji(TelegramLoginController controller) {
  try {
    final dynamic c = controller;
    if (c.selectedCountryFlagEmoji != null &&
        c.selectedCountryFlagEmoji.value.toString().isNotEmpty) {
      return c.selectedCountryFlagEmoji.value.toString();
    }
  } catch (_) {}

  try {
    final String cleanCode = controller.selectedCountryCode.value
        .replaceAll('+', '')
        .trim();
    if (cleanCode.isNotEmpty) {
      final Country? country = CountryService().findByPhoneCode(cleanCode);
      if (country != null) {
        return country.flagEmoji;
      }
    }
  } catch (_) {}

  return '🌐';
}