import 'package:get/get.dart';

import '../../controllers/contact/contact_controller.dart';
import '../../services/contact_service/contact_service.dart';
import '../../services/mock/mock_contact_service.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactService>(
          () => MockContactService(),
      fenix: true,
    );

    Get.lazyPut<ContactController>(
          () => ContactController(
        contactService:
        Get.find<ContactService>(),
      ),
      fenix: true,
    );
  }
}