import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppFeedback {
  AppFeedback._();

  static void showMessage({
    required String title,
    required String message,
    required IconData icon,
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 16,
      icon: Icon(
        icon,
      ),
      duration: Duration(
        seconds: 3,
      ),
      isDismissible: true,
      dismissDirection:
      DismissDirection.vertical,
    );
  }
}