import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

export 'add_contact_sheet.dart' show AddContactData;

Future<void> showAddContactSheet({
  required BuildContext context,
  required ValueChanged<AddContactData> onAdd,
  required VoidCallback onAddViaQrCode,
  String initialPhoneNumber = '',
}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(
      alpha: 0.42,
    ),
    builder: (BuildContext sheetContext) {
      return AddContactSheet(
        initialPhoneNumber: initialPhoneNumber,
        onAdd: onAdd,
        onAddViaQrCode: onAddViaQrCode,
      );
    },
  );
}

class AddContactData {
  final String firstName;
  final String lastName;
  final String phoneNumber;

  AddContactData({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  String get fullName {
    return '$firstName $lastName'.trim();
  }
}

class AddContactSheet extends StatefulWidget {
  final String initialPhoneNumber;
  final ValueChanged<AddContactData> onAdd;
  final VoidCallback? onAddViaQrCode;

  const AddContactSheet({
    super.key,
    this.initialPhoneNumber = '',
    required this.onAdd,
    this.onAddViaQrCode,
  });

  @override
  State<AddContactSheet> createState() {
    return _AddContactSheetState();
  }
}

class _AddContactSheetState extends State<AddContactSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();

    phoneController = TextEditingController(
      text: widget.initialPhoneNumber,
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  void _closeSheet() {
    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.of(context).pop();
  }

  void _submitContact() {
    FocusManager.instance.primaryFocus?.unfocus();

    bool isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    AddContactData contact = AddContactData(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
    );

    widget.onAdd(contact);

    Navigator.of(context).pop();
  }

  void _openQrCodeScanner() {
    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.of(context).pop();

    widget.onAddViaQrCode?.call();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color fieldColor = isDark
        ? Colors.white.withValues(
      alpha: 0.04,
    )
        : Colors.black.withValues(
      alpha: 0.025,
    );

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    double topSafeArea = MediaQuery.paddingOf(context).top;
    double maximumHeight = MediaQuery.sizeOf(context).height - topSafeArea - kToolbarHeight - 12;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: keyboardHeight,
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: maximumHeight,
          ),
          padding: EdgeInsets.fromLTRB(
            18,
            10,
            18,
            22,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDragHandle(
                    colorScheme,
                  ),
                  SizedBox(height: 18),
                  _buildHeader(
                    theme: theme,
                    colorScheme: colorScheme,
                    actionBackground: actionBackground,
                    borderColor: borderColor,
                  ),
                  SizedBox(height: 18),
                  Divider(
                    height: 1,
                    color: borderColor,
                  ),
                  if (widget.onAddViaQrCode != null) ...[
                    SizedBox(height: 18),
                    _AddViaQrCodeButton(
                      onTap: _openQrCodeScanner,
                    ),
                    SizedBox(height: 18),
                    _buildSectionDivider(
                      theme: theme,
                      colorScheme: colorScheme,
                      borderColor: borderColor,
                    ),
                    SizedBox(height: 18),
                  ] else
                    SizedBox(height: 18),
                  _AddContactTextField(
                    controller: firstNameController,
                    label: 'first_name'.tr,
                    hint: 'enter_first_name'.tr,
                    icon: CupertinoIcons.person,
                    textInputAction: TextInputAction.next,
                    fieldColor: fieldColor,
                    borderColor: borderColor,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'first_name_required'.tr;
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 14),
                  _AddContactTextField(
                    controller: lastNameController,
                    label: 'last_name'.tr,
                    hint: 'enter_last_name'.tr,
                    icon: CupertinoIcons.person,
                    textInputAction: TextInputAction.next,
                    fieldColor: fieldColor,
                    borderColor: borderColor,
                  ),
                  SizedBox(height: 14),
                  _AddContactTextField(
                    controller: phoneController,
                    label: 'phone_number'.tr,
                    hint: '+855 12 345 678',
                    icon: CupertinoIcons.phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    fieldColor: fieldColor,
                    borderColor: borderColor,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'[0-9+\-\s()]',
                        ),
                      ),
                    ],
                    onSubmitted: (_) {
                      _submitContact();
                    },
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'phone_number_required'.tr;
                      }

                      int digitCount = value
                          .replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      )
                          .length;

                      if (digitCount < 7) {
                        return 'valid_phone_number'.tr;
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 22),
                  _buildSubmitButton(
                    colorScheme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle(
      ColorScheme colorScheme,
      ) {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant.withValues(
          alpha: 0.28,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildHeader({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Color actionBackground,
    required Color borderColor,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(
              alpha: 0.11,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            CupertinoIcons.person_badge_plus,
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
                'add_contact'.tr,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'create_new_contact'.tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Unit Close Button UI
        Container(
          width: 36,
          height: 36,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: actionBackground,
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size(36, 36),
            onPressed: _closeSheet,
            child: Icon(
              CupertinoIcons.xmark,
              size: 18,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionDivider({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Color borderColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            height: 1,
            color: borderColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            'or_enter_details'.tr,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            height: 1,
            color: borderColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
      ColorScheme colorScheme,
      ) {
    return FilledButton.icon(
      onPressed: _submitContact,
      icon: Icon(
        CupertinoIcons.person_badge_plus,
        color: colorScheme.onPrimary,
        size: 20,
      ),
      label: Text(
        'add_contact'.tr,
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: FilledButton.styleFrom(
        minimumSize: Size(double.infinity, 52),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _AddViaQrCodeButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddViaQrCodeButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color backgroundColor = isDark
        ? Colors.white.withValues(
      alpha: 0.06,
    )
        : Color(0xFFF6F7F9);

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(
                    alpha: 0.11,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  CupertinoIcons.qrcode_viewfinder,
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
                      'add_via_qr_code'.tr,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'scan_contact_qr_code'.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddContactTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color fieldColor;
  final Color borderColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  const _AddContactTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.fieldColor,
    required this.borderColor,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 4,
            bottom: 7,
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(
                alpha: 0.70,
              ),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: colorScheme.primary,
              size: 20,
            ),
            filled: true,
            fillColor: fieldColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
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
                width: 1.4,
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
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}