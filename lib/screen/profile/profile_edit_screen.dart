import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/edit_profile_controller.dart';
import '../widgets/profile/profile_avatar_section.dart';
import '../widgets/profile/profile_field.dart';
import '../widgets/profile/profile_photo_sheet.dart';


class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen({super.key});

  final ProfileEditController controller = Get.put(
    ProfileEditController(),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'edit_profile'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Obx(
                () => TextButton(
              onPressed: controller.isSaving.value
                  ? null
                  : controller.saveProfile,
              child: controller.isSaving.value
                  ? SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
                  : Text(
                'save'.tr,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            32,
          ),
          children: [
            ProfileAvatarSection(
              onChangePhoto: () {
                showProfilePhotoSheet(
                  context: context,
                  onTakePhoto: () {
                    // Add camera picker.
                  },
                  onChooseGallery: () {
                    // Add gallery picker.
                  },
                  onRemovePhoto: () {
                    // Remove profile photo.
                  },
                );
              },
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.only(
                left: 6,
                right: 6,
                bottom: 8,
              ),
              child: Text(
                'personal_information'.tr,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Column(
                children: [
                  ProfileField(
                    controller: controller.nameController,
                    label: 'full_name'.tr,
                    icon: Icons.person_outline_rounded,
                    validator: controller.validateRequired,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 14),

                  ProfileField(
                    controller: controller.usernameController,
                    label: 'username'.tr,
                    icon: Icons.alternate_email_rounded,
                    prefixText: '@',
                    validator: controller.validateRequired,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 14),

                  ProfileField(
                    controller: controller.phoneController,
                    label: 'phone_number'.tr,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: controller.validateRequired,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 14),

                  ProfileField(
                    controller: controller.emailController,
                    label: 'email'.tr,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 14),

                  ProfileField(
                    controller: controller.bioController,
                    label: 'bio'.tr,
                    icon: Icons.info_outline_rounded,
                    maxLines: 3,
                    maxLength: 100,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}