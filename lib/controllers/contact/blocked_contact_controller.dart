import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../models/blocked_contact_model.dart';
import '../../services/blocked_contact_service/blocked_contacts_service.dart';

class BlockedContactController
    extends GetxController {
  final BlockedContactsService service;

  BlockedContactController({
    required this.service,
  });

  final RxList<BlockedContactModel>
  blockedContacts =
      <BlockedContactModel>[].obs;

  final RxSet<String> unblockingContactIds =
      <String>{}.obs;

  @override
  void onInit() {
    super.onInit();

    loadBlockedContacts();
  }

  void loadBlockedContacts() {
    blockedContacts.assignAll(
      service.getBlockedContacts(),
    );
  }

  bool isUnblocking(
      String contactId,
      ) {
    return unblockingContactIds.contains(
      contactId,
    );
  }

  Future<bool> unblockContact(
      BlockedContactModel contact,
      ) async {
    if (isUnblocking(contact.id)) {
      return false;
    }

    unblockingContactIds.add(
      contact.id,
    );

    try {
      await service.unblockContact(
        contactId: contact.id,
      );

      blockedContacts.removeWhere(
            (BlockedContactModel item) {
          return item.id == contact.id;
        },
      );

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        'Unable to unblock contact: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return false;
    } finally {
      unblockingContactIds.remove(
        contact.id,
      );
    }
  }
}