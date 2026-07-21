import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(
    text: 'User Name',
  );

  final usernameController = TextEditingController(
    text: 'username',
  );

  final phoneController = TextEditingController(
    text: '+855 12 345 678',
  );

  final emailController = TextEditingController(
    text: 'user@gmail.com',
  );

  final bioController = TextEditingController(
    text: 'Available',
  );

  final isSaving = false.obs;
  final RxString profileImagePath = ''.obs;

  void setProfileImage(String value) {
    profileImagePath.value = value.trim();
  }

  void removeProfileImage() {
    profileImagePath.value = '';
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  Future<void> saveProfile() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isSaving.value = true;

    try {
      // Replace this delay with your API request.
      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      Get.back(
        result: {
          'name': nameController.text.trim(),
          'username': usernameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'bio': bioController.text.trim(),
        },
      );

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (_) {
      Get.snackbar(
        'Error',
        'Unable to update profile',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    bioController.dispose();

    super.onClose();
  }
}