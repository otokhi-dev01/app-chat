import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Builder(
          builder: (BuildContext context) {
            ThemeData theme = Theme.of(context);
            ColorScheme colorScheme = theme.colorScheme;

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
              statusBarColor: Colors.transparent,
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
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
              Brightness.dark,
              statusBarBrightness:
              Brightness.light,
              systemNavigationBarColor:
              theme.scaffoldBackgroundColor,
              systemNavigationBarIconBrightness:
              Brightness.dark,
            );

            return AppBar(
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
                    message: 'Back',
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus
                            ?.unfocus();

                        Get.back();
                      },
                      customBorder: CircleBorder(),
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: colorScheme.onSurface,
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
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
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
                            : () {
                          FocusManager
                              .instance.primaryFocus
                              ?.unfocus();

                          controller.saveProfile();
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size(68, 36),
                          maximumSize: Size(90, 36),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          backgroundColor:
                          colorScheme.primary,
                          foregroundColor:
                          colorScheme.onPrimary,
                          disabledBackgroundColor:
                          colorScheme.primary.withValues(
                            alpha: 0.55,
                          ),
                          disabledForegroundColor:
                          colorScheme.onPrimary.withValues(
                            alpha: 0.75,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
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
                              color:
                              colorScheme.onPrimary,
                            ),
                          )
                              : Text(
                            'save'.tr,
                            key: ValueKey(
                              'save-profile',
                            ),
                            style: TextStyle(
                              color:
                              colorScheme.onPrimary,
                              fontSize: 13,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
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