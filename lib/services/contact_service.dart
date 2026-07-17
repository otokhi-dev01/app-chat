import '../../models/contact_model.dart';

abstract class ContactService {
  Future<List<ContactModel>> getContacts();

  Future<ContactModel?> getContactById(
      String contactId,
      );

  Future<ContactModel?> addContactByUserId(
      String userId,
      );

  Future<ContactModel> addManualContact({
    required String name,
    required String phoneNumber,
  });

  Future<void> removeContact(
      String contactId,
      );

  Future<ContactModel?> toggleFavorite(
      String contactId,
      );

  Future<ContactModel?> updateBlocked({
    required String contactId,
    required bool isBlocked,
  });
}