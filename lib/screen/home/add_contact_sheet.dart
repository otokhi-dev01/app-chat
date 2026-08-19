import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../auth/phone_input/country_picker_sheet.dart';
import '../auth/telegram_login_controller.dart';

/// ADDED: Unit UI AddContactSheet allowing users to add a new contact with First Name, Last Name, and Phone Number
class AddContactSheet {
  AddContactSheet._();

  /// Displays the modal bottom sheet for creating a new contact
  static Future<void> show({
    required BuildContext context,
    required Future<void> Function(
        String firstName,
        String lastName,
        String phone,
        String countryCode,
        ) onSave,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (BuildContext sheetContext) {
        return _AddContactSheetContent(onSave: onSave);
      },
    );
  }
}

class _AddContactSheetContent extends StatefulWidget {
  final Future<void> Function(
      String firstName,
      String lastName,
      String phone,
      String countryCode,
      ) onSave;

  const _AddContactSheetContent({
    required this.onSave,
  });

  @override
  State<_AddContactSheetContent> createState() =>
      __AddContactSheetContentState();
}

class __AddContactSheetContentState extends State<_AddContactSheetContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _isSaving = false;

  TelegramLoginController get _phoneCtrl =>
      Get.isRegistered<TelegramLoginController>()
          ? Get.find<TelegramLoginController>()
          : Get.put(TelegramLoginController());

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  /// ADDED: Opens country picker sheet with smooth soft-keyboard dismissal
  Future<void> _openCountryPicker() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!mounted) return;

    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }
    if (!mounted) return;

    await CountryPickerSheet.show(
      context: context,
      controller: _phoneCtrl,
      favoriteIsoCodes: const ['KH', 'US', 'CN', 'GB'],
    );

    setState(() {});
  }

  /// ADDED: Dynamically resolves flag emoji for selected country dialing code
  String _resolveFlagEmoji() {
    try {
      final cleanCode =
      _phoneCtrl.selectedCountryCode.value.replaceAll('+', '').trim();
      if (cleanCode.isNotEmpty) {
        final country = CountryService().findByPhoneCode(cleanCode);
        if (country != null) return country.flagEmoji;
      }
    } catch (_) {}
    return '🌐';
  }

  /// ADDED: Form validation and save handler
  Future<void> _handleSave() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.onSave(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _phoneController.text.trim(),
        _phoneCtrl.selectedCountryCode.value,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      debugPrint('Error saving contact: $error');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color sheetColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color fieldColor = isDark ? const Color(0xFF26282E) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double sheetHeight = screenHeight * 0.85;

    // FIXED: Container color stays anchored to bottom edge so no black background gap shows when keyboard opens/closes
    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: SafeArea(
          top: false,
          bottom: keyboardHeight == 0,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Top Drag Handle
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),

              // Sheet Header (Title + Close 'X' Button)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 14, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'add_contact'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    // Circular 'X' close button
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: fieldColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor),
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: colorScheme.onSurface,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: borderColor),

              // Form Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- First Name Field ---
                        _buildInputField(
                          controller: _firstNameController,
                          focusNode: _firstNameFocusNode,
                          label: 'first_name'.tr,
                          hintText: 'enter_first_name'.tr,
                          icon: CupertinoIcons.person,
                          textInputAction: TextInputAction.next,
                          fieldColor: fieldColor,
                          borderColor: borderColor,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'please_enter_first_name'.tr;
                            }
                            return null;
                          },
                          onSubmitted: (_) {
                            _lastNameFocusNode.requestFocus();
                          },
                        ),

                        const SizedBox(height: 18),

                        // --- Last Name Field ---
                        _buildInputField(
                          controller: _lastNameController,
                          focusNode: _lastNameFocusNode,
                          label: 'last_name'.tr,
                          hintText: 'enter_last_name'.tr,
                          icon: CupertinoIcons.person,
                          textInputAction: TextInputAction.next,
                          fieldColor: fieldColor,
                          borderColor: borderColor,
                          onSubmitted: (_) {
                            _phoneFocusNode.requestFocus();
                          },
                        ),

                        const SizedBox(height: 18),

                        // --- Phone Number Field ---
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
                            // Country Code Flag Button
                            GestureDetector(
                              onTap: _openCountryPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
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
                                    Text(
                                      _resolveFlagEmoji(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _phoneCtrl.selectedCountryCode.value,
                                      style:
                                      theme.textTheme.bodyLarge?.copyWith(
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
                            ),

                            const SizedBox(width: 12),

                            // Phone Number Input
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                focusNode: _phoneFocusNode,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                cursorColor: colorScheme.primary,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'please_enter_phone_number'.tr;
                                  }
                                  if (val.trim().length < 8) {
                                    return 'please_enter_valid_phone_number'.tr;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) => _handleSave(),
                                decoration: InputDecoration(
                                  hintText: 'enter_phone_number'.tr,
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
                                    borderSide:
                                    BorderSide(color: colorScheme.error),
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

                        const SizedBox(height: 32),

                        // --- Save Contact Button ---
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: _isSaving ? null : _handleSave,
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              disabledBackgroundColor: colorScheme.primary
                                  .withValues(alpha: 0.48),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isSaving
                                  ? Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'saving_contact'.tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                                  : Text(
                                'save_contact'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hintText,
    required IconData icon,
    required TextInputAction textInputAction,
    required Color fieldColor,
    required Color borderColor,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
  }) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: textInputAction,
          textCapitalization: TextCapitalization.words,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          cursorColor: colorScheme.primary,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              icon,
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
      ],
    );
  }
}