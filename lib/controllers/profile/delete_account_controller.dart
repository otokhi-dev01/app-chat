import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../route/app_route.dart';
import '../../screen/widgets/app_feedback.dart';
import '../../services/user_service/user_service.dart';

class DeleteAccountController extends GetxController {
  final UserApiService userApiService;

  DeleteAccountController({
    required this.userApiService,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final RxBool isDeleting = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'password_required'.tr;
    }
    if (value.trim().length < 8) {
      return 'password_min_length'.tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'confirm_password_required'.tr;
    }
    if (value.trim() != passwordController.text.trim()) {
      return 'passwords_do_not_match'.tr;
    }
    return null;
  }

  Future<void> deleteAccount() async {
    if (isDeleting.value) return;

    final bool isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final String password = passwordController.text.trim();
    final String? userId = userApiService.currentUserValue?.id;

    if (userId == null || userId.isEmpty) {
      _showDeleteError('unable_to_identify_user'.tr);
      return;
    }

    try {
      isDeleting.value = true;

      await userApiService.deleteAccount(
        userId: userId,
        password: password,
      );

      // Navigate to login, clearing the entire stack
      Get.offAllNamed(AppRoutes.login);

      AppFeedback.showMessage(
        title: 'account_deleted'.tr,
        message: 'account_deleted_permanently_message'.tr,
        icon: CupertinoIcons.checkmark_circle,
      );
    } catch (error, stackTrace) {
      debugPrint('Delete account error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showDeleteError(
        error
            .toString()
            .replaceFirst('Exception: ', '')
            .replaceFirst('Bad state: ', ''),
      );
    } finally {
      if (!isClosed) {
        isDeleting.value = false;
      }
    }
  }

  void _showDeleteError(String message) {
    AppFeedback.showMessage(
      title: 'unable_to_delete_account'.tr,
      message: message,
      icon: CupertinoIcons.exclamationmark_circle,
    );
  }
}