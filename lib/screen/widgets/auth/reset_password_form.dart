import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/app_feedback.dart';
import 'auth_text_field.dart';

class ResetPasswordForm extends StatefulWidget {
  final Future<void> Function(String password)? onSubmit;

  ResetPasswordForm({
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

  final TextEditingController _passwordController =
  TextEditingController();

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
      return 'Please enter your new password';
    }

    if (password.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    String confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Please confirm your new password';
    }

    if (confirmPassword != _passwordController.text) {
      return 'Passwords do not match';
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
        title: 'API Not Connected',
        message: 'Connect your reset-password API to continue.',
        icon: Icons.info_outline_rounded,
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
        title: 'Password Updated',
        message: 'Your password has been reset successfully.',
        icon: Icons.check_circle_outline_rounded,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppFeedback.showMessage(
        title: 'Reset Failed',
        message: 'Unable to reset your password. Please try again.',
        icon: Icons.error_outline_rounded,
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
            'Reset Password',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Create a new password for your account.',
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
            label: 'New Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            autofillHints: [
              AutofillHints.newPassword,
            ],
            validator: _validatePassword,
            onFieldSubmitted: (String value) {
              _confirmPasswordFocusNode.requestFocus();
            },
            suffixIcon: IconButton(
              tooltip: _obscurePassword
                  ? 'Show password'
                  : 'Hide password',
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          SizedBox(height: 18),

          AuthTextField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            label: 'Confirm New Password',
            icon: Icons.lock_reset_rounded,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            autofillHints: [
              AutofillHints.newPassword,
            ],
            validator: _validateConfirmPassword,
            onFieldSubmitted: (String value) {
              _resetPassword();
            },
            suffixIcon: IconButton(
              tooltip: _obscureConfirmPassword
                  ? 'Show password'
                  : 'Hide password',
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword =
                  !_obscureConfirmPassword;
                });
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          SizedBox(height: 24),

          SizedBox(
            height: 55,
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
                  borderRadius: BorderRadius.circular(14),
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
                      width: 21,
                      height: 21,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Resetting...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
                    : Text(
                  'Reset Password',
                  key: ValueKey<String>(
                    'reset-password-button',
                  ),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          Center(
            child: TextButton.icon(
              onPressed: _isLoading
                  ? null
                  : () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 19,
              ),
              label: Text(
                'Back to Login',
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