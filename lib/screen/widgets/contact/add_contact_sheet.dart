import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  AddContactSheet({
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

class _AddContactSheetState
    extends State<AddContactSheet> {
  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    firstNameController =
        TextEditingController();

    lastNameController =
        TextEditingController();

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

    bool isValid =
        formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    AddContactData contact = AddContactData(
      firstName:
      firstNameController.text.trim(),
      lastName:
      lastNameController.text.trim(),
      phoneNumber:
      phoneController.text.trim(),
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

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color fieldColor = isDark
        ? Colors.white.withValues(
      alpha: 0.06,
    )
        : Color(0xFFF6F7F9);

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    double keyboardHeight =
        MediaQuery.viewInsetsOf(context).bottom;

    double maximumHeight =
        MediaQuery.sizeOf(context).height * 0.92;

    return AnimatedPadding(
      duration: Duration(
        milliseconds: 220,
      ),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(
        bottom: keyboardHeight,
      ),
      child: Material(
        color: cardColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          side: BorderSide(
            color: borderColor,
          ),
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: maximumHeight,
          ),
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            20,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior
                .onDrag,
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
                    actionBackground:
                    actionBackground,
                  ),

                  SizedBox(height: 18),

                  Divider(
                    height: 1,
                    color: borderColor,
                  ),

                  if (widget.onAddViaQrCode != null)
                    ...[
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
                    ]
                  else
                    SizedBox(height: 18),

                  _AddContactTextField(
                    controller:
                    firstNameController,
                    label: 'First name',
                    hint: 'Enter first name',
                    icon:
                    Icons.person_outline_rounded,
                    textInputAction:
                    TextInputAction.next,
                    fieldColor: fieldColor,
                    borderColor: borderColor,
                    validator: (String? value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'First name is required';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 14),

                  _AddContactTextField(
                    controller:
                    lastNameController,
                    label: 'Last name',
                    hint: 'Enter last name',
                    icon: Icons.badge_outlined,
                    textInputAction:
                    TextInputAction.next,
                    fieldColor: fieldColor,
                    borderColor: borderColor,
                  ),

                  SizedBox(height: 14),

                  _AddContactTextField(
                    controller: phoneController,
                    label: 'Phone number',
                    hint: '+855 12 345 678',
                    icon: Icons.phone_outlined,
                    keyboardType:
                    TextInputType.phone,
                    textInputAction:
                    TextInputAction.done,
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
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Phone number is required';
                      }

                      int digitCount = value
                          .replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      )
                          .length;

                      if (digitCount < 7) {
                        return 'Enter a valid phone number';
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
        color: colorScheme.onSurfaceVariant
            .withValues(
          alpha: 0.25,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildHeader({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Color actionBackground,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(
              alpha: 0.11,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            Icons.person_add_alt_1_rounded,
            color: colorScheme.primary,
            size: 24,
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Add contact',
                style:
                theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Create a new contact',
                style:
                theme.textTheme.bodySmall?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        Tooltip(
          message: 'Close',
          child: Material(
            color: actionBackground,
            shape: CircleBorder(),
            child: InkWell(
              onTap: _closeSheet,
              customBorder: CircleBorder(),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close_rounded,
                  color: colorScheme.onSurface,
                  size: 21,
                ),
              ),
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
            'or enter contact details',
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
    return Material(
      color: colorScheme.primary,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: _submitContact,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_rounded,
                color: colorScheme.onPrimary,
                size: 22,
              ),
              SizedBox(width: 9),
              Text(
                'Add contact',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddViaQrCodeButton
    extends StatelessWidget {
  final VoidCallback onTap;

  _AddViaQrCodeButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

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
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(
                    alpha: 0.11,
                  ),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: colorScheme.primary,
                  size: 25,
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add via QR code',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Scan a contact QR code',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddContactTextField
    extends StatelessWidget {
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

  _AddContactTextField({
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
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 4,
            bottom: 7,
          ),
          child: Text(
            label,
            style:
            theme.textTheme.bodyMedium?.copyWith(
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
          style:
          theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
            theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant
                  .withValues(
                alpha: 0.70,
              ),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: colorScheme.primary,
              size: 21,
            ),
            filled: true,
            fillColor: fieldColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 17,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(16),
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.error,
              ),
            ),
            focusedErrorBorder:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(16),
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