import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../widgets/auth/auth_text_field.dart';
import 'auth_layout.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return AuthLayout(
      child: AutofillGroup(
        child: Form(
          key: controller.loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'welcome_back'.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 8,
              ),

              Text(
                'login_continue_chatting'.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(
                height: 38,
              ),

              AuthTextField(
                controller: controller.loginEmailController,
                focusNode: controller.loginEmailFocusNode,
                label: 'email'.tr,
                icon: CupertinoIcons.mail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: <String>[
                  AutofillHints.email,
                  AutofillHints.username,
                ],
                validator: controller.validateEmail,
                onFieldSubmitted: (
                    String value,
                    ) {
                  controller.loginPasswordFocusNode.requestFocus();
                },
              ),

              SizedBox(
                height: 18,
              ),

              Obx(
                    () {
                  bool obscurePassword = controller.obscureLoginPassword.value;

                  return AuthTextField(
                    controller: controller.loginPasswordController,
                    focusNode: controller.loginPasswordFocusNode,
                    label: 'password'.tr,
                    icon: CupertinoIcons.lock,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    autofillHints: <String>[
                      AutofillHints.password,
                    ],
                    validator: controller.validatePassword,
                    onFieldSubmitted: (
                        String value,
                        ) {
                      controller.login();
                    },
                    suffixIcon: CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(32, 32),
                      onPressed: controller.toggleLoginPassword,
                      child: Icon(
                        obscurePassword
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    Get.to(
                          () => ForgotPasswordScreen(),
                      transition: Transition.rightToLeft,
                      duration: Duration(
                        milliseconds: 280,
                      ),
                    );
                  },
                  child: Text(
                    'forgot_password'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              Obx(
                    () {
                  bool isLoading = controller.isLoginLoading.value;

                  return SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: isLoading ? null : controller.login,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        disabledBackgroundColor: colorScheme.primary.withValues(
                          alpha: 0.48,
                        ),
                        disabledForegroundColor: colorScheme.onPrimary.withValues(
                          alpha: 0.75,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(
                          milliseconds: 200,
                        ),
                        child: isLoading
                            ? Row(
                          key: ValueKey<String>(
                            'login-loading',
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'logging_in'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                            : Text(
                          'login'.tr,
                          key: ValueKey<String>(
                            'login-button',
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(
                height: 20,
              ),

              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center, // Fixed parameter name
                children: [
                  Text(
                    'dont_have_account'.tr,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      Get.to(
                            () => RegisterScreen(),
                        transition: Transition.rightToLeft,
                        duration: Duration(
                          milliseconds: 280,
                        ),
                      );
                    },
                    child: Text(
                      'create_account'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}