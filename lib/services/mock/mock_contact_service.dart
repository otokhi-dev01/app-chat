import '../../../models/contact_model.dart';
import '../../../models/user_model.dart';
import '../../data/mock_chat_database.dart';
import '../contact_service.dart';
import 'mock_service_delay.dart';

class MockContactService
    with MockServiceDelay
    implements ContactService {
  @override
  Future<List<ContactModel>>
  getContacts() async {
    await simulateDelay();

    List<ContactModel> result =
    MockChatDatabase.contacts.toList();

    result.sort(
          (
          ContactModel first,
          ContactModel second,
          ) {
        return first.name
            .toLowerCase()
            .compareTo(
          second.name.toLowerCase(),
        );
      },
    );

    return result;
  }

  @override
  Future<ContactModel?> getContactById(
      String contactId,
      ) async {
    await simulateDelay();

    return MockChatDatabase.findContactById(
      contactId,
    );
  }

  @override
  Future<ContactModel?> addContactByUserId(
      String userId,
      ) async {
    await simulateDelay();

    ContactModel? existingContact =
    MockChatDatabase.findContactById(
      userId,
    );

    if (existingContact != null) {
      return existingContact;
    }

    AppUserModel? user =
    MockChatDatabase.findUserById(userId);

    if (user == null ||
        user.id ==
            MockChatDatabase.currentUserId) {
      return null;
    }

    ContactModel contact = ContactModel(
      id: user.id,
      name: user.name,
      username:
      _formatUsername(user.username),
      phoneNumber: user.phoneNumber,
      avatarUrl: user.avatarUrl,
      status: user.isOnline
          ? ContactStatus.online
          : ContactStatus.offline,
      isFavorite: false,
      isBlocked: false,
    );

    MockChatDatabase.contacts.add(contact);

    return contact;
  }

  @override
  Future<ContactModel> addManualContact({
    required String name,
    required String phoneNumber,
  }) async {
    String cleanName = name.trim();
    String cleanPhone =
    phoneNumber.trim();

    if (cleanName.isEmpty ||
        cleanPhone.isEmpty) {
      throw ArgumentError(
        'Name and phone number are required.',
      );
    }

    bool phoneExists =
    MockChatDatabase.contacts.any(
          (ContactModel contact) {
        return _normalizePhone(
          contact.phoneNumber,
        ) ==
            _normalizePhone(cleanPhone);
      },
    );

    if (phoneExists) {
      throw StateError(
        'This phone number already exists.',
      );
    }

    String timestamp = DateTime.now()
        .microsecondsSinceEpoch
        .toString();

    String contactId =
        'local_contact_$timestamp';

    ContactModel contact = ContactModel(
      id: contactId,
      name: cleanName,
      username:
      _generateUsername(cleanName),
      phoneNumber: cleanPhone,
      avatarUrl:
      'https://i.pravatar.cc/300?u=$contactId',
      status: ContactStatus.offline,
      isFavorite: false,
      isBlocked: false,
    );

    MockChatDatabase.contacts.add(contact);

    return contact;
  }

  @override
  Future<void> removeContact(
      String contactId,
      ) async {
    await simulateDelay();

    MockChatDatabase.contacts.removeWhere(
          (ContactModel contact) {
        return contact.id == contactId;
      },
    );
  }

  @override
  Future<ContactModel?> toggleFavorite(
      String contactId,
      ) async {
    await simulateDelay();

    int index =
    MockChatDatabase.contacts.indexWhere(
          (ContactModel contact) {
        return contact.id == contactId;
      },
    );

    if (index < 0) {
      return null;
    }

    ContactModel contact =
    MockChatDatabase.contacts[index];

    ContactModel updated =
    contact.copyWith(
      isFavorite: !contact.isFavorite,
    );

    MockChatDatabase.contacts[index] =
        updated;

    return updated;
  }

  @override
  Future<ContactModel?> updateBlocked({
    required String contactId,
    required bool isBlocked,
  }) async {
    await simulateDelay();

    int index =
    MockChatDatabase.contacts.indexWhere(
          (ContactModel contact) {
        return contact.id == contactId;
      },
    );

    if (index < 0) {
      return null;
    }

    ContactModel updated =
    MockChatDatabase.contacts[index]
        .copyWith(
      isBlocked: isBlocked,
    );

    MockChatDatabase.contacts[index] =
        updated;

    return updated;
  }

  String _formatUsername(
      String username,
      ) {
    String cleanUsername = username.trim();

    if (cleanUsername.isEmpty) {
      return '';
    }

    if (cleanUsername.startsWith('@')) {
      return cleanUsername;
    }

    return '@$cleanUsername';
  }

  String _generateUsername(
      String name,
      ) {
    String username = name
        .trim()
        .toLowerCase()
        .replaceAll(
      RegExp(r'[^a-z0-9\s_]'),
      '',
    )
        .replaceAll(
      RegExp(r'\s+'),
      '_',
    );

    return '@$username';
  }

  String _normalizePhone(
      String phoneNumber,
      ) {
    return phoneNumber.replaceAll(
      RegExp(r'[^0-9+]'),
      '',
    );
  }
}