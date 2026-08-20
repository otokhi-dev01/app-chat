import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/mock_auth_user.dart';
import '../../data/model/login_response_model.dart';
import '../../route/app_route.dart';
import '../../screen/widgets/app_feedback.dart';
import '../../services/api_service.dart';
import '../../services/auth_service /auth_api_service.dart';
import '../../services/auth_service /auth_service.dart';
import '../../services/mock/mock_auth_service.dart';
import '../../services/user_service/user_service.dart';
import '../../screen/home/home_binding.dart';
import '../chat/chat_controller.dart';
import '../contact/contact_controller.dart';

class AuthController extends GetxController {
  // Kept temporarily for mock registration.
  final AuthService authService;

  // Real Laravel authentication service.
  final AuthApiService authApiService;

  AuthController({
    AuthService? authService,
    AuthApiService? authApiService,
  })  : authService =
      authService ?? MockAuthService(),
        authApiService = authApiService ??
            Get.find<AuthApiService>();

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
  registerPhoneController =
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

  final FocusNode registerPhoneFocusNode =
  FocusNode();

  final FocusNode registerPasswordFocusNode =
  FocusNode();

  final FocusNode
  registerConfirmPasswordFocusNode =
  FocusNode();

  // Country picker state for registration phone field
  final RxString registerCountryCode = '+1'.obs;
  final RxString registerCountryName = 'United States'.obs;

  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;

  final RxBool obscureLoginPassword =
      true.obs;

  final RxBool obscureRegisterPassword =
      true.obs;

  final RxBool obscureConfirmPassword =
      true.obs;

  // Holds the otpToken + email from step 1 of login until verifyLoginOtp()
  // either succeeds or a fresh login() call replaces it.
  // NOTE: OTP is currently disabled — kept for easy re-enable.
  // final Rxn<LoginOtpResponseModel> pendingOtpLogin = Rxn<LoginOtpResponseModel>();

  // Real user returned by Laravel.
  final Rxn<LoginDataModel> currentUser =
  Rxn<LoginDataModel>();

  // Mock users retained until registration is connected.
  RxList<MockAuthUser> get users =>
      authService.users;

  String? validateName(String? value) {
    final String name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Enter your name';
    }

    if (name.length < 2) {
      return 'Name must contain at least 2 characters';
    }

