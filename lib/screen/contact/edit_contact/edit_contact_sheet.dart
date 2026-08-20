import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/contact_model.dart';

/// Displays the modal bottom sheet for editing an existing phone contact
Future<void> showEditContactSheet({
  required BuildContext context,
  required ContactModel contact,
  required Future<void> Function(String firstName, String lastName, String phoneNumber) onSave,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (BuildContext sheetContext) {
      return _EditContactSheetContent(
        contact: contact,
        onSave: onSave,
      );
    },
  );
}

class _EditContactSheetContent extends StatefulWidget {
  final ContactModel contact;
  final Future<void> Function(String firstName, String lastName, String phoneNumber) onSave;

  const _EditContactSheetContent({
    required this.contact,
    required this.onSave,
  });

  @override
  State<_EditContactSheetContent> createState() => _EditContactSheetContentState();
}

class _EditContactSheetContentState extends State<_EditContactSheetContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Split the full name back into first / last
    final parts = widget.contact.name.trim().split(' ');
    final first = parts.isNotEmpty ? parts.first : '';
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    _firstNameController = TextEditingController(text: first);
    _lastNameController = TextEditingController(text: last);
    _phoneController = TextEditingController(text: widget.contact.phoneNumber);
  }

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
      );

      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      debugPrint('Error updating contact: $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
    final double sheetHeight = screenHeight * 0.80;

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

              // Drag handle
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 14, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'edit_contact'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    // Close button
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

              // Form
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // First Name
                        _buildField(
                          controller: _firstNameController,
                          focusNode: _firstNameFocusNode,
                          label: 'first_name'.tr,
                          hint: 'enter_first_name'.tr,
                          icon: CupertinoIcons.person,
                          textInputAction: TextInputAction.next,
                          fieldColor: fieldColor,
                          borderColor: borderColor,
                          colorScheme: colorScheme,
                          theme: theme,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'first_name_required'.tr;
                            }
                            return null;
                          },
                          onSubmitted: (_) => _lastNameFocusNode.requestFocus(),
                        ),

                        const SizedBox(height: 18),

                        // Last Name
                        _buildField(
                          controller: _lastNameController,
                          focusNode: _lastNameFocusNode,
                          label: 'last_name'.tr,
                          hint: 'enter_last_name'.tr,
                          icon: CupertinoIcons.person,
                          textInputAction: TextInputAction.next,
                          fieldColor: fieldColor,
                          borderColor: borderColor,
                          colorScheme: colorScheme,
                          theme: theme,
                          onSubmitted: (_) => _phoneFocusNode.requestFocus(),
                        ),

                        const SizedBox(height: 18),

                        // Phone Number
                        _buildField(
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          label: 'phone_number'.tr,
                          hint: 'enter_phone_number'.tr,
                          icon: CupertinoIcons.phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s]')),
                            LengthLimitingTextInputFormatter(20),
                          ],
                          fieldColor: fieldColor,
                          borderColor: borderColor,
                          colorScheme: colorScheme,
                          theme: theme,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'phone_number_required'.tr;
                            }
                            if (val.trim().length < 8) {
                              return 'valid_phone_number'.tr;
                            }
                            return null;
                          },
                          onSubmitted: (_) => _handleSave(),
                        ),

                        const SizedBox(height: 32),

                        // Save Button
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: _isSaving ? null : _handleSave,
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              disabledBackgroundColor:
                                  colorScheme.primary.withValues(alpha: 0.48),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isSaving
                                  ? Row(
                                      key: const ValueKey('saving'),
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                                          'saving'.tr,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      key: const ValueKey('save'),
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

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputAction textInputAction,
    required Color fieldColor,
    required Color borderColor,
    required ColorScheme colorScheme,
    required ThemeData theme,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
  }) {
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
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.words,
          inputFormatters: inputFormatters,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          cursorColor: colorScheme.primary,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
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
              borderSide: BorderSide(color: colorScheme.primary, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error, width: 1.8),
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
