import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../common/app_feedback.dart';

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
        _errorText = 'Please enter the 6-digit verification code';
      });

      return;
    }

    if (widget.onVerify == null) {
      AppFeedback.showMessage(
        title: 'API Not Connected',
        message: 'Connect your verify OTP API to continue.',
        icon: Icons.info_outline_rounded,
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
        title: 'OTP Verified',
        message: 'Verification code confirmed successfully.',
        icon: Icons.verified_outlined,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorText = 'Invalid or expired verification code';
      });

      AppFeedback.showMessage(
        title: 'Verification Failed',
        message: 'The verification code is invalid or has expired.',
        icon: Icons.error_outline_rounded,
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
        title: 'API Not Connected',
        message: 'Connect your resend OTP API to continue.',
        icon: Icons.info_outline_rounded,
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
        title: 'Code Sent',
        message: 'A new verification code has been sent.',
        icon: Icons.mark_email_read_outlined,
      );

      _otpFocusNode.requestFocus();
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppFeedback.showMessage(
        title: 'Unable to Resend',
        message: 'Unable to resend the code. Please try again.',
        icon: Icons.error_outline_rounded,
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

    String otp = _otpController.text;

    return Semantics(
      label: 'Six digit verification code',
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
                    theme.brightness == Brightness.dark
                        ? Color(0xFF1B1D22)
                        : Colors.white;

                    Color borderColor;

                    if (_errorText != null) {
                      borderColor = colorScheme.error;
                    } else if (isActive) {
                      borderColor = colorScheme.primary;
                    } else {
                      borderColor =
                          colorScheme.outlineVariant.withValues(
                            alpha: 0.65,
                          );
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
                          borderRadius: BorderRadius.circular(14),
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
        ? 'We sent a 6-digit verification code to your email.'
        : 'We sent a 6-digit verification code to $destination.';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Verify OTP',
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
          height: 55,
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
                borderRadius: BorderRadius.circular(14),
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
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Verifying...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
                  : Text(
                'Verify Code',
                key: ValueKey<String>(
                  'verify-otp-button',
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

        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Didn't receive the code?",
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
                    ? 'Resend in $_countdownText'
                    : 'Resend Code',
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
              'Change Email',
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