import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../widgets/auth/auth_text_field.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({
    super.key,
  });

  final AuthController controller = Get.find<AuthController>();

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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    Color actionBackground = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return AppBar(
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      leadingWidth: 58,
      titleSpacing: 0,
      systemOverlayStyle: _overlayStyle(theme, isDark),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: appBarColor,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.fromLTRB(12, 10, 6, 10),
        child: Tooltip(
          message: 'back'.tr,
          child: Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: actionBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.15 : 0.04,
                  ),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size(40, 40),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              },
              child: Icon(
                CupertinoIcons.chevron_left,
                size: 20,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'create_account'.tr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle(theme, isDark),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
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
                        icon: CupertinoIcons.person,
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
                        icon: CupertinoIcons.mail,
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
                        bool obscure = controller.obscureRegisterPassword.value;

                        return AuthTextField(
                          controller: controller.registerPasswordController,
                          focusNode: controller.registerPasswordFocusNode,
                          label: 'password'.tr,
                          icon: CupertinoIcons.lock,
                          obscureText: obscure,
                          textInputAction: TextInputAction.next,
                          autofillHints: [
                            AutofillHints.newPassword,
                          ],
                          validator: controller.validatePassword,
                          onFieldSubmitted: (_) {
                            controller.registerConfirmPasswordFocusNode
                                .requestFocus();
                          },
                          suffixIcon: CupertinoButton(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(32, 32),
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
                      SizedBox(height: 18),
                      Obx(() {
                        bool obscure = controller.obscureConfirmPassword.value;

                        return AuthTextField(
                          controller:
                          controller.registerConfirmPasswordController,
                          focusNode:
                          controller.registerConfirmPasswordFocusNode,
                          label: 'confirm_password'.tr,
                          icon: CupertinoIcons.lock_shield,
                          obscureText: obscure,
                          textInputAction: TextInputAction.done,
                          autofillHints: [
                            AutofillHints.newPassword,
                          ],
                          validator: controller.validateConfirmPassword,
                          onFieldSubmitted: (_) {
                            controller.register();
                          },
                          suffixIcon: CupertinoButton(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(32, 32),
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
                      SizedBox(height: 24),
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
                              colorScheme.primary.withValues(
                                alpha: 0.48,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
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
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'creating_account'.tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
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
                                  fontSize: 16,
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
                              FocusManager.instance.primaryFocus?.unfocus();
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
      ),
    );
  }
}