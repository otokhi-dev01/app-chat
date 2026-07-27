import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/app_feedback.dart';
import 'auth_text_field.dart';

class ForgotPasswordForm extends StatefulWidget {
  final Future<void> Function(String email)? onSubmit;

  ForgotPasswordForm({
    super.key,
    this.onSubmit,
  });

  @override
  State<ForgotPasswordForm> createState() {
    return _ForgotPasswordFormState();
  }
}

class _ForgotPasswordFormState
    extends State<ForgotPasswordForm> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController();

  final FocusNode _emailFocusNode =
  FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  String? _validateEmail(
      String? value,
      ) {
    String email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'email_required'.tr;
    }

    if (!GetUtils.isEmail(email)) {
      return 'invalid_email'.tr;
    }

    return null;
  }

  Future<void> _sendResetLink() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    bool isValid =
        _formKey.currentState?.validate() ??
            false;

    if (!isValid) {
      return;
    }

    if (widget.onSubmit == null) {
      AppFeedback.showMessage(
        title: 'api_not_connected'.tr,
        message:
        'forgot_password_api_not_connected_message'
            .tr,
        icon: Icons.info_outline_rounded,
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSubmit!(
        _emailController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      AppFeedback.showMessage(
        title: 'email_sent'.tr,
        message:
        'reset_instructions_sent_message'.tr,
        icon:
        Icons.mark_email_read_outlined,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppFeedback.showMessage(
        title: 'unable_to_send'.tr,
        message:
        'unable_to_send_reset_link_message'
            .tr,
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
    ColorScheme colorScheme =
        theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          Text(
            'forgot_password_title'.tr,
            textAlign: TextAlign.center,
            style: theme
                .textTheme.headlineMedium
                ?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: 8,
          ),

          Text(
            'forgot_password_description'.tr,
            textAlign: TextAlign.center,
            style:
            theme.textTheme.bodyMedium
                ?.copyWith(
              color:
              colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          SizedBox(
            height: 38,
          ),

          AuthTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            label: 'email'.tr,
            icon: Icons.email_outlined,
            keyboardType:
            TextInputType.emailAddress,
            textInputAction:
            TextInputAction.done,
            autofillHints: [
              AutofillHints.email,
              AutofillHints.username,
            ],
            validator: _validateEmail,
            onFieldSubmitted: (
                String value,
                ) {
              _sendResetLink();
            },
          ),

          SizedBox(
            height: 24,
          ),

          SizedBox(
            height: 55,
            child: FilledButton(
              onPressed: _isLoading
                  ? null
                  : _sendResetLink,
              style: FilledButton.styleFrom(
                backgroundColor:
                colorScheme.primary,
                foregroundColor:
                colorScheme.onPrimary,
                disabledBackgroundColor:
                colorScheme.primary
                    .withValues(
                  alpha: 0.48,
                ),
                disabledForegroundColor:
                colorScheme.onPrimary
                    .withValues(
                  alpha: 0.75,
                ),
                elevation: 0,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),
              ),
              child: AnimatedSwitcher(
                duration: Duration(
                  milliseconds: 200,
                ),
                child: _isLoading
                    ? Row(
                  key:
                  ValueKey<String>(
                    'forgot-password-loading',
                  ),
                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,
                  children: [
                    SizedBox(
                      width: 21,
                      height: 21,
                      child:
                      CircularProgressIndicator(
                        strokeWidth:
                        2.4,
                        color:
                        colorScheme
                            .onPrimary,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'sending'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    ),
                  ],
                )
                    : Text(
                  'send_reset_link'.tr,
                  key:
                  ValueKey<String>(
                    'send-reset-link-button',
                  ),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 16,
          ),

          Center(
            child: TextButton.icon(
              onPressed: _isLoading
                  ? null
                  : () {
                FocusManager
                    .instance
                    .primaryFocus
                    ?.unfocus();

                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 19,
              ),
              label: Text(
                'back_to_login'.tr,
                style: TextStyle(
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}