    return null;
  }

  String? validatePhone(String? value) {
    final String phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'Enter your phone number';
    if (phone.length < 6) return 'Enter a valid phone number';
    return null;
  }

  String? validateEmail(String? value) {
    final String email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Enter your email';
    }

    if (!GetUtils.isEmail(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    final String password = value ?? '';

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
    final String confirmPassword =
        value ?? '';

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

  /// Login: verifies credentials and goes directly to home.
  /// OTP is disabled — the API now issues the access token in one step.
  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (isLoginLoading.value) return;

    final bool isValid =
        loginFormKey.currentState?.validate() ?? false;

    if (!isValid) {
      AppFeedback.showMessage(
        title: 'Invalid Information',
        message: 'Please check your email and password.',
        icon: Icons.info_outline_rounded,
      );
      return;
    }

    isLoginLoading.value = true;

    try {
      final LoginResponseModel response = await authApiService.login(
        login: loginEmailController.text.trim().toLowerCase(),
        password: loginPasswordController.text,
      );

      final LoginDataModel? user = response.data;

      if (user == null) {
        throw const ApiException(
          statusCode: 500,
          message: 'User information was not returned.',
        );
      }

      currentUser.value = user;

      if (!isClosed) {
        unawaited(_finishPostLoginFlow());
      }
    } on ApiException catch (error) {
      AppFeedback.showMessage(
        title: 'Login Failed',
        message: error.message,
        icon: Icons.error_outline_rounded,
      );
    } catch (error, stackTrace) {
      AppFeedback.showMessage(
        title: 'Login Failed',
        message: 'Something went wrong. Please try again.',
        icon: Icons.error_outline_rounded,
      );
      debugPrint('Login error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (!isClosed) {
        isLoginLoading.value = false;
      }
    }
  }


  // ---------------------------------------------------------------------------
  // OTP methods — disabled. The API now issues the access token directly
  // on login. Keep these for easy re-enable when OTP is needed again.
  // ---------------------------------------------------------------------------

  // Future<void> verifyLoginOtp(String otp) async { ... }
  // Future<void> resendLoginOtp() async { ... }
  // void _handleLoginOtpVerified() { unawaited(_finishPostLoginFlow()); }

  Future<void> _finishPostLoginFlow() async {
    TextInput.finishAutofillContext();

    try {
      HomeBinding().dependencies();

      // Populate UserApiService.currentUserValue so the profile screen
      // and any other widget that reads it has real data immediately.
      if (Get.isRegistered<UserApiService>()) {
        try {
          await Get.find<UserApiService>().getProfile();
        } catch (e) {
          debugPrint('Profile prefetch error: $e');
        }
      }

      final chatCtrl = Get.find<ChatController>();
      final contactCtrl = Get.find<ContactController>();

      // Wait for controllers to finish their initial load
      while (chatCtrl.isLoading.value || contactCtrl.isLoading.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e) {
      debugPrint('Pre-fetch error: $e');
    }

    await Future<void>.delayed(
      const Duration(milliseconds: 300),
    );

    if (!isClosed) {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<void> register() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (isRegisterLoading.value) return;

    final bool isValid = registerFormKey.currentState?.validate() ?? false;

    if (!isValid) {
      AppFeedback.showMessage(
        title: 'Invalid Information',
        message: 'Please check the registration form.',
        icon: Icons.info_outline_rounded,
      );

      return;
    }

    isRegisterLoading.value = true;

    try {
      final String email = registerEmailController.text.trim().toLowerCase();
      final String localPhone = registerPhoneController.text.trim().replaceFirst(RegExp(r'^0+'), '');
      final String phoneNumber = '${registerCountryCode.value}$localPhone';

      await authApiService.register(
        name: registerNameController.text.trim(),
        phoneNumber: phoneNumber,
        email: email,
        password: registerPasswordController.text,
        passwordConfirmation: registerConfirmPasswordController.text,
      );

      loginEmailController.text = email;
      loginPasswordController.clear();

      clearRegisterForm();
      Get.back();

      AppFeedback.showMessage(
        title: 'Account Created',
        message: 'You can now log in with your new account.',
        icon: Icons.check_circle_outline_rounded,
      );
    } on ApiException catch (error) {
      AppFeedback.showMessage(
        title: 'Registration Failed',
        message: error.message,
        icon: Icons.error_outline_rounded,
      );
    } catch (error, stackTrace) {
      AppFeedback.showMessage(
        title: 'Registration Failed',
        message: 'Something went wrong. Please try again.',
        icon: Icons.error_outline_rounded,
      );

      debugPrint('Registration error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (!isClosed) isRegisterLoading.value = false;
    }
  }

  Future<void> logout() async {
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await authApiService.logout();
    } catch (error, stackTrace) {
      debugPrint('Logout error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      // Clear cached user if the service is registered.
      if (Get.isRegistered<UserApiService>()) {
        Get.find<UserApiService>()
            .clearCurrentUser();
      }

      currentUser.value = null;
      loginPasswordController.clear();

      Get.offAllNamed(
        AppRoutes.login,
      );

      AppFeedback.showMessage(
        title: 'Logged Out',
        message: 'You have logged out successfully.',
        icon: Icons.logout_rounded,
      );
    }
  }

  void clearRegisterForm() {
    registerNameController.clear();
    registerEmailController.clear();
    registerPhoneController.clear();
    registerPasswordController.clear();
    registerConfirmPasswordController.clear();

    registerCountryCode.value = '+1';
    registerCountryName.value = 'United States';

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
    registerPhoneController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();

    loginEmailFocusNode.dispose();
    loginPasswordFocusNode.dispose();

    registerNameFocusNode.dispose();
    registerEmailFocusNode.dispose();
    registerPhoneFocusNode.dispose();
    registerPasswordFocusNode.dispose();
    registerConfirmPasswordFocusNode.dispose();

    super.onClose();
  }
}