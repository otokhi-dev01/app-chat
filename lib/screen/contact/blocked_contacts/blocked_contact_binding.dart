import 'package:get/get.dart';

import '../../../controllers/contact/blocked_contact_controller.dart';
import '../../../services/blocked_contacts_service.dart';
import '../../../services/mock/mock_blocked_contact_service.dart';

class BlockedContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlockedContactsService>(
          () => MockBlockedContactService(),
    );

    Get.lazyPut<BlockedContactController>(
          () => BlockedContactController(
        service:
        Get.find<BlockedContactsService>(),
      ),
    );
  }
}