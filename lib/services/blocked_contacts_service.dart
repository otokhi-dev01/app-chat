
import '../models/blocked_contact_model.dart';

abstract class BlockedContactsService {
  List<BlockedContactModel> getBlockedContacts();

  Future<void> unblockContact({
    required String contactId,
  });
}