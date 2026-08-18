import 'package:appchat/screen/widgets/logout_button.dart';
import 'package:appchat/services/user_service/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/profile/edit_profile_controller.dart';
import '../../../controllers/settings/settings_controller.dart';
import '../../../services/picker_service/chat_camera_services.dart';
import 'full_profile_image_viewer.dart';
import 'profile_avatar_section.dart';

// REPLACED: Sub-widgets imported from extracted files
import 'profile_edit_app_bar.dart';
import 'profile_field.dart';
import 'profile_photo_sheet.dart';
import 'profile_section_title.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final ProfileEditController controller;

  @override
  void initState() {
    super.initState();
    // Delete any stale instance from a previous user, then create fresh one.
    if (Get.isRegistered<ProfileEditController>()) {
      Get.delete<ProfileEditController>(force: true);
    }
    controller = Get.put(
      ProfileEditController(authApiService: Get.find<UserApiService>()),
    );
  }

  SettingsController get settingsController => Get.find<SettingsController>();

  final ChatCameraService _cameraService = ChatCameraService();

  Future<void> _saveProfile() async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool isValid = controller.formKey.currentState?.validate() ?? false;

    if (!isValid) {
      _showMessage(
        title: 'invalid_profile_information'.tr,
        message: 'check_profile_information'.tr,
        icon: CupertinoIcons.exclamationmark_circle,
      );
      return;
    }

    try {
      await controller.saveProfile();

      _showMessage(
        title: 'profile_updated'.tr,
        message: 'profile_updated_successfully'.tr,
        icon: CupertinoIcons.checkmark_circle,
      );
    } catch (error) {
      _showMessage(
        title: 'unable_to_update_profile'.tr,
        message: _cleanErrorMessage(error),
        icon: CupertinoIcons.exclamationmark_circle,
      );
    }
  }

  Future<void> _takeProfilePhoto() async {
    try {
      dynamic result = await _cameraService.takePhoto();
      String? mediaPath = result?.mediaPath;

      if (mediaPath == null || mediaPath.trim().isEmpty) return;

      controller.setProfileImage(mediaPath);

      _showMessage(
        title: 'profile_photo_updated'.tr,
        message: 'new_profile_photo_selected'.tr,
        icon: CupertinoIcons.camera,
      );
    } catch (error) {
      _showMessage(
        title: 'unable_to_update_photo'.tr,
        message: _cleanErrorMessage(error),
        icon: CupertinoIcons.exclamationmark_circle,
      );
    }
  }

  Future<void> _chooseProfilePhoto() async {
    try {
      dynamic result = await _cameraService.pickFromGallery();
      String? mediaPath = result?.mediaPath;

      if (mediaPath == null || mediaPath.trim().isEmpty) return;

      controller.setProfileImage(mediaPath);

      _showMessage(
        title: 'profile_photo_updated'.tr,
        message: 'gallery_profile_photo_selected'.tr,
        icon: CupertinoIcons.photo,
      );
    } catch (error) {
      _showMessage(
        title: 'unable_to_update_photo'.tr,
        message: _cleanErrorMessage(error),
        icon: CupertinoIcons.exclamationmark_circle,
      );
    }
  }

  void _removeProfilePhoto() {
    String currentPath = controller.profileImagePath.value.trim();
    if (currentPath.isEmpty) return;

    controller.removeProfileImage();

    _showMessage(
      title: 'profile_photo_removed'.tr,
      message: 'profile_photo_removed_successfully'.tr,
      icon: CupertinoIcons.trash,
    );
  }

  void _showMessage({
    required String title,
    required String message,
    required IconData icon,
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      icon: Icon(icon),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  String _cleanErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst('Bad state: ', '')
        .replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    // FIXED: Calculate top space so list clears the translucent glass AppBar
    final double topSpace = MediaQuery.of(context).padding.top + 68;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      // REPLACED: Extracted glassmorphic ProfileEditAppBar
      appBar: ProfileEditAppBar(
        controller: controller,
        onSave: _saveProfile,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, topSpace, 16, 40),
          children: [
            // --- Avatar Section ---
            Obx(() => ProfileAvatarSection(
              profileImagePath: controller.profileImagePath.value,
              onChangePhoto: () {
                showProfilePhotoSheet(
                  context: context,
                  profileImagePath: controller.profileImagePath.value,
                  onViewPhoto: () {
                    if (controller.profileImagePath.value.isNotEmpty) {
                      Get.to(() => FullProfileImageViewer(
                        imagePath: controller.profileImagePath.value,
                      ));
                    }
                  },
                  onTakePhoto: _takeProfilePhoto,
                  onChooseGallery: _chooseProfilePhoto,
                  onRemovePhoto: _removeProfilePhoto,
                );
              },
            )),

            const SizedBox(height: 28),

            // --- Account Section ---
            ProfileSectionTitle(
              title: 'account',
              icon: CupertinoIcons.person_crop_circle,
            ),
            const SizedBox(height: 8),
            ProfileFormCard(
              cardColor: cardColor,
              borderColor: borderColor,
              isDark: isDark,
              children: [
                // REPLACED: Combined first_name and last_name into a single Name field
                ProfileField(
                  controller: controller.nameController,
                  label: 'name'.tr,
                  icon: CupertinoIcons.person,
                  validator: controller.validateRequired,
                ),
                const SizedBox(height: 14),
                // Bio Field
                ProfileField(
                  controller: controller.bioController,
                  label: 'bio'.tr,
                  icon: CupertinoIcons.info,
                  maxLines: 3,
                  maxLength: 100,
                ),
              ],
            ),

             SizedBox(height: 26),

            // --- Contact Info Section ---
             ProfileSectionTitle(
              title: 'your_info',
              icon: CupertinoIcons.doc_text,
            ),
             SizedBox(height: 8),
            ProfileFormCard(
              cardColor: cardColor,
              borderColor: borderColor,
              isDark: isDark,
              children: [
                // ADDED: New Email field
                ProfileField(
                  controller: controller.emailController,
                  label: 'email'.tr,
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 14),
                // Phone Number Field
                ProfileField(
                  controller: controller.phoneController,
                  label: 'phone_number'.tr,
                  icon: CupertinoIcons.phone,
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                ),
                const SizedBox(height: 14),
                // Username Field
                ProfileField(
                  controller: controller.usernameController,
                  label: 'username'.tr,
                  icon: CupertinoIcons.at,
                  prefixText: '@',
                  validator: controller.validateUsername,
                ),
              ],
            ),

            const SizedBox(height: 26),

            // --- Logout Button ---
            LogoutButton(
              controller: settingsController,
            ),
          ],
        ),
      ),
    );
  }
}