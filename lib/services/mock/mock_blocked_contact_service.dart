import '../../models/blocked_contact_model.dart';
import '../blocked_contacts_service.dart';

class MockBlockedContactService
    implements BlockedContactsService {
  final List<BlockedContactModel> _blockedContacts = [
    BlockedContactModel(
      id: '1',
      name: 'Alex Morgan',
      username: '@alex_m',
    ),
    BlockedContactModel(
      id: '2',
      name: 'Sarah Connor',
      username: '@sarah_c',
    ),
    BlockedContactModel(
      id: '3',
      name: 'David Beckham',
      username: '@david_b',
    ),
  ];

  @override
  List<BlockedContactModel> getBlockedContacts() {
    return List<BlockedContactModel>.from(
      _blockedContacts,
    );
  }

  @override
  Future<void> unblockContact({
    required String contactId,
  }) async {
    await Future<void>.delayed(
      Duration(
        milliseconds: 350,
      ),
    );

    _blockedContacts.removeWhere(
          (BlockedContactModel contact) {
        return contact.id == contactId;
      },
    );
  }
}