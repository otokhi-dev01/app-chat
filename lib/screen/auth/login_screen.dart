// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../controllers/auth/auth_controller.dart';
// import '../widgets/auth/auth_text_field.dart';
// import 'auth_layout.dart';
// import 'forgot_password_screen.dart';
// import 'register_screen.dart';
//
// class LoginScreen extends GetView<AuthController> {
//   const LoginScreen({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     ColorScheme colorScheme = theme.colorScheme;
//
//     return AuthLayout(
//       child: AutofillGroup(
//         child: Form(
//           key: controller.loginFormKey,
//           child: Column(
//             mainAxisAlignment:
//             MainAxisAlignment.center,
//             crossAxisAlignment:
//             CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 'welcome_back'.tr,
//                 textAlign: TextAlign.center,
//                 style: theme
//                     .textTheme.headlineMedium
//                     ?.copyWith(
//                   color: colorScheme.onSurface,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 8,
//               ),
//
//               Text(
//                 'login_continue_chatting'.tr,
//                 textAlign: TextAlign.center,
//                 style: theme.textTheme.bodyMedium
//                     ?.copyWith(
//                   color:
//                   colorScheme.onSurfaceVariant,
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 38,
//               ),
//
//               AuthTextField(
//                 controller:
//                 controller.loginEmailController,
//                 focusNode:
//                 controller.loginEmailFocusNode,
//                 label: 'email'.tr,
//                 icon: Icons.email_outlined,
//                 keyboardType:
//                 TextInputType.emailAddress,
//                 textInputAction:
//                 TextInputAction.next,
//                 autofillHints: const <String>[
//                   AutofillHints.email,
//                   AutofillHints.username,
//                 ],
//                 validator:
//                 controller.validateEmail,
//                 onFieldSubmitted: (
//                     String value,
//                     ) {
//                   controller
//                       .loginPasswordFocusNode
//                       .requestFocus();
//                 },
//               ),
//
//               const SizedBox(
//                 height: 18,
//               ),
//
//               Obx(
//                     () {
//                   bool obscurePassword =
//                       controller
//                           .obscureLoginPassword
//                           .value;
//
//                   return AuthTextField(
//                     controller: controller
//                         .loginPasswordController,
//                     focusNode: controller
//                         .loginPasswordFocusNode,
//                     label: 'password'.tr,
//                     icon:
//                     Icons.lock_outline_rounded,
//                     obscureText: obscurePassword,
//                     textInputAction:
//                     TextInputAction.done,
//                     autofillHints: const <String>[
//                       AutofillHints.password,
//                     ],
//                     validator:
//                     controller.validatePassword,
//                     onFieldSubmitted: (
//                         String value,
//                         ) {
//                       controller.login();
//                     },
//                     suffixIcon: IconButton(
//                       tooltip: obscurePassword
//                           ? 'show_password'.tr
//                           : 'hide_password'.tr,
//                       onPressed: controller
//                           .toggleLoginPassword,
//                       icon: Icon(
//                         obscurePassword
//                             ? Icons
//                             .visibility_outlined
//                             : Icons
//                             .visibility_off_outlined,
//                         color: colorScheme
//                             .onSurfaceVariant,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     FocusManager
//                         .instance.primaryFocus
//                         ?.unfocus();
//
//                     Get.to(
//                           () =>
//                           ForgotPasswordScreen(),
//                       transition:
//                       Transition.rightToLeft,
//                       duration: const Duration(
//                         milliseconds: 280,
//                       ),
//                     );
//                   },
//                   child: Text(
//                     'forgot_password'.tr,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//
//               Obx(
//                     () {
//                   bool isLoading =
//                       controller
//                           .isLoginLoading.value;
//
//                   return SizedBox(
//                     height: 55,
//                     child: FilledButton(
//                       onPressed: isLoading
//                           ? null
//                           : controller.login,
//                       style: FilledButton.styleFrom(
//                         backgroundColor:
//                         colorScheme.primary,
//                         foregroundColor:
//                         colorScheme.onPrimary,
//                         disabledBackgroundColor:
//                         colorScheme.primary
//                             .withValues(
//                           alpha: 0.48,
//                         ),
//                         disabledForegroundColor:
//                         colorScheme.onPrimary
//                             .withValues(
//                           alpha: 0.75,
//                         ),
//                         elevation: 0,
//                         shape:
//                         RoundedRectangleBorder(
//                           borderRadius:
//                           BorderRadius.circular(
//                             14,
//                           ),
//                         ),
//                       ),
//                       child: AnimatedSwitcher(
//                         duration: const Duration(
//                           milliseconds: 200,
//                         ),
//                         child: isLoading
//                             ? Row(
//                           key:
//                           const ValueKey<
//                               String>(
//                             'login-loading',
//                           ),
//                           mainAxisAlignment:
//                           MainAxisAlignment
//                               .center,
//                           children: [
//                             SizedBox(
//                               width: 21,
//                               height: 21,
//                               child:
//                               CircularProgressIndicator(
//                                 strokeWidth:
//                                 2.4,
//                                 color:
//                                 colorScheme
//                                     .onPrimary,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               'logging_in'.tr,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight:
//                                 FontWeight
//                                     .w600,
//                               ),
//                             ),
//                           ],
//                         )
//                             : Text(
//                           'login'.tr,
//                           key:
//                           const ValueKey<
//                               String>(
//                             'login-button',
//                           ),
//                           style: const TextStyle(
//                             fontSize: 17,
//                             fontWeight:
//                             FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//
//               const SizedBox(
//                 height: 20,
//               ),
//
//               Wrap(
//                 alignment: WrapAlignment.center,
//                 crossAxisAlignment:
//                 WrapCrossAlignment.center,
//                 children: [
//                   Text(
//                     'dont_have_account'.tr,
//                     style: TextStyle(
//                       color: colorScheme
//                           .onSurfaceVariant,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       FocusManager
//                           .instance.primaryFocus
//                           ?.unfocus();
//
//                       Get.to(
//                             () => RegisterScreen(),
//                         transition:
//                         Transition.rightToLeft,
//                         duration: const Duration(
//                           milliseconds: 280,
//                         ),
//                       );
//                     },
//                     child: Text(
//                       'create_account'.tr,
//                       style: const TextStyle(
//                         fontWeight:
//                         FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login with your phone number',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        hintText: '0968734812',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                          () => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => controller.login(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                          () => SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.login,
                          child: controller.isLoading.value
                              ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                              : const Text('Login'),
                        ),
                      ),
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