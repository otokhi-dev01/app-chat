import 'package:appchat/screen/widgets/profile/profile_imformation_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProfileInformationCard extends StatelessWidget {
  final String username;
  final String bio;

  const ProfileInformationCard({
    super.key,
    required this.username,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark =
        theme.brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dividerColor,
        ),
      ),
      child: Column(
        children: [
          ProfileInformationTile(
            icon: Icons.alternate_email_rounded,
            label: 'username'.tr,
            value: username,
          ),

          Divider(
            height: 1,
            thickness: 1,
            indent: 69,
            color: dividerColor,
          ),

          ProfileInformationTile(
            icon: Icons.info_outline_rounded,
            label: 'bio'.tr,
            value: bio,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}