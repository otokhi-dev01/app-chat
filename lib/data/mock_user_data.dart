import '../../models/user_model.dart';
import 'mock_ids.dart';

class MockUserData {
  static List<AppUserModel> build() {
    DateTime now = DateTime.now();

    return [
      AppUserModel(
        id: MockIds.currentUserId,
        username: 'vuthul',
        name: 'Vuthul Vun',
        phoneNumber: '+855 12 345 678',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_001',
        bio: 'Flutter developer',
        isOnline: true,
        lastSeenAt: now,
      ),
      AppUserModel(
        id: MockIds.alexUserId,
        username: 'alex_morgan',
        name: 'Alex Morgan',
        phoneNumber: '+855 96 222 1111',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_002',
        bio: 'Mobile UI designer',
        isOnline: true,
        lastSeenAt: now,
      ),
      AppUserModel(
        id: MockIds.amandaUserId,
        username: 'amanda_lee',
        name: 'Amanda Lee',
        phoneNumber: '+855 10 444 222',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_003',
        bio: 'Backend developer',
        isOnline: false,
        lastSeenAt: now.subtract(
          Duration(minutes: 25),
        ),
      ),
      AppUserModel(
        id: MockIds.brianUserId,
        username: 'brian_cooper',
        name: 'Brian Cooper',
        phoneNumber: '+855 70 555 333',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_004',
        bio: 'Project manager',
        isOnline: false,
        lastSeenAt: now.subtract(
          Duration(hours: 3),
        ),
      ),
      AppUserModel(
        id: MockIds.chloeUserId,
        username: 'chloe_bennett',
        name: 'Chloe Bennett',
        phoneNumber: '+855 12 555 001',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_005',
        bio: 'Product designer',
        isOnline: true,
        lastSeenAt: now,
      ),
      AppUserModel(
        id: MockIds.danielUserId,
        username: 'daniel_kim',
        name: 'Daniel Kim',
        phoneNumber: '+855 15 555 002',
        avatarUrl:
        'https://i.pravatar.cc/300?u=user_006',
        bio: 'Mobile developer',
        isOnline: false,
        lastSeenAt: now.subtract(
          Duration(hours: 7),
        ),
      ),
    ];
  }
}