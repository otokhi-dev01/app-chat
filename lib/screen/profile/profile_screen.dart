import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../route/app_route.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_imformation_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller =
    Get.find<SettingsController>();

    return ListView(
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        110,
      ),
      children: [
        Obx(
              () => ProfileHeader(
            name: controller.userName.value,
            email: controller.userEmail.value,
            onEditProfile: () {
              Get.toNamed(AppRoutes.editProfile);
            },
          ),
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
          ),
          child: Text(
            'profile_information'.tr,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(
              color:
              Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Obx(
              () => ProfileInformationCard(
            username: controller.userUsername.value,
            bio: controller.userBio.value,
          ),
        ),
      ],
    );
  }
}