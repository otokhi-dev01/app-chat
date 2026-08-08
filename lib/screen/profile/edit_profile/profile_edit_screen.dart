import 'dart:ui';

import 'package:appchat/screen/widgets/logout_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/profile/edit_profile_controller.dart';
import '../../../controllers/settings/settings_controller.dart';
import '../../../services/picker_service/chat_camera_services.dart';
import 'full_profile_image_viewer.dart';
import 'profile_avatar_section.dart';
import 'profile_field.dart';
import 'profile_photo_sheet.dart';

class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen({
    super.key,
  });

  final ProfileEditController controller = Get.put(
    ProfileEditController(),
  );

  SettingsController get settingsController {
    return Get.find<SettingsController>();
  }

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

      if (mediaPath == null || mediaPath.trim().isEmpty) {
        return;
      }

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

      if (mediaPath == null || mediaPath.trim().isEmpty) {
        return;
      }

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

    if (currentPath.isEmpty) {
      return;
    }

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
      icon: Icon(
        icon,
      ),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color appBarColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    final Color actionBackground = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final SystemUiOverlayStyle overlayStyle = isDark
        ? SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    )
        : SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        forceMaterialTransparency: true,
        titleSpacing: 0,
        leadingWidth: 58,
        systemOverlayStyle: overlayStyle,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 18,
              sigmaY: 18,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: appBarColor,
                border: Border(
                  bottom: BorderSide(
                    color: borderColor,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          child: Tooltip(
            message: 'back'.tr,
            child: Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: actionBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: borderColor,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.15 : 0.04,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 40),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back();
                },
                child: Icon(
                  CupertinoIcons.chevron_left,
                  size: 20,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'edit_profile'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Obx(
                () {
              bool isSaving = controller.isSaving.value;

              return Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  right: 12,
                  bottom: 12,
                ),
                child: TextButton(
                  onPressed: isSaving ? null : _saveProfile,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(68, 36),
                    maximumSize: const Size(90, 36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    disabledBackgroundColor: colorScheme.primary.withValues(
                      alpha: 0.55,
                    ),
                    disabledForegroundColor: colorScheme.onPrimary.withValues(
                      alpha: 0.75,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 180,
                    ),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: isSaving
                        ? SizedBox(
                      key: const ValueKey('saving-profile'),
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                        : Text(
                      'save'.tr,
                      key: const ValueKey('save-profile'),
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Form(
        key: controller.formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            Obx(
                  () {
                return ProfileAvatarSection(
                  profileImagePath: controller.profileImagePath.value,
                  onChangePhoto: () {
                    showProfilePhotoSheet(
                      context: context,
                      profileImagePath: controller.profileImagePath.value,
                      onViewPhoto: () {
                        String imagePath = controller.profileImagePath.value;

                        if (imagePath.trim().isEmpty) return;

                        Get.to(
                              () => FullProfileImageViewer(
                            imagePath: imagePath,
                          ),
                        );
                      },
                      onTakePhoto: _takeProfilePhoto,
                      onChooseGallery: _chooseProfilePhoto,
                      onRemovePhoto: _removeProfilePhoto,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 28),
            _ProfileSectionTitle(
              title: 'account'.tr,
              icon: CupertinoIcons.person_crop_circle,
            ),
            const SizedBox(height: 8),
            _ProfileFormCard(
              cardColor: cardColor,
              borderColor: borderColor,
              isDark: isDark,
              children: [
                ProfileField(
                  controller: controller.firstNameController,
                  label: 'first_name'.tr,
                  icon: CupertinoIcons.person,
                  validator: controller.validateRequired,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                ProfileField(
                  controller: controller.lastNameController,
                  label: 'last_name'.tr,
                  icon: CupertinoIcons.person,
                  validator: controller.validateRequired,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                ProfileField(
                  controller: controller.bioController,
                  label: 'bio'.tr,
                  icon: CupertinoIcons.info,
                  maxLines: 3,
                  maxLength: 100,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
            const SizedBox(height: 26),
            _ProfileSectionTitle(
              title: 'your_info'.tr,
              icon: CupertinoIcons.doc_text,
            ),
            const SizedBox(height: 8),
            _ProfileFormCard(
              cardColor: cardColor,
              borderColor: borderColor,
              isDark: isDark,
              children: [
                ProfileField(
                  controller: controller.phoneController,
                  label: 'phone_number'.tr,
                  icon: CupertinoIcons.phone,
                  keyboardType: TextInputType.phone,
                  validator: controller.validateRequired,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                ProfileField(
                  controller: controller.usernameController,
                  label: 'username'.tr,
                  icon: CupertinoIcons.at,
                  prefixText: '@',
                  validator: controller.validateRequired,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
            const SizedBox(height: 26),
            LogoutButton(
              controller: settingsController,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ProfileSectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color sectionColor = colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Icon(
            icon,
            color: sectionColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: sectionColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileFormCard extends StatelessWidget {
  final Color cardColor;
  final Color borderColor;
  final bool isDark;
  final List<Widget> children;

  const _ProfileFormCard({
    required this.cardColor,
    required this.borderColor,
    required this.isDark,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}