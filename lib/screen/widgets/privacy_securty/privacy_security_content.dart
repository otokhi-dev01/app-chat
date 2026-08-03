import 'package:appchat/screen/widgets/privacy_securty/privacy_security_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../route/app_route.dart';
import 'privacy_security_card.dart';

class PrivacySecurityContent extends StatelessWidget {
  final bool appLockEnabled;
  final bool screenSecurityEnabled;
  final bool syncContactsEnabled;

  final String phoneNumberPrivacy;
  final String lastSeenPrivacy;
  final String profilePhotoPrivacy;
  final String callsPrivacy;
  final String groupsPrivacy;
  final String twoStepStatus;
  final String accountDeletePeriod;

  final ValueChanged<bool> onAppLockChanged;

  final ValueChanged<bool> onScreenSecurityChanged;

  final ValueChanged<bool> onSyncContactsChanged;

  final VoidCallback onPhoneNumberTap;
  final VoidCallback onLastSeenTap;
  final VoidCallback onProfilePhotoTap;
  final VoidCallback onCallsTap;
  final VoidCallback onGroupsTap;
  final VoidCallback onTwoStepTap;
  final VoidCallback onDeletePeriodTap;

  const PrivacySecurityContent({
    super.key,
    required this.appLockEnabled,
    required this.screenSecurityEnabled,
    required this.syncContactsEnabled,
    required this.phoneNumberPrivacy,
    required this.lastSeenPrivacy,
    required this.profilePhotoPrivacy,
    required this.callsPrivacy,
    required this.groupsPrivacy,
    required this.twoStepStatus,
    required this.accountDeletePeriod,
    required this.onAppLockChanged,
    required this.onScreenSecurityChanged,
    required this.onSyncContactsChanged,
    required this.onPhoneNumberTap,
    required this.onLastSeenTap,
    required this.onProfilePhotoTap,
    required this.onCallsTap,
    required this.onGroupsTap,
    required this.onTwoStepTap,
    required this.onDeletePeriodTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        18,
        16,
        34,
      ),
      children: [
        PrivacySecurityHeader(),
        SizedBox(height: 24),

        PrivacySecuritySectionTitle(
          title: 'privacy'.tr,
        ),
        SizedBox(height: 9),

        PrivacySecurityCard(
          children: [
            PrivacyNavigationTile(
              icon: CupertinoIcons.phone,
              title: 'phone_number'.tr,
              subtitle: 'phone_number_privacy_desc'.tr,
              trailingText: phoneNumberPrivacy,
              onTap: onPhoneNumberTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon: CupertinoIcons.time,
              title: 'last_seen_and_online'.tr,
              subtitle: 'last_seen_privacy_desc'.tr,
              trailingText: lastSeenPrivacy,
              onTap: onLastSeenTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon: CupertinoIcons.person_crop_circle,
              title: 'profile_photos'.tr,
              subtitle: 'profile_photo_privacy_desc'.tr,
              trailingText: profilePhotoPrivacy,
              onTap: onProfilePhotoTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon: CupertinoIcons.phone,
              title: 'calls'.tr,
              subtitle: 'calls_privacy_desc'.tr,
              trailingText: callsPrivacy,
              onTap: onCallsTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon: CupertinoIcons.person_3,
              title: 'groups_and_channels'.tr,
              subtitle: 'groups_privacy_desc'.tr,
              trailingText: groupsPrivacy,
              onTap: onGroupsTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon: CupertinoIcons.slash_circle,
              title: 'blocked_users'.tr,
              subtitle: 'manage_blocked'.tr,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();

                Get.toNamed(
                  AppRoutes.blockedContacts,
                  preventDuplicates: true,
                );
              },
            ),
          ],
        ),

        SizedBox(height: 24),

        PrivacySecuritySectionTitle(
          title: 'security'.tr,
        ),
        SizedBox(height: 9),

        PrivacySecurityCard(
          children: [
            PrivacyNavigationTile(
              icon: CupertinoIcons.shield_lefthalf_fill,
              title: 'two_step_verification'.tr,
              subtitle: 'two_step_desc'.tr,
              trailingText: twoStepStatus,
              onTap: onTwoStepTap,
            ),
            PrivacySecurityDivider(),
            PrivacySwitchTile(
              icon: CupertinoIcons.lock,
              title: 'app_lock'.tr,
              subtitle: 'app_lock_desc'.tr,
              value: appLockEnabled,
              onChanged: onAppLockChanged,
            ),
            PrivacySecurityDivider(),
            PrivacySwitchTile(
              icon: CupertinoIcons.eye_slash,
              title: 'screen_security'.tr,
              subtitle: 'screen_security_desc'.tr,
              value: screenSecurityEnabled,
              onChanged: onScreenSecurityChanged,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon: CupertinoIcons.desktopcomputer,
              title: 'active_sessions'.tr,
              subtitle: 'active_sessions_desc'.tr,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();

                Get.toNamed(
                  AppRoutes.devices,
                  preventDuplicates: true,
                );
              },
            ),
          ],
        ),

        SizedBox(height: 24),

        PrivacySecuritySectionTitle(
          title: 'contacts'.tr,
        ),
        SizedBox(height: 9),

        PrivacySecurityCard(
          children: [
            PrivacySwitchTile(
              icon: CupertinoIcons.person_crop_circle_badge_checkmark,
              title: 'sync_contacts'.tr,
              subtitle: 'sync_contacts_description'.tr,
              value: syncContactsEnabled,
              onChanged: onSyncContactsChanged,
            ),
            PrivacySecurityDivider(),
            PrivacyActionTile(
              icon: CupertinoIcons.trash,
              title: 'delete_synced_contacts'.tr,
              subtitle: 'delete_synced_contacts_desc'.tr,
              onTap: () {},
            ),
          ],
        ),

        SizedBox(height: 24),

        PrivacySecuritySectionTitle(
          title: 'delete_my_account'.tr,
        ),
        SizedBox(height: 9),

        PrivacySecurityCard(
          children: [
            PrivacyNavigationTile(
              icon: CupertinoIcons.timer,
              title: 'if_away_for'.tr,
              subtitle: 'delete_account_if_away_desc'.tr,
              trailingText: accountDeletePeriod,
              onTap: onDeletePeriodTap,
            ),
          ],
        ),

        SizedBox(height: 18),

        PrivacySecurityWarning(),
      ],
    );
  }
}