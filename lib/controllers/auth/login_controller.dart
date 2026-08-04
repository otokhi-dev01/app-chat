import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../services/storage_service.dart';

class LoginController extends GetxController {
  final AuthRepository repository;
  final StorageService storageService;

  LoginController({
    required this.repository,
    required this.storageService,
  });

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final phone = phoneController.text.trim();
    final password = passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar('Login', 'Phone and password are required.');
      return;
    }

    try {
      isLoading.value = true;

      final response = await repository.login(
        phone: phone,
        password: password,
      );

      if (response.code == 200 && response.data != null) {
        await storageService.saveLoginData(
          token: response.data!.token,
          userId: response.data!.userId,
        );

        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Login failed', response.message);
      }
    } catch (error) {
      Get.snackbar(
        'Login failed',
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}