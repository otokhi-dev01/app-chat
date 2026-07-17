import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart'; // Make sure to import your home screen file

class ProfileSetupController extends GetxController {
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final RxBool isLoading = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);

  // Mock method for selecting a profile picture
  Future<void> pickImage() async {
    // In a real app, integrate 'image_picker' package:
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   profileImage.value = File(pickedFile.path);
    // }

    Get.rawSnackbar(
      message: 'Image picking is mocked. Integrate image_picker package here.',
      backgroundColor: Colors.white24,
    );
  }

  Future<void> completeRegistration() async {
    if (!profileFormKey.currentState!.validate()) return;

    isLoading.value = true;

    // Simulate API registration call (saving first name, last name, photo)
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // Registration completed. Route to Dashboard and clear the route history.
    Get.offAll(() => const HomeScreen());
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}