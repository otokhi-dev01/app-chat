import 'package:appchat/screen/settings/privacy_security/privacy_option_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/settings/settings_privacy_security_controller.dart';
import '../../widgets/privacy_securty/privacy_security_content.dart';
import 'privacy_security_app_bar.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({
    super.key,
  });

  PrivacySecurityController get controller {
    return Get.find<PrivacySecurityController>();
  }

  Future<void> _openOptions({
    required BuildContext context,
    required String title,
    required String selectedValue,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    String? result = await PrivacyOptionsSheet.open(
      context: context,
      title: title,
      selectedValue: selectedValue,
      options: options,
    );

    if (result == null || result == selectedValue) {
      return;
    }

    onSelected(result);
  }

  Future<void> _openPrivacyOptions({
    required BuildContext context,
    required String title,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return _openOptions(
      context: context,
      title: title,
      selectedValue: selectedValue,
      options: [
        'Everybody',
        'My Contacts',
        'Nobody',
      ],
      onSelected: onSelected,
    );
  }

  Future<void> _openTwoStepOptions(
      BuildContext context,
      ) {
    return _openOptions(
      context: context,
      title: 'two_step_verification'.tr,
      selectedValue: controller.twoStepVerificationStatus.value,
      options: [
        'On',
        'Off',
      ],
      onSelected: (String value) {
        controller.updateTwoStepVerification(
          value == 'On',
        );
      },
    );
  }

  Future<void> _openDeletePeriodOptions(
      BuildContext context,
      ) {
    return _openOptions(
      context: context,
      title: 'delete_account_if_away_for'.tr,
      selectedValue: controller.accountDeletePeriod.value,
      options: [
        '1 month',
        '3 months',
        '6 months',
        '1 year',
      ],
      onSelected: controller.updateDeletePeriod,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PrivacySecurityAppBar(),
      body: Obx(
            () {
          return PrivacySecurityContent(
            appLockEnabled: controller.appLockEnabled.value,
            screenSecurityEnabled: controller.screenSecurityEnabled.value,
            syncContactsEnabled: controller.syncContactsEnabled.value,
            phoneNumberPrivacy: controller.phoneNumberPrivacy.value,
            lastSeenPrivacy: controller.lastSeenPrivacy.value,
            profilePhotoPrivacy: controller.profilePhotoPrivacy.value,
            callsPrivacy: controller.callsPrivacy.value,
            groupsPrivacy: controller.groupsPrivacy.value,
            twoStepStatus: controller.twoStepVerificationStatus.value,
            accountDeletePeriod: controller.accountDeletePeriod.value,
            onAppLockChanged: controller.toggleAppLock,
            onScreenSecurityChanged: controller.toggleScreenSecurity,
            onSyncContactsChanged: controller.toggleSyncContacts,
            onPhoneNumberTap: () {
              _openPrivacyOptions(
                context: context,
                title: 'phone_number'.tr,
                selectedValue: controller.phoneNumberPrivacy.value,
                onSelected: controller.updatePhoneNumberPrivacy,
              );
            },
            onLastSeenTap: () {
              _openPrivacyOptions(
                context: context,
                title: 'last_seen_and_online'.tr,
                selectedValue: controller.lastSeenPrivacy.value,
                onSelected: controller.updateLastSeenPrivacy,
              );
            },
            onProfilePhotoTap: () {
              _openPrivacyOptions(
                context: context,
                title: 'profile_photos'.tr,
                selectedValue: controller.profilePhotoPrivacy.value,
                onSelected: controller.updateProfilePhotoPrivacy,
              );
            },
            onCallsTap: () {
              _openPrivacyOptions(
                context: context,
                title: 'calls'.tr,
                selectedValue: controller.callsPrivacy.value,
                onSelected: controller.updateCallsPrivacy,
              );
            },
            onGroupsTap: () {
              _openPrivacyOptions(
                context: context,
                title: 'groups_and_channels'.tr,
                selectedValue: controller.groupsPrivacy.value,
                onSelected: controller.updateGroupsPrivacy,
              );
            },
            onTwoStepTap: () {
              _openTwoStepOptions(
                context,
              );
            },
            onDeletePeriodTap: () {
              _openDeletePeriodOptions(
                context,
              );
            },
          );
        },
      ),
    );
  }
}