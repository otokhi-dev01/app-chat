import 'package:appchat/services/user_service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../data/model/login_response_model.dart';


class ProfileEditController extends GetxController {
  final UserApiService authApiService;

  // 1. Hold the initial user data to pre-fill fields and get the ID
  final LoginDataModel? currentUser = Get.find<UserApiService>().currentUserValue;

  ProfileEditController({required this.authApiService});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Controllers
  late TextEditingController nameController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController bioController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;
  late TextEditingController emailController;

  final RxBool isSaving = false.obs;
  final RxString profileImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 2. Pre-fill controllers using the LoginDataModel
    // Logic for splitting name if necessary, or just using the fields
    nameController = TextEditingController(text: currentUser?.name ?? '');

    // Splitting name into first/last for the UI controllers if they are separate
    List<String> nameParts = (currentUser?.name ?? '').split(' ');
    firstNameController = TextEditingController(text: nameParts.isNotEmpty ? nameParts[0] : '');
    lastNameController = TextEditingController(text: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');

    bioController = TextEditingController(text: currentUser?.bio ?? '');
    phoneController = TextEditingController(text: currentUser?.phoneNumber ?? '');
    usernameController = TextEditingController(text: currentUser?.username ?? '');
    emailController = TextEditingController(text: currentUser?.email ?? '');

    // Set initial avatar URL
    profileImagePath.value = currentUser?.avatarUrl ?? '';
  }

  void setProfileImage(String value) {
    profileImagePath.value = value.trim();
  }

  void removeProfileImage() {
    profileImagePath.value = '';
  }

  // --- Validators (Matching your LoginDataModel requirements) ---
  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return 'field_required'.tr;
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return 'username_required'.tr;
    String username = value.trim().replaceFirst('@', '');
    if (username.length < 3) return 'username_too_short'.tr;
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'phone_required'.tr;
    // Basic check for phone length based on your model
    if (value.length < 8) return 'invalid_phone_number'.tr;
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null; // email is optional
    if (!GetUtils.isEmail(value.trim())) return 'invalid_email'.tr;
    return null;
  }

  // --- API Action ---
  Future<void> saveProfile() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (isSaving.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isSaving.value = true;

      // 3. Map keys to match LoginDataModel and Laravel expectations
      Map<String, dynamic> profileData = {
        'name': nameController.text.trim(),
        'username': usernameController.text.trim().replaceFirst('@', ''),
        'phoneNumber': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'bio': bioController.text.trim(),
        'avatarUrl': profileImagePath.value.trim(),
        // Add first/last name if your backend expects them separately
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
      };

      // 4. Call API using the user's ID (Patch users/{user})
      await authApiService.updateProfile(
        userId: currentUser?.id ?? '',
        data: profileData,
      );

      // 5. Refresh ProfileController so profile screen & account section update
      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().fetchProfile();
      }

      Get.back();
      Get.snackbar(
        'success'.tr,
        'profile_updated_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      Get.snackbar(
        'error'.tr,
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
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
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}