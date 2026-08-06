import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;
  final bool obscureText;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color fieldBackground = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    OutlineInputBorder inputBorder({
      required Color color,
      double width = 1,
    }) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      autocorrect: !obscureText,
      enableSuggestions: !obscureText,
      cursorColor: colorScheme.primary,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: fieldBackground,
        prefixIcon: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
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
        prefixIconConstraints: BoxConstraints(
          minWidth: 58,
          minHeight: 58,
        ),
        suffixIcon: suffixIcon,
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: inputBorder(
          color: borderColor,
        ),
        enabledBorder: inputBorder(
          color: borderColor,
        ),
        focusedBorder: inputBorder(
          color: colorScheme.primary,
          width: 1.5,
        ),
        errorBorder: inputBorder(
          color: colorScheme.error,
        ),
        focusedErrorBorder: inputBorder(
          color: colorScheme.error,
          width: 1.5,
        ),
      ),
    );
  }
}