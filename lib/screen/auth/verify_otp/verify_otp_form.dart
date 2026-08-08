import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widgets/app_feedback.dart';

class VerifyOtpForm extends StatefulWidget {
  final String destination;
  final Future<void> Function(String otp)? onVerify;
  final Future<void> Function()? onResend;
  final VoidCallback? onVerified;

  const VerifyOtpForm({
    super.key,
    required this.destination,
    this.onVerify,
    this.onResend,
    this.onVerified,
  });

  @override
  State<VerifyOtpForm> createState() {
    return _VerifyOtpFormState();
  }
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  Timer? _resendTimer;

  int _secondsRemaining = 60;

  bool _isVerifying = false;
  bool _isResending = false;

  String? _errorText;

  @override
  void initState() {
    super.initState();

    _otpFocusNode.addListener(_handleFocusChange);
    _startResendTimer();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startResendTimer({
    bool resetSeconds = true,
  }) {
    _resendTimer?.cancel();

    if (resetSeconds) {
      _secondsRemaining = 60;
    }

    _resendTimer = Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_secondsRemaining <= 1) {
          timer.cancel();

          setState(() {
            _secondsRemaining = 0;
          });

          return;
        }

        setState(() {
          _secondsRemaining--;
        });
      },
    );
  }

  String get _countdownText {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    String otp = _otpController.text.trim();

    if (otp.length != 6) {
      setState(() {
        _errorText = 'enter_6_digit_code'.tr;
      });

      return;
    }

    if (widget.onVerify == null) {
      AppFeedback.showMessage(
        title: 'api_not_connected'.tr,
        message: 'connect_verify_otp_api'.tr,
        icon: CupertinoIcons.info_circle,
      );

      return;
    }

    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    bool verified = false;

    try {
      await widget.onVerify!(otp);

      if (!mounted) {
        return;
      }

      verified = true;

      AppFeedback.showMessage(
        title: 'otp_verified'.tr,
        message: 'verification_code_confirmed'.tr,
        icon: CupertinoIcons.checkmark_circle,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorText = 'invalid_or_expired_code'.tr;
      });

      AppFeedback.showMessage(
        title: 'verification_failed'.tr,
        message: 'invalid_or_expired_code_message'.tr,
        icon: CupertinoIcons.exclamationmark_circle,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }

    if (verified && mounted) {
      widget.onVerified?.call();
    }
  }

  Future<void> _resendOtp() async {
    if (_secondsRemaining > 0 || _isResending || _isVerifying) {
      return;
    }

    if (widget.onResend == null) {
      AppFeedback.showMessage(
        title: 'api_not_connected'.tr,
        message: 'connect_resend_otp_api'.tr,
        icon: CupertinoIcons.info_circle,
      );

      return;
    }

    setState(() {
      _isResending = true;
      _errorText = null;
    });

    try {
      await widget.onResend!();

      if (!mounted) {
        return;
      }

      _otpController.clear();

      setState(() {
        _secondsRemaining = 60;
      });

      _startResendTimer(
        resetSeconds: false,
      );

      AppFeedback.showMessage(
        title: 'code_sent'.tr,
        message: 'new_verification_code_sent'.tr,
        icon: CupertinoIcons.mail,
      );

      _otpFocusNode.requestFocus();
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppFeedback.showMessage(
        title: 'unable_to_resend'.tr,
        message: 'unable_to_resend_code_message'.tr,
        icon: CupertinoIcons.exclamationmark_circle,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  Widget _buildOtpInput(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    String otp = _otpController.text;

    return Semantics(
      label: 'six_digit_code'.tr,
      textField: true,
      child: GestureDetector(
        onTap: () {
          if (!_isVerifying) {
            _otpFocusNode.requestFocus();
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.01,
                child: TextField(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  enabled: !_isVerifying,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  autofillHints: [
                    AutofillHints.oneTimeCode,
                  ],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  style: TextStyle(
                    color: Colors.transparent,
                  ),
                  cursorColor: Colors.transparent,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _errorText = null;
                    });
                  },
                  onSubmitted: (String value) {
                    _verifyOtp();
                  },
                ),
              ),
            ),
            IgnorePointer(
              child: Row(
                children: List<Widget>.generate(
                  6,
                      (int index) {
                    bool hasValue = index < otp.length;

                    bool isActive = _otpFocusNode.hasFocus &&
                        index == (otp.length >= 6 ? 5 : otp.length);

                    Color backgroundColor =
                    isDark ? Color(0xFF1B1D22) : Colors.white;

                    Color borderColor;

                    if (_errorText != null) {
                      borderColor = colorScheme.error;
                    } else if (isActive) {
                      borderColor = colorScheme.primary;
                    } else {
                      borderColor = isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06);
                    }

                    return Expanded(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 180),
                        height: 58,
                        margin: EdgeInsets.only(
                          right: index == 5 ? 0 : 8,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: isActive ? 1.8 : 1,
                          ),
                        ),
                        child: Text(
                          hasValue ? otp[index] : '',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _resendTimer?.cancel();

    _otpFocusNode.removeListener(_handleFocusChange);
    _otpController.dispose();
    _otpFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    String destination = widget.destination.trim();

    String description = destination.isEmpty
        ? 'sent_code_description'.tr
        : 'sent_code_to_destination'.trParams({'destination': destination});

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'verify_otp'.tr,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        SizedBox(height: 38),
        Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
            ),
            child: _buildOtpInput(context),
          ),
        ),
        if (_errorText != null) ...[
          SizedBox(height: 10),
          Text(
            _errorText!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ],
        SizedBox(height: 24),
        SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: _isVerifying ? null : _verifyOtp,
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
              child: _isVerifying
                  ? Row(
                key: ValueKey<String>(
                  'verify-otp-loading',
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
                    'verifying'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
                  : Text(
                'verify_code'.tr,
                key: ValueKey<String>(
                  'verify-otp-button',
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
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'didnt_receive_code'.tr,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: _secondsRemaining == 0 &&
                  !_isResending &&
                  !_isVerifying
                  ? _resendOtp
                  : null,
              child: _isResending
                  ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
                  : Text(
                _secondsRemaining > 0
                    ? 'resend_in'.trParams({'time': _countdownText})
                    : 'resend_code'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        Center(
          child: TextButton(
            onPressed: _isVerifying || _isResending
                ? null
                : () {
              FocusManager.instance.primaryFocus?.unfocus();
              Get.back();
            },
            child: Text(
              'change_email'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}