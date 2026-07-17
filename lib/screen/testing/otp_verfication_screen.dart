import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'telegram_login_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TelegramLoginController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String fullPhone = '${controller.selectedCountryCode.value} ${controller.phoneTextController.text}';

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable upper content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Minimalist Shield/Lock Icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_open_rounded,
                        color: colorScheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      'Enter Code',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // RichText for clean phone number highlighting
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.55),
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'We sent an SMS verification code to\n'),
                          TextSpan(
                            text: fullPhone,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // OTP Input Fields
                    _OtpInputGrid(controller: controller),

                    const SizedBox(height: 36),

                    // Modern Timer / Resend Button Area
                    Obx(() {
                      final int seconds = controller.countdown.value;
                      if (seconds > 0) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Resend in ${seconds}s',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return TextButton.icon(
                          onPressed: controller.isLoading.value ? null : controller.resendCode,
                          icon: Icon(Icons.refresh_rounded, size: 16, color: colorScheme.primary),
                          label: Text(
                            'Resend Code',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),

            // Clean Bottom Loader (Positions gracefully above the software keyboard)
            Obx(() {
              if (!controller.isLoading.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorScheme.primary,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _OtpInputGrid extends StatelessWidget {
  final TelegramLoginController controller;

  const _OtpInputGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return SizedBox(
          width: 52,
          height: 58,
          child: TextField(
            controller: controller.otpControllers[index],
            focusNode: controller.otpFocusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            // Autofocuses the first field immediately on screen launch
            autofocus: index == 0,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            cursorColor: colorScheme.primary,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.04),
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 4) {
                  FocusScope.of(context).requestFocus(controller.otpFocusNodes[index + 1]);
                } else {
                  controller.otpFocusNodes[index].unfocus();
                  _evaluateAndSubmit();
                }
              } else {
                if (index > 0) {
                  FocusScope.of(context).requestFocus(controller.otpFocusNodes[index - 1]);
                }
              }
            },
          ),
        );
      }),
    );
  }

  void _evaluateAndSubmit() {
    final String completeCode = controller.otpControllers.map((c) => c.text).join();
    if (completeCode.length == 5) {
      controller.verifyOtp(completeCode);
    }
  }
}