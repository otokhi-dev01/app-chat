import '../../models/contact_model.dart';
import 'mock_ids.dart';

class MockContactData {
  static List<ContactModel> build() {
    return [
      ContactModel(
        id: MockIds.alexUserId,
        name: 'Alex Morgan',
        username: '@alex_morgan',
        phoneNumber: '+855 96 222 1111',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_002',
        status: ContactStatus.online,
        isFavorite: true,
        isBlocked: false,
      ),
      ContactModel(
        id: MockIds.amandaUserId,
        name: 'Amanda Lee',
        username: '@amanda_lee',
        phoneNumber: '+855 10 444 222',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_003',
        status: ContactStatus.recently,
        isFavorite: false,
        isBlocked: false,
      ),
      ContactModel(
        id: MockIds.brianUserId,
        name: 'Brian Cooper',
        username: '@brian_cooper',
        phoneNumber: '+855 70 555 333',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_004',
        status: ContactStatus.offline,
        isFavorite: false,
        isBlocked: false,
      ),
      ContactModel(
        id: MockIds.chloeUserId,
        name: 'Chloe Bennett',
        username: '@chloe_bennett',
        phoneNumber: '+855 12 555 001',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_005',
        status: ContactStatus.online,
        isFavorite: true,
        isBlocked: false,
      ),
      ContactModel(
        id: MockIds.danielUserId,
        name: 'Daniel Kim',
        username: '@daniel_kim',
        phoneNumber: '+855 15 555 002',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_006',
        status: ContactStatus.offline,
        isFavorite: false,
        isBlocked: false,
      ),
    ];
  }
}