class ProfileStoryItem {
  final String id;
  final String name;
  final String imageUrl;
  final bool isViewed;
  final bool isMyStory;

  ProfileStoryItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.isViewed = false,
    this.isMyStory = false,
  });

  ProfileStoryItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    bool? isViewed,
    bool? isMyStory,
  }) {
    return ProfileStoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isViewed: isViewed ?? this.isViewed,
      isMyStory: isMyStory ?? this.isMyStory,
    );
  }
}

class ProfilePostItem {
  final String id;
  final String imageUrl;
  final bool isArchived;
  final int viewCount;

  ProfilePostItem({
    required this.id,
    required this.imageUrl,
    required this.isArchived,
    this.viewCount = 0,
  });

  ProfilePostItem copyWith({
    String? id,
    String? imageUrl,
    bool? isArchived,
    int? viewCount,
  }) {
    return ProfilePostItem(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      isArchived: isArchived ?? this.isArchived,
      viewCount: viewCount ?? this.viewCount,
    );
  }
}