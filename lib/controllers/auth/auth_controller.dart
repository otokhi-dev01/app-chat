import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../screen/widgets/common/app_feedback.dart';

class MockAuthUser {
  final String id;
  final String name;
  final String email;
  final String password;

  MockAuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthController extends GetxController {
  final GlobalKey<FormState> loginFormKey =
  GlobalKey<FormState>();

  final GlobalKey<FormState> registerFormKey =
  GlobalKey<FormState>();

  final TextEditingController loginEmailController =
  TextEditingController();

  final TextEditingController loginPasswordController =
  TextEditingController();

  final TextEditingController registerNameController =
  TextEditingController();

  final TextEditingController registerEmailController =
  TextEditingController();

  final TextEditingController registerPasswordController =
  TextEditingController();

  final TextEditingController
  registerConfirmPasswordController =
  TextEditingController();

  final FocusNode loginEmailFocusNode = FocusNode();
  final FocusNode loginPasswordFocusNode = FocusNode();

  final FocusNode registerNameFocusNode = FocusNode();
  final FocusNode registerEmailFocusNode = FocusNode();
  final FocusNode registerPasswordFocusNode =
  FocusNode();

  final FocusNode registerConfirmPasswordFocusNode =
  FocusNode();

  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;

  final RxBool obscureLoginPassword = true.obs;
  final RxBool obscureRegisterPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  final Rxn<MockAuthUser> currentUser =
  Rxn<MockAuthUser>();

  final RxList<MockAuthUser> users =
      <MockAuthUser>[
        MockAuthUser(
          id: '1',
          name: 'Alex Morgan',
          email: 'otokhichat@gmail.com',
          password: 'ch757595',
        ),
        MockAuthUser(
          id: '2',
          name: 'Demo User',
          email: 'demo@appchat.com',
          password: '123456',
        ),
      ].obs;

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
    FocusManager.instance.primaryFocus?.unfocus();

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
      await Future<void>.delayed(
        Duration(milliseconds: 900),
      );

      String email = loginEmailController.text
          .trim()
          .toLowerCase();

      String password =
          loginPasswordController.text;

      MockAuthUser? matchedUser;

      for (MockAuthUser user in users) {
        bool emailMatches =
            user.email.toLowerCase() == email;

        bool passwordMatches =
            user.password == password;

        if (emailMatches &&
            passwordMatches) {
          matchedUser = user;
          break;
        }
      }

      if (matchedUser == null) {
        AppFeedback.showMessage(
          title: 'Login Failed',
          message:
          'The email or password is incorrect.',
          icon: Icons.error_outline_rounded,
        );

        return;
      }

      currentUser.value = matchedUser;

      TextInput.finishAutofillContext();

      AppFeedback.showMessage(
        title: 'Login Successful',
        message:
        'Welcome back, ${matchedUser.name}.',
        icon: Icons
            .check_circle_outline_rounded,
      );

      isLoginLoading.value = false;

      await Future<void>.delayed(
        Duration(milliseconds: 300),
      );

      Get.offAllNamed(
        AppRoutes.home,
      );
    } catch (error) {
      AppFeedback.showMessage(
        title: 'Login Failed',
        message:
        'Something went wrong. Please try again.',
        icon: Icons.error_outline_rounded,
      );
    } finally {
      if (!isClosed) {
        isLoginLoading.value = false;
      }
    }
  }

  Future<void> register() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (isRegisterLoading.value) {
      return;
    }

    bool isValid =
        registerFormKey.currentState?.validate() ??
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
      await Future<void>.delayed(
        Duration(milliseconds: 900),
      );

      String name =
      registerNameController.text.trim();

      String email = registerEmailController.text
          .trim()
          .toLowerCase();

      String password =
          registerPasswordController.text;

      bool emailAlreadyExists = users.any(
            (MockAuthUser user) {
          return user.email.toLowerCase() ==
              email;
        },
      );

      if (emailAlreadyExists) {
        AppFeedback.showMessage(
          title: 'Registration Failed',
          message:
          'This email is already registered.',
          icon: Icons.error_outline_rounded,
        );

        return;
      }

      MockAuthUser newUser = MockAuthUser(
        id: DateTime.now()
            .microsecondsSinceEpoch
            .toString(),
        name: name,
        email: email,
        password: password,
      );

      users.add(newUser);

      loginEmailController.text = email;
      loginPasswordController.clear();

      clearRegisterForm();

      isRegisterLoading.value = false;

      Get.back();

      AppFeedback.showMessage(
        title: 'Account Created',
        message:
        'You can now log in with your new account.',
        icon: Icons
            .check_circle_outline_rounded,
      );
    } catch (error) {
      AppFeedback.showMessage(
        title: 'Registration Failed',
        message:
        'Something went wrong. Please try again.',
        icon: Icons.error_outline_rounded,
      );
    } finally {
      if (!isClosed) {
        isRegisterLoading.value = false;
      }
    }
  }

  void logout() {
    FocusManager.instance.primaryFocus?.unfocus();

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
    registerConfirmPasswordController.clear();

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