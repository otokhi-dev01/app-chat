import 'package:appchat/services/user_service/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/model/login_response_model.dart';

class ProfileController extends GetxController {
  final UserApiService authApiService;

  ProfileController({
    required this.authApiService,
  });

  final RxString name = ''.obs;
  final RxString userPhone = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userUsername = ''.obs;
  final RxString userBio = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      LoginDataModel profile = await authApiService.getProfile();

      name.value = profile.fullName;
      userPhone.value = profile.phone;
      userEmail.value = profile.email;
      userUsername.value = profile.username.isEmpty ? '' : '@${profile.username.replaceFirst('@', '')}';
      userBio.value = profile.bio;
    } catch (e) {
      debugPrint('Failed to fetch profile: $e');

      Get.snackbar(
        'Unable to load profile',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateName(String value) {
    String newValue = value.trim();

    if (newValue.isEmpty || newValue == name.value) {
      return;
    }

    name.value = newValue;
  }

  void updatePhone(String value) {
    String newValue = value.trim();

    if (newValue.isEmpty || newValue == userPhone.value) {
      return;
    }

    userPhone.value = newValue;
  }

  void updateEmail(String value) {
    String newValue = value.trim();

    if (newValue.isEmpty || newValue == userEmail.value || !GetUtils.isEmail(newValue)) {
      return;
    }

    userEmail.value = newValue;
  }

  void updateUsername(String value) {
    String newValue = value.trim().replaceFirst('@', '');

    if (newValue.isEmpty) {
      return;
    }

    String normalizedUsername = '@$newValue';

    if (normalizedUsername == userUsername.value) {
      return;
    }

    userUsername.value = normalizedUsername;
  }

  void updateBio(String value) {
    String newValue = value.trim();

    if (newValue == userBio.value) {
      return;
    }

    userBio.value = newValue;
  }
}