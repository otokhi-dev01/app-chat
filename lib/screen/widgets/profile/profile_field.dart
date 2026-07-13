import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? prefixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;

  const ProfileField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.prefixText,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color fieldColor = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.025);

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    OutlineInputBorder border({
      required Color color,
      double width = 1,
    }) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.11,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 58,
          minHeight: 58,
        ),
        filled: true,
        fillColor: fieldColor,
        counterStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: border(color: borderColor),
        enabledBorder: border(color: borderColor),
        focusedBorder: border(
          color: colorScheme.primary,
          width: 1.5,
        ),
        errorBorder: border(
          color: colorScheme.error,
        ),
        focusedErrorBorder: border(
          color: colorScheme.error,
          width: 1.5,
        ),
      ),
    );
  }
}