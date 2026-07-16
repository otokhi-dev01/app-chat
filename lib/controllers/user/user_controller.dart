import 'package:get/get.dart';

class UserController extends GetxController {
  final RxBool isFollowing = false.obs;

  final RxString name =
      'Alex Mercer'.obs;

  final RxString status =
      'Online'.obs;

  final RxString phoneNumber =
      '+1 (555) 019-2834'.obs;

  final RxString username =
      '@alex_mercer'.obs;

  final RxString bio =
      'Flutter Developer | Building responsive interfaces.'
          .obs;

  final RxString profileImageUrl =
      'https://picsum.photos/300'.obs;

  void toggleFollow() {
    isFollowing.toggle();
  }
}