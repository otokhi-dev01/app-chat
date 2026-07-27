import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString userName =
      'John Doe'.obs;

  final RxString userPhone =
      '+1 555 000 1234'.obs;

  final RxString userEmail =
      'john@example.com'.obs;

  final RxString userUsername =
      '@johndoe'.obs;

  final RxString userBio =
      'Available'.obs;

  void updateName(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue.isEmpty ||
        newValue == userName.value) {
      return;
    }

    userName.value = newValue;
  }

  void updatePhone(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue.isEmpty ||
        newValue == userPhone.value) {
      return;
    }

    userPhone.value = newValue;
  }

  void updateEmail(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue.isEmpty ||
        newValue == userEmail.value ||
        !GetUtils.isEmail(newValue)) {
      return;
    }

    userEmail.value = newValue;
  }

  void updateUsername(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue.isEmpty) {
      return;
    }

    String normalizedUsername =
    newValue.startsWith('@')
        ? newValue
        : '@$newValue';

    if (normalizedUsername ==
        userUsername.value) {
      return;
    }

    userUsername.value =
        normalizedUsername;
  }

  void updateBio(
      String value,
      ) {
    String newValue = value.trim();

    if (newValue == userBio.value) {
      return;
    }

    userBio.value = newValue;
  }
}