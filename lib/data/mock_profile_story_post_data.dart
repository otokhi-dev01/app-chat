import '../models/profile_story_post_model.dart';

class MockProfileStoryPostData {
  static ProfileStoryItem get myStory {
    return ProfileStoryItem(
      id: 'my_story_001',
      name: 'My Story',
      imageUrl:
      'https://picsum.photos/500/800?random=201',
      isViewed: false,
      isMyStory: true,
    );
  }

  static List<ProfilePostItem> get posts {
    return <ProfilePostItem>[
      ProfilePostItem(
        id: 'post_001',
        imageUrl:
        'https://picsum.photos/600/600?random=101',
        isArchived: false,
        viewCount: 125,
      ),
      ProfilePostItem(
        id: 'post_002',
        imageUrl:
        'https://picsum.photos/600/600?random=102',
        isArchived: false,
        viewCount: 89,
      ),
      ProfilePostItem(
        id: 'post_003',
        imageUrl:
        'https://picsum.photos/600/600?random=103',
        isArchived: false,
        viewCount: 64,
      ),
      ProfilePostItem(
        id: 'post_004',
        imageUrl:
        'https://picsum.photos/600/600?random=104',
        isArchived: false,
        viewCount: 230,
      ),
      ProfilePostItem(
        id: 'post_005',
        imageUrl:
        'https://picsum.photos/600/600?random=105',
        isArchived: false,
        viewCount: 47,
      ),
      ProfilePostItem(
        id: 'post_006',
        imageUrl:
        'https://picsum.photos/600/600?random=106',
        isArchived: false,
        viewCount: 96,
      ),
      ProfilePostItem(
        id: 'post_007',
        imageUrl:
        'https://picsum.photos/600/600?random=107',
        isArchived: true,
        viewCount: 42,
      ),
      ProfilePostItem(
        id: 'post_008',
        imageUrl:
        'https://picsum.photos/600/600?random=108',
        isArchived: true,
        viewCount: 31,
      ),
      ProfilePostItem(
        id: 'post_009',
        imageUrl:
        'https://picsum.photos/600/600?random=109',
        isArchived: true,
        viewCount: 73,
      ),
    ];
  }
}