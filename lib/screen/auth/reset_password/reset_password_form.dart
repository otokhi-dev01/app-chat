import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/app_feedback.dart';
import 'auth_text_field.dart';

class ResetPasswordForm extends StatefulWidget {
  final Future<void> Function(String password)? onSubmit;

  const ResetPasswordForm({
    super.key,
    this.onSubmit,
  });

  @override
  State<ResetPasswordForm> createState() {
    return _ResetPasswordFormState();
  }
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    String password = value ?? '';

    if (password.isEmpty) {
      return 'please_enter_new_password'.tr;
    }

    if (password.length < 6) {
      return 'password_min_6_characters'.tr;
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    String confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'please_confirm_new_password'.tr;
    }

    if (confirmPassword != _passwordController.text) {
      return 'passwords_do_not_match'.tr;
    }

    return null;
  }

  Future<void> _resetPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (widget.onSubmit == null) {
      AppFeedback.showMessage(
        title: 'api_not_connected'.tr,
        message: 'connect_reset_password_api'.tr,
        icon: CupertinoIcons.info_circle,
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSubmit!(
        _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      AppFeedback.showMessage(
        title: 'password_updated'.tr,
        message: 'password_reset_successfully'.tr,
        icon: CupertinoIcons.checkmark_circle,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppFeedback.showMessage(
        title: 'reset_failed'.tr,
        message: 'unable_to_reset_password'.tr,
        icon: CupertinoIcons.exclamationmark_circle,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'reset_password'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'create_new_password_description'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          SizedBox(height: 38),

          AuthTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            label: 'new_password'.tr,
            icon: CupertinoIcons.lock,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            autofillHints: const [
              AutofillHints.newPassword,
            ],
            validator: _validatePassword,
            onFieldSubmitted: (String value) {
              _confirmPasswordFocusNode.requestFocus();
            },
            suffixIcon: IconButton(
              tooltip: _obscurePassword
                  ? 'show_password'.tr
                  : 'hide_password'.tr,
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          SizedBox(height: 18),

          AuthTextField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            label: 'confirm_new_password'.tr,
            icon: CupertinoIcons.lock_shield,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [
              AutofillHints.newPassword,
            ],
            validator: _validateConfirmPassword,
            onFieldSubmitted: (String value) {
              _resetPassword();
            },
            suffixIcon: IconButton(
              tooltip: _obscureConfirmPassword
                  ? 'show_password'.tr
                  : 'hide_password'.tr,
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _isLoading ? null : _resetPassword,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: colorScheme.primary.withValues(
                  alpha: 0.48,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: _isLoading
                    ? Row(
                  key: ValueKey<String>(
                    'reset-password-loading',
                  ),
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
                    SizedBox(width: 10),
                    Text(
                      'resetting'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
                    : Text(
                  'reset_password'.tr,
                  key: ValueKey<String>(
                    'reset-password-button',
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          Center(
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              },
              child: Text(
                'back_to_login'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}