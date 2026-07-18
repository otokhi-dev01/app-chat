import 'package:appchat/screen/widgets/privacy_securty/privacy_security_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../route/app_route.dart';
import 'privacy_security_card.dart';

class PrivacySecurityContent
    extends StatelessWidget {
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

  final ValueChanged<bool>
  onAppLockChanged;

  final ValueChanged<bool>
  onScreenSecurityChanged;

  final ValueChanged<bool>
  onSyncContactsChanged;

  final VoidCallback onPhoneNumberTap;
  final VoidCallback onLastSeenTap;
  final VoidCallback onProfilePhotoTap;
  final VoidCallback onCallsTap;
  final VoidCallback onGroupsTap;
  final VoidCallback onTwoStepTap;
  final VoidCallback onDeletePeriodTap;

  PrivacySecurityContent({
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
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior
          .onDrag,
      physics: BouncingScrollPhysics(
        parent:
        AlwaysScrollableScrollPhysics(),
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
          title: 'Privacy',
        ),
        SizedBox(height: 9),

        PrivacySecurityCard(
          children: [
            PrivacyNavigationTile(
              icon:
              Icons.phone_outlined,
              title: 'Phone Number',
              subtitle:
              'Control who can see your phone number',
              trailingText:
              phoneNumberPrivacy,
              onTap: onPhoneNumberTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon:
              Icons.schedule_rounded,
              title:
              'Last Seen & Online',
              subtitle:
              'Choose who can see your activity',
              trailingText:
              lastSeenPrivacy,
              onTap: onLastSeenTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon:
              Icons.account_circle_outlined,
              title: 'Profile Photos',
              subtitle:
              'Control who can see your photos',
              trailingText:
              profilePhotoPrivacy,
              onTap: onProfilePhotoTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon:
              Icons.call_outlined,
              title: 'Calls',
              subtitle:
              'Choose who can call you',
              trailingText:
              callsPrivacy,
              onTap: onCallsTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon:
              Icons.groups_outlined,
              title:
              'Groups & Channels',
              subtitle:
              'Choose who can add you',
              trailingText:
              groupsPrivacy,
              onTap: onGroupsTap,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon:
              Icons.block_rounded,
              title: 'Blocked Users',
              subtitle:
              'Manage blocked accounts',
              trailingText: '0',
              onTap: () {},
            ),
          ],
        ),

        SizedBox(height: 24),

        PrivacySecuritySectionTitle(
          title: 'Security',
        ),
        SizedBox(height: 9),

        PrivacySecurityCard(
          children: [
            PrivacyNavigationTile(
              icon:
              Icons.password_rounded,
              title:
              'Two-Step Verification',
              subtitle:
              'Add an extra password to your account',
              trailingText:
              twoStepStatus,
              onTap: onTwoStepTap,
            ),
            PrivacySecurityDivider(),
            PrivacySwitchTile(
              icon:
              Icons.lock_outline_rounded,
              title: 'App Lock',
              subtitle:
              'Require authentication to open the app',
              value:
              appLockEnabled,
              onChanged:
              onAppLockChanged,
            ),
            PrivacySecurityDivider(),
            PrivacySwitchTile(
              icon:
              Icons.visibility_off_outlined,
              title:
              'Screen Security',
              subtitle:
              'Prevent screenshots in sensitive screens',
              value:
              screenSecurityEnabled,
              onChanged:
              onScreenSecurityChanged,
            ),
            PrivacySecurityDivider(),
            PrivacyNavigationTile(
              icon:
              Icons.devices_outlined,
              title:
              'Active Sessions',
              subtitle:
              'Manage devices signed into your account',
              onTap: () {
                FocusManager
                    .instance.primaryFocus
                    ?.unfocus();

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
          title: 'Contacts',
        ),
        SizedBox(height: 9),

        PrivacySecurityCard(
          children: [
            PrivacySwitchTile(
              icon:
              Icons.sync_rounded,
              title:
              'Sync Contacts',
              subtitle:
              'Keep your contacts updated automatically',
              value:
              syncContactsEnabled,
              onChanged:
              onSyncContactsChanged,
            ),
            PrivacySecurityDivider(),
            PrivacyActionTile(
              icon:
              Icons.delete_sweep_outlined,
              title:
              'Delete Synced Contacts',
              subtitle:
              'Remove contacts uploaded to the server',
              onTap: () {},
            ),
          ],
        ),

        SizedBox(height: 24),

        PrivacySecuritySectionTitle(
          title: 'Delete My Account',
        ),
        SizedBox(height: 9),

        PrivacySecurityCard(
          children: [
            PrivacyNavigationTile(
              icon:
              Icons.timer_outlined,
              title:
              'If Away For',
              subtitle:
              'Automatically delete your account after inactivity',
              trailingText:
              accountDeletePeriod,
              onTap:
              onDeletePeriodTap,
            ),
          ],
        ),

        SizedBox(height: 18),

        PrivacySecurityWarning(),
      ],
    );
  }
}