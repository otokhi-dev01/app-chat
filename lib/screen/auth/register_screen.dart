import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../widgets/auth/auth_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({
    super.key,
  });

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'create_account'.tr,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              24,
              18,
              24,
              30,
            ),
            child: AutofillGroup(
              child: Form(
                key: controller.registerFormKey,
                child: Column(
                  children: [
                    Text(
                      'enter_information_to_get_started'.tr,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 32),

                    AuthTextField(
                      controller: controller.registerNameController,
                      focusNode: controller.registerNameFocusNode,
                      label: 'full_name'.tr,
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofillHints: [
                        AutofillHints.name,
                      ],
                      validator: controller.validateName,
                      onFieldSubmitted: (_) {
                        controller.registerEmailFocusNode.requestFocus();
                      },
                    ),

                    SizedBox(height: 18),

                    AuthTextField(
                      controller: controller.registerEmailController,
                      focusNode: controller.registerEmailFocusNode,
                      label: 'email'.tr,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: [
                        AutofillHints.email,
                      ],
                      validator: controller.validateEmail,
                      onFieldSubmitted: (_) {
                        controller.registerPasswordFocusNode.requestFocus();
                      },
                    ),

                    SizedBox(height: 18),

                    Obx(() {
                      return AuthTextField(
                        controller: controller.registerPasswordController,
                        focusNode: controller.registerPasswordFocusNode,
                        label: 'password'.tr,
                        icon: Icons.lock_outline_rounded,
                        obscureText:
                        controller.obscureRegisterPassword.value,
                        textInputAction: TextInputAction.next,
                        autofillHints: [
                          AutofillHints.newPassword,
                        ],
                        validator: controller.validatePassword,
                        onFieldSubmitted: (_) {
                          controller.registerConfirmPasswordFocusNode
                              .requestFocus();
                        },
                        suffixIcon: IconButton(
                          tooltip:
                          controller.obscureRegisterPassword.value
                              ? 'show_password'.tr
                              : 'hide_password'.tr,
                          onPressed: controller.toggleRegisterPassword,
                          icon: Icon(
                            controller.obscureRegisterPassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 18),

                    Obx(() {
                      return AuthTextField(
                        controller:
                        controller.registerConfirmPasswordController,
                        focusNode:
                        controller.registerConfirmPasswordFocusNode,
                        label: 'confirm_password'.tr,
                        icon: Icons.lock_reset_rounded,
                        obscureText:
                        controller.obscureConfirmPassword.value,
                        textInputAction: TextInputAction.done,
                        autofillHints: [
                          AutofillHints.newPassword,
                        ],
                        validator: controller.validateConfirmPassword,
                        onFieldSubmitted: (_) {
                          controller.register();
                        },
                        suffixIcon: IconButton(
                          tooltip:
                          controller.obscureConfirmPassword.value
                              ? 'show_password'.tr
                              : 'hide_password'.tr,
                          onPressed: controller.toggleConfirmPassword,
                          icon: Icon(
                            controller.obscureConfirmPassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 24),

                    Obx(() {
                      bool isLoading =
                          controller.isRegisterLoading.value;

                      return SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: FilledButton(
                          onPressed:
                          isLoading ? null : controller.register,
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            disabledBackgroundColor:
                            colorScheme.primary.withValues(
                              alpha: 0.48,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            child: isLoading
                                ? Row(
                              key: ValueKey(
                                'register-loading',
                              ),
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 21,
                                  height: 21,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'create_account'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                                : Text(
                              'create_account'.tr,
                              key: ValueKey(
                                'register-button',
                              ),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 14),

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
                            FocusManager.instance.primaryFocus
                                ?.unfocus();
                            Get.back();
                          },
                          child: Text(
                            'login'.tr,
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
          ),
        ),
      ),
    );
  }
}