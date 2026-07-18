import 'package:get/get.dart';

class PrivacySecurityController
    extends GetxController {
  final RxBool appLockEnabled = false.obs;
  final RxBool screenSecurityEnabled = true.obs;
  final RxBool syncContactsEnabled = true.obs;

  final RxString phoneNumberPrivacy =
      'My Contacts'.obs;

  final RxString lastSeenPrivacy =
      'Everybody'.obs;

  final RxString profilePhotoPrivacy =
      'Everybody'.obs;

  final RxString callsPrivacy =
      'My Contacts'.obs;

  final RxString groupsPrivacy =
      'My Contacts'.obs;

  final RxString accountDeletePeriod =
      '6 months'.obs;

  final RxString twoStepVerificationStatus =
      'Off'.obs;

  void toggleAppLock(
      bool value,
      ) {
    appLockEnabled.value = value;
  }

  void toggleScreenSecurity(
      bool value,
      ) {
    screenSecurityEnabled.value = value;
  }

  void toggleSyncContacts(
      bool value,
      ) {
    syncContactsEnabled.value = value;
  }

  void updatePhoneNumberPrivacy(
      String value,
      ) {
    phoneNumberPrivacy.value = value;
  }

  void updateLastSeenPrivacy(
      String value,
      ) {
    lastSeenPrivacy.value = value;
  }

  void updateProfilePhotoPrivacy(
      String value,
      ) {
    profilePhotoPrivacy.value = value;
  }

  void updateCallsPrivacy(
      String value,
      ) {
    callsPrivacy.value = value;
  }

  void updateGroupsPrivacy(
      String value,
      ) {
    groupsPrivacy.value = value;
  }

  void updateDeletePeriod(
      String value,
      ) {
    accountDeletePeriod.value = value;
  }

  void updateTwoStepVerification(
      bool enabled,
      ) {
    twoStepVerificationStatus.value =
    enabled ? 'On' : 'Off';
  }
}