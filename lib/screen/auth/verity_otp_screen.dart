import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/verify_otp_form.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String destination;
  final Future<void> Function(String otp)? onVerify;
  final Future<void> Function()? onResend;
  final VoidCallback? onVerified;

  const VerifyOtpScreen({
    super.key,
    required this.destination,
    this.onVerify,
    this.onResend,
    this.onVerified,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,

        // Controls the iOS/Android status-bar icon colors.
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness:
          isDark ? Brightness.dark : Brightness.light,
        ),

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).maybePop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
            size: 21,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (
                BuildContext context,
                BoxConstraints constraints,
                ) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: IntrinsicHeight(
                    child: AutofillGroup(
                      child: VerifyOtpForm(
                        destination: destination,
                        onVerify: onVerify,
                        onResend: onResend,
                        onVerified: onVerified,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}