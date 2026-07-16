import 'package:get/get.dart';

import '../../../controllers/contact/qr_contact_scanner_controller.dart';

class QrContactScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrContactScannerController>(
          () => QrContactScannerController(),
    );
  }
}