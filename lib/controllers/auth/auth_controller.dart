import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/mock_auth_user.dart';
import '../../route/app_route.dart';
import '../../screen/widgets/app_feedback.dart';
import '../../services/auth_service /auth_service.dart';
import '../../services/mock/mock_auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService;

  AuthController({
    AuthService? authService,
  }) : authService =
      authService ?? MockAuthService();

  final GlobalKey<FormState> loginFormKey =
  GlobalKey<FormState>();

  final GlobalKey<FormState> registerFormKey =
  GlobalKey<FormState>();

  final TextEditingController
  loginEmailController =
  TextEditingController();

  final TextEditingController
  loginPasswordController =
  TextEditingController();

  final TextEditingController
  registerNameController =
  TextEditingController();

  final TextEditingController
  registerEmailController =
  TextEditingController();

  final TextEditingController
  registerPasswordController =
  TextEditingController();

  final TextEditingController
  registerConfirmPasswordController =
  TextEditingController();

  final FocusNode loginEmailFocusNode =
  FocusNode();

  final FocusNode loginPasswordFocusNode =
  FocusNode();

  final FocusNode registerNameFocusNode =
  FocusNode();

  final FocusNode registerEmailFocusNode =
  FocusNode();

  final FocusNode registerPasswordFocusNode =
  FocusNode();

  final FocusNode
  registerConfirmPasswordFocusNode =
  FocusNode();

  final RxBool isLoginLoading =
      false.obs;

  final RxBool isRegisterLoading =
      false.obs;

  final RxBool obscureLoginPassword =
      true.obs;

  final RxBool obscureRegisterPassword =
      true.obs;

  final RxBool obscureConfirmPassword =
      true.obs;

  final Rxn<MockAuthUser> currentUser =
  Rxn<MockAuthUser>();

  RxList<MockAuthUser> get users =>
      authService.users;

  String? validateName(String? value) {
    String name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Enter your name';
    }

    if (name.length < 2) {
      return 'Name must contain at least 2 characters';
    }

    return null;
  }

  String? validateEmail(String? value) {
    String email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Enter your email';
    }

    if (!GetUtils.isEmail(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    String password = value ?? '';

    if (password.isEmpty) {
      return 'Enter your password';
    }

    if (password.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  String? validateConfirmPassword(
      String? value,
      ) {
    String confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Confirm your password';
    }

    if (confirmPassword !=
        registerPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void toggleLoginPassword() {
    HapticFeedback.selectionClick();
    obscureLoginPassword.toggle();
  }

  void toggleRegisterPassword() {
    HapticFeedback.selectionClick();
    obscureRegisterPassword.toggle();
  }

  void toggleConfirmPassword() {
    HapticFeedback.selectionClick();
    obscureConfirmPassword.toggle();
  }

  Future<void> login() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    if (isLoginLoading.value) {
      return;
    }

    bool isValid =
        loginFormKey.currentState?.validate() ??
            false;

    if (!isValid) {
      AppFeedback.showMessage(
        title: 'Invalid Information',
        message:
        'Please check your email and password.',
        icon: Icons.info_outline_rounded,
      );

      return;
    }

    isLoginLoading.value = true;

    try {
      MockAuthUser matchedUser =
      await authService.login(
        email: loginEmailController.text,
        password:
        loginPasswordController.text,
      );

      currentUser.value = matchedUser;

      TextInput.finishAutofillContext();

      AppFeedback.showMessage(
        title: 'Login Successful',
        message:
        'Welcome back, ${matchedUser.name}.',
        icon:
        Icons.check_circle_outline_rounded,
      );

      isLoginLoading.value = false;

      await Future<void>.delayed(
        Duration(milliseconds: 300),
      );

      Get.offAllNamed(
        AppRoutes.home,
      );
    } on AuthServiceException catch (error) {
      AppFeedback.showMessage(
        title: 'Login Failed',
        message: error.message,
        icon: Icons.error_outline_rounded,
      );
    } catch (error) {
      AppFeedback.showMessage(
        title: 'Login Failed',
        message:
        'Something went wrong. Please try again.',
        icon: Icons.error_outline_rounded,
      );

      debugPrint(
        'Login error: $error',
      );
    } finally {
      if (!isClosed) {
        isLoginLoading.value = false;
      }
    }
  }

  Future<void> register() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    if (isRegisterLoading.value) {
      return;
    }

    bool isValid =
        registerFormKey.currentState
            ?.validate() ??
            false;

    if (!isValid) {
      AppFeedback.showMessage(
        title: 'Invalid Information',
        message:
        'Please check the registration form.',
        icon: Icons.info_outline_rounded,
      );

      return;
    }

    isRegisterLoading.value = true;

    try {
      String email =
      registerEmailController.text
          .trim()
          .toLowerCase();

      await authService.register(
        name:
        registerNameController.text,
        email: email,
        password:
        registerPasswordController.text,
      );

      loginEmailController.text = email;
      loginPasswordController.clear();

      clearRegisterForm();

      isRegisterLoading.value = false;

      Get.back();

      AppFeedback.showMessage(
        title: 'Account Created',
        message:
        'You can now log in with your new account.',
        icon:
        Icons.check_circle_outline_rounded,
      );
    } on AuthServiceException catch (error) {
      AppFeedback.showMessage(
        title: 'Registration Failed',
        message: error.message,
        icon: Icons.error_outline_rounded,
      );
    } catch (error) {
      AppFeedback.showMessage(
        title: 'Registration Failed',
        message:
        'Something went wrong. Please try again.',
        icon: Icons.error_outline_rounded,
      );

      debugPrint(
        'Registration error: $error',
      );
    } finally {
      if (!isClosed) {
        isRegisterLoading.value = false;
      }
    }
  }

  Future<void> logout() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    try {
      await authService.logout();
    } catch (error) {
      debugPrint(
        'Logout error: $error',
      );
    }

    currentUser.value = null;
    loginPasswordController.clear();

    Get.offAllNamed(
      AppRoutes.login,
    );

    AppFeedback.showMessage(
      title: 'Logged Out',
      message:
      'You have logged out successfully.',
      icon: Icons.logout_rounded,
    );
  }

  void clearRegisterForm() {
    registerNameController.clear();
    registerEmailController.clear();
    registerPasswordController.clear();
    registerConfirmPasswordController
        .clear();

    obscureRegisterPassword.value = true;
    obscureConfirmPassword.value = true;

    registerFormKey.currentState?.reset();
  }

  void clearLoginForm() {
    loginEmailController.clear();
    loginPasswordController.clear();

    obscureLoginPassword.value = true;

    loginFormKey.currentState?.reset();
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();

    registerNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController
        .dispose();

    loginEmailFocusNode.dispose();
    loginPasswordFocusNode.dispose();

    registerNameFocusNode.dispose();
    registerEmailFocusNode.dispose();
    registerPasswordFocusNode.dispose();
    registerConfirmPasswordFocusNode
        .dispose();

    super.onClose();
  }
}