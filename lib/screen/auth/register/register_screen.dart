import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/auth/auth_controller.dart';
import '../auth_text_field.dart';
import '../telegram_login_controller.dart';
import 'register_app_bar.dart';
import 'register_phone_input_row.dart';

/// UPDATED: Clean RegisterScreen importing RegisterPhoneInputRow and RegisterAppBar
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  TelegramLoginController get _phoneCtrl =>
      Get.isRegistered<TelegramLoginController>()
          ? Get.find<TelegramLoginController>()
          : Get.put(TelegramLoginController());

  SystemUiOverlayStyle _overlayStyle(ThemeData theme, bool isDark) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    final Color fieldColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final double topSpace = MediaQuery.of(context).padding.top + 68;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle(theme, isDark),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: const RegisterAppBar(),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24, topSpace, 24, 30),
            child: AutofillGroup(
              child: Form(
                key: controller.registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'enter_information_to_get_started'.tr,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- Full Name ---
                    AuthTextField(
                      controller: controller.registerNameController,
                      focusNode: controller.registerNameFocusNode,
                      label: 'full_name'.tr,
                      icon: CupertinoIcons.person,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      validator: controller.validateName,
                      onFieldSubmitted: (_) {
                        controller.registerEmailFocusNode.requestFocus();
                      },
                    ),
                    const SizedBox(height: 18),

                    // --- Email ---
                    AuthTextField(
                      controller: controller.registerEmailController,
                      focusNode: controller.registerEmailFocusNode,
                      label: 'email'.tr,
                      icon: CupertinoIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: controller.validateEmail,
                      onFieldSubmitted: (_) {
                        controller.registerPhoneFocusNode.requestFocus();
                      },
                    ),
                    const SizedBox(height: 18),

                    // REPLACED: Phone input with country flag picker extracted into RegisterPhoneInputRow
                    RegisterPhoneInputRow(
                      controller: controller,
                      phoneCtrl: _phoneCtrl,
                      fieldColor: fieldColor,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 18),

                    // --- Password ---
                    Obx(() {
                      bool obscure = controller.obscureRegisterPassword.value;
                      return AuthTextField(
                        controller: controller.registerPasswordController,
                        focusNode: controller.registerPasswordFocusNode,
                        label: 'password'.tr,
                        icon: CupertinoIcons.lock,
                        obscureText: obscure,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: controller.validatePassword,
                        onFieldSubmitted: (_) {
                          controller.registerConfirmPasswordFocusNode
                              .requestFocus();
                        },
                        suffixIcon: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                          onPressed: controller.toggleRegisterPassword,
                          child: Icon(
                            obscure
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 18),

                    // --- Confirm Password ---
                    Obx(() {
                      bool obscure = controller.obscureConfirmPassword.value;
                      return AuthTextField(
                        controller:
                        controller.registerConfirmPasswordController,
                        focusNode: controller.registerConfirmPasswordFocusNode,
                        label: 'confirm_password'.tr,
                        icon: CupertinoIcons.lock_shield,
                        obscureText: obscure,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: controller.validateConfirmPassword,
                        onFieldSubmitted: (_) {
                          controller.register();
                        },
                        suffixIcon: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                          onPressed: controller.toggleConfirmPassword,
                          child: Icon(
                            obscure
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    // --- Register Button ---
                    Obx(() {
                      bool isLoading = controller.isRegisterLoading.value;
                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: isLoading ? null : controller.register,
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            disabledBackgroundColor:
                            colorScheme.primary.withValues(alpha: 0.48),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: isLoading
                                ? Row(
                              key: const ValueKey('register-loading'),
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
                                const SizedBox(width: 10),
                                Text(
                                  'creating_account'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                                : Text(
                              'create_account'.tr,
                              key: const ValueKey('register-button'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 14),

                    // --- Already have account ---
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'already_have_account'.tr,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.back();
                          },
                          child: Text(
                            'login'.tr,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}