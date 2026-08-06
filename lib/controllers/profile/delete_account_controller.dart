import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../route/app_route.dart';
import '../../screen/widgets/common/app_feedback.dart';
import '../../services/auth_service.dart';

class DeleteAccountController extends GetxController {
  final AuthService authService;

  DeleteAccountController({
    required this.authService,
  });

  final RxBool isDeleting = false.obs;

  Future<void> deleteAccount() async {
    if (isDeleting.value) {
      return;
    }

    try {
      isDeleting.value = true;

      await authService.deleteAccount();

      // Navigate to login screen, clearing the stack
      Get.offAllNamed(
        AppRoutes.login,
      );

      // Display feedback toast
      AppFeedback.showMessage(
        title: 'account_deleted'.tr,
        message: 'account_deleted_permanently_message'.tr,
        icon: CupertinoIcons.checkmark_circle,
      );
    } on AuthServiceException catch (error) {
      _showDeleteError(
        error.message,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Delete account error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _showDeleteError(
        'unable_to_delete_account_try_again'.tr,
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