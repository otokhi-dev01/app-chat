import 'package:get/get.dart';

class UserController extends GetxController {
  final int userId;

  UserController({
    required this.userId,
  });

  final RxBool isLoading = false.obs;
  final RxBool isFollowing = false.obs;

  final RxString name = ''.obs;
  final RxString status = 'Offline'.obs;
  final RxString phoneNumber = ''.obs;
  final RxString username = ''.obs;
  final RxString bio = ''.obs;
  final RxString profileImageUrl = ''.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    loadUserById();
  }

  Future<void> loadUserById() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      /*
      Replace this mock data with your API:

      UserResponse response =
          await userRepository.getUserById(userId);

      name.value = response.name;
      status.value = response.status;
      phoneNumber.value = response.phoneNumber;
      username.value = response.username;
      bio.value = response.bio;
      profileImageUrl.value = response.profileImageUrl;
      isFollowing.value = response.isFollowing;
      */

      await Future<void>.delayed(
        Duration(milliseconds: 500),
      );

      name.value = 'Alex Mercer';
      status.value = 'Online';
      phoneNumber.value = '+1 (555) 019-2834';
      username.value = '@alex_mercer';
      bio.value =
      'Flutter Developer | Building responsive interfaces.';
      profileImageUrl.value =
      'https://picsum.photos/300';
      isFollowing.value = false;
    } catch (error) {
      errorMessage.value =
      'Could not load user profile: $error';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFollow() {
    isFollowing.toggle();

    // Call your follow/unfollow API here.
  }
}