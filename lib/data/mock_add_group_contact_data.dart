import '../models/contact_model.dart';

class MockAddGroupContactData {
  static List<ContactModel> get contacts {
    return <ContactModel>[
      ContactModel(
        id: 'contact_001',
        name: 'Sok Dara',
        username: '@sokdara',
        phoneNumber: '+855 12 345 678',
        avatarUrl:
        'https://i.pravatar.cc/300?u=contact_001',
        status: ContactStatus.online,
        isFavorite: true,
        isBlocked: false,
      ),
      ContactModel(
        id: 'contact_002',
        name: 'Chan Vannak',
        username: '@vannak',
        phoneNumber: '+855 10 112 233',
        avatarUrl:
        'https://i.pravatar.cc/300?u=contact_002',
        status: ContactStatus.recently,
        isFavorite: false,
        isBlocked: false,
      ),
      ContactModel(
        id: 'contact_003',
        name: 'Srey Mom',
        username: '@sreymom',
        phoneNumber: '+855 15 998 877',
        avatarUrl:
        'https://i.pravatar.cc/300?u=contact_003',
        status: ContactStatus.online,
        isFavorite: true,
        isBlocked: false,
      ),
      ContactModel(
        id: 'contact_004',
        name: 'Piseth Heng',
        username: '@piseth',
        phoneNumber: '+855 11 774 411',
        avatarUrl:
        'https://i.pravatar.cc/300?u=contact_004',
        status: ContactStatus.offline,
        isFavorite: false,
        isBlocked: false,
      ),
      ContactModel(
        id: 'contact_005',
        name: 'Nita Long',
        username: '@nita',
        phoneNumber: '+855 96 445 566',
        avatarUrl:
        'https://i.pravatar.cc/300?u=contact_005',
        status: ContactStatus.online,
        isFavorite: false,
        isBlocked: false,
      ),
      ContactModel(
        id: 'contact_006',
        name: 'Rithy Kim',
        username: '@rithy',
        phoneNumber: '+855 70 222 333',
        avatarUrl:
        'https://i.pravatar.cc/300?u=contact_006',
        status: ContactStatus.recently,
        isFavorite: false,
        isBlocked: false,
      ),
      ContactModel(
        id: 'contact_007',
        name: 'Sophea Meas',
        username: '@sophea',
        phoneNumber: '+855 88 888 111',
        avatarUrl:
        'https://i.pravatar.cc/300?u=contact_007',
        status: ContactStatus.offline,
        isFavorite: false,
        isBlocked: false,
      ),
      ContactModel(
        id: 'contact_008',
        name: 'Davy Chhun',
        username: '@davy',
        phoneNumber: '+855 92 444 555',
        avatarUrl:
        'https://i.pravatar.cc/300?u=contact_008',
        status: ContactStatus.online,
        isFavorite: true,
        isBlocked: false,
      ),
    ];
  }
}