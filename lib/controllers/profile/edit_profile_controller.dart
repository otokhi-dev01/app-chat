import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController {
  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  final TextEditingController nameController =
  TextEditingController(
    text: 'User Name',
  );

  final TextEditingController firstNameController =
  TextEditingController(
    text: 'User',
  );

  final TextEditingController lastNameController =
  TextEditingController(
    text: 'Name',
  );

  final TextEditingController bioController =
  TextEditingController(
    text: 'Available',
  );

  final TextEditingController phoneController =
  TextEditingController(
    text: '+855 12 345 678',
  );

  final TextEditingController usernameController =
  TextEditingController(
    text: 'username',
  );

  final RxBool isSaving = false.obs;

  final RxString profileImagePath = ''.obs;

  void setProfileImage(
      String value,
      ) {
    profileImagePath.value =
        value.trim();
  }

  void removeProfileImage() {
    profileImagePath.value = '';
  }

  String? validateRequired(
      String? value,
      ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'field_required'.tr;
    }

    return null;
  }

  String? validateUsername(
      String? value,
      ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'username_required'.tr;
    }

    String username = value
        .trim()
        .replaceFirst(
      '@',
      '',
    );

    if (username.length < 3) {
      return 'username_too_short'.tr;
    }

    RegExp usernamePattern = RegExp(
      r'^[a-zA-Z0-9_]+$',
    );

    if (!usernamePattern.hasMatch(
      username,
    )) {
      return 'invalid_username'.tr;
    }

    return null;
  }

  String? validatePhone(
      String? value,
      ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'phone_required'.tr;
    }

    String phone = value.replaceAll(
      RegExp(r'[\s\-\(\)]'),
      '',
    );

    if (phone.length < 8) {
      return 'invalid_phone_number'.tr;
    }

    return null;
  }

  Future<void> saveProfile() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    if (isSaving.value) {
      return;
    }

    bool isValid =
        formKey.currentState?.validate() ??
            false;

    if (!isValid) {
      return;
    }

    try {
      isSaving.value = true;

      Map<String, dynamic> profileData = {
        'name':
        nameController.text.trim(),
        'firstName':
        firstNameController.text.trim(),
        'lastName':
        lastNameController.text.trim(),
        'bio':
        bioController.text.trim(),
        'phone':
        phoneController.text.trim(),
        'username': usernameController
            .text
            .trim()
            .replaceFirst(
          '@',
          '',
        ),
        'profileImagePath':
        profileImagePath.value.trim(),
      };

      debugPrint(
        'Saving profile: $profileData',
      );

      // Replace this delay with your API request.
      await Future.delayed(
        Duration(
          milliseconds: 800,
        ),
      );

      // Example:
      // await profileService.updateProfile(
      //   profileData,
      // );
    } catch (error) {
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    usernameController.dispose();

    super.onClose();
  }
}