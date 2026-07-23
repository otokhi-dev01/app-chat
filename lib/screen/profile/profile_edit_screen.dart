import 'dart:ui';

import 'package:appchat/screen/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/profile/edit_profile_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import '../../services/chat_camera_services.dart';
import '../widgets/profile/full_profile_image_viewer.dart';
import '../widgets/profile/profile_avatar_section.dart';
import '../widgets/profile/profile_field.dart';
import '../widgets/profile/profile_photo_sheet.dart';

// Change this path only when your existing logout widget
// uses a different folder.

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

  final ChatCameraService _cameraService =
  ChatCameraService();

  Future<void> _saveProfile() async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool isValid =
        controller.formKey.currentState?.validate() ??
            false;

    if (!isValid) {
      _showMessage(
        title: 'invalid_profile_information'.tr,
        message: 'check_profile_information'.tr,
        icon: Icons.error_outline_rounded,
      );

      return;
    }

    try {
      await controller.saveProfile();

      _showMessage(
        title: 'profile_updated'.tr,
        message: 'profile_updated_successfully'.tr,
        icon: Icons.check_circle_outline_rounded,
      );
    } catch (error) {
      _showMessage(
        title: 'unable_to_update_profile'.tr,
        message: _cleanErrorMessage(error),
        icon: Icons.error_outline_rounded,
      );
    }
  }

  Future<void> _takeProfilePhoto() async {
    try {
      dynamic result =
      await _cameraService.takePhoto();

      String? mediaPath = result?.mediaPath;

      if (mediaPath == null ||
          mediaPath.trim().isEmpty) {
        return;
      }

      controller.setProfileImage(
        mediaPath,
      );

      _showMessage(
        title: 'profile_photo_updated'.tr,
        message: 'new_profile_photo_selected'.tr,
        icon: Icons.camera_alt_rounded,
      );
    } catch (error) {
      _showMessage(
        title: 'unable_to_update_photo'.tr,
        message: _cleanErrorMessage(error),
        icon: Icons.error_outline_rounded,
      );
    }
  }

  Future<void> _chooseProfilePhoto() async {
    try {
      dynamic result =
      await _cameraService.pickFromGallery();

      String? mediaPath = result?.mediaPath;

      if (mediaPath == null ||
          mediaPath.trim().isEmpty) {
        return;
      }

      controller.setProfileImage(
        mediaPath,
      );

      _showMessage(
        title: 'profile_photo_updated'.tr,
        message:
        'gallery_profile_photo_selected'.tr,
        icon: Icons.photo_library_rounded,
      );
    } catch (error) {
      _showMessage(
        title: 'unable_to_update_photo'.tr,
        message: _cleanErrorMessage(error),
        icon: Icons.error_outline_rounded,
      );
    }
  }

  void _removeProfilePhoto() {
    String currentPath =
    controller.profileImagePath.value.trim();

    if (currentPath.isEmpty) {
      return;
    }

    controller.removeProfileImage();

    _showMessage(
      title: 'profile_photo_removed'.tr,
      message:
      'profile_photo_removed_successfully'.tr,
      icon: Icons.delete_outline_rounded,
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
      DismissDirection.horizontal,
    );
  }

  String _cleanErrorMessage(
      Object error,
      ) {
    return error
        .toString()
        .replaceFirst(
      'Bad state: ',
      '',
    )
        .replaceFirst(
      'Exception: ',
      '',
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.94,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFE7E9ED);

    SystemUiOverlayStyle overlayStyle = isDark
        ? SystemUiOverlayStyle.light.copyWith(
      statusBarColor:
      Colors.transparent,
      statusBarIconBrightness:
      Brightness.light,
      statusBarBrightness:
      Brightness.dark,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
      Brightness.light,
    )
        : SystemUiOverlayStyle.dark.copyWith(
      statusBarColor:
      Colors.transparent,
      statusBarIconBrightness:
      Brightness.dark,
      statusBarBrightness:
      Brightness.light,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
      Brightness.dark,
    );

    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor:
        colorScheme.onSurface,
        surfaceTintColor:
        Colors.transparent,
        shadowColor: Colors.transparent,
        forceMaterialTransparency: true,
        titleSpacing: 0,
        leadingWidth: 54,
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
          padding: EdgeInsets.fromLTRB(
            8,
            12,
            5,
            12,
          ),
          child: Material(
            color: actionBackground,
            shape: CircleBorder(),
            child: Tooltip(
              message: 'back'.tr,
              child: InkWell(
                onTap: () {
                  FocusManager
                      .instance.primaryFocus
                      ?.unfocus();

                  Get.back();
                },
                customBorder: CircleBorder(),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons
                        .arrow_back_ios_new_rounded,
                    size: 16,
                    color:
                    colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'edit_profile'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme
              .textTheme.titleMedium
              ?.copyWith(
            color:
            colorScheme.onSurface,
            fontSize: 17,
            fontWeight:
            FontWeight.w700,
          ),
        ),
        actions: [
          Obx(
                () {
              bool isSaving =
                  controller.isSaving.value;

              return Padding(
                padding: EdgeInsets.only(
                  top: 12,
                  right: 8,
                  bottom: 12,
                ),
                child: TextButton(
                  onPressed: isSaving
                      ? null
                      : _saveProfile,
                  style: TextButton.styleFrom(
                    minimumSize:
                    Size(68, 36),
                    maximumSize:
                    Size(90, 36),
                    padding:
                    EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    backgroundColor:
                    colorScheme.primary,
                    foregroundColor:
                    colorScheme.onPrimary,
                    disabledBackgroundColor:
                    colorScheme.primary
                        .withValues(
                      alpha: 0.55,
                    ),
                    disabledForegroundColor:
                    colorScheme.onPrimary
                        .withValues(
                      alpha: 0.75,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: Duration(
                      milliseconds: 180,
                    ),
                    switchInCurve:
                    Curves.easeOutCubic,
                    switchOutCurve:
                    Curves.easeInCubic,
                    child: isSaving
                        ? SizedBox(
                      key: ValueKey(
                        'saving-profile',
                      ),
                      width: 17,
                      height: 17,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme
                            .onPrimary,
                      ),
                    )
                        : Text(
                      'save'.tr,
                      key: ValueKey(
                        'save-profile',
                      ),
                      style: TextStyle(
                        color: colorScheme
                            .onPrimary,
                        fontSize: 13,
                        fontWeight:
                        FontWeight
                            .w700,
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
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Form(
        key: controller.formKey,
        child: ListView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,
          physics: BouncingScrollPhysics(
            parent:
            AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            40,
          ),
          children: [
            Obx(
                  () {
                return ProfileAvatarSection(
                  profileImagePath:
                  controller
                      .profileImagePath
                      .value,
                  onChangePhoto: () {
                    showProfilePhotoSheet(
                      context: context,
                      profileImagePath:
                      controller
                          .profileImagePath
                          .value,
                      onViewPhoto: () {
                        String imagePath =
                            controller
                                .profileImagePath
                                .value;

                        if (imagePath
                            .trim()
                            .isEmpty) {
                          return;
                        }

                        Get.to(
                              () =>
                              FullProfileImageViewer(
                                imagePath:
                                imagePath,
                              ),
                        );
                      },
                      onTakePhoto:
                      _takeProfilePhoto,
                      onChooseGallery:
                      _chooseProfilePhoto,
                      onRemovePhoto:
                      _removeProfilePhoto,
                    );
                  },
                );
              },
            ),

            SizedBox(height: 28),

            _ProfileSectionTitle(
              title: 'account'.tr,
              icon:
              Icons.person_outline_rounded,
            ),

            SizedBox(height: 8),

            _ProfileFormCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: [
                ProfileField(
                  controller:
                  controller
                      .firstNameController,
                  label: 'first_name'.tr,
                  icon:
                  Icons.person_outline_rounded,
                  validator:
                  controller.validateRequired,
                  textInputAction:
                  TextInputAction.next,
                ),

                SizedBox(height: 14),

                ProfileField(
                  controller:
                  controller
                      .lastNameController,
                  label: 'last_name'.tr,
                  icon:
                  Icons.person_outline_rounded,
                  validator:
                  controller.validateRequired,
                  textInputAction:
                  TextInputAction.next,
                ),

                SizedBox(height: 14),

                ProfileField(
                  controller:
                  controller.bioController,
                  label: 'bio'.tr,
                  icon:
                  Icons.info_outline_rounded,
                  maxLines: 3,
                  maxLength: 100,
                  textInputAction:
                  TextInputAction.next,
                ),
              ],
            ),

            SizedBox(height: 26),

            _ProfileSectionTitle(
              title: 'your_info'.tr,
              icon:
              Icons.contact_page_outlined,
            ),

            SizedBox(height: 8),

            _ProfileFormCard(
              cardColor: cardColor,
              borderColor: borderColor,
              children: [
                ProfileField(
                  controller:
                  controller.phoneController,
                  label: 'phone_number'.tr,
                  icon:
                  Icons.phone_outlined,
                  keyboardType:
                  TextInputType.phone,
                  validator:
                  controller.validateRequired,
                  textInputAction:
                  TextInputAction.next,
                ),

                SizedBox(height: 14),

                ProfileField(
                  controller:
                  controller
                      .usernameController,
                  label: 'username'.tr,
                  icon: Icons
                      .alternate_email_rounded,
                  prefixText: '@',
                  validator:
                  controller.validateRequired,
                  textInputAction:
                  TextInputAction.done,
                ),
              ],
            ),

            SizedBox(height: 26),

            LogoutButton(
              controller: settingsController,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSectionTitle
    extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDanger;

  _ProfileSectionTitle({
    required this.title,
    required this.icon,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    Color sectionColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 6,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: sectionColor,
            size: 18,
          ),

          SizedBox(width: 8),

          Text(
            title,
            style: theme
                .textTheme.titleSmall
                ?.copyWith(
              color: sectionColor,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileFormCard
    extends StatelessWidget {
  final Color cardColor;
  final Color borderColor;
  final List<Widget> children;

  _ProfileFormCard({
    required this.cardColor,
    required this.borderColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}