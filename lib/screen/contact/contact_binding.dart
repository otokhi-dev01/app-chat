import 'package:get/get.dart';

import '../../controllers/contact/contact_controller.dart';
import '../../services/contact_service/contact_api_service.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(
          () => ContactController(
        contactApiService:
        Get.find<ContactApiService>(),
      ),
      fenix: true,
    );
  }
}