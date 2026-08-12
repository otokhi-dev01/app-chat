import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'profile_content_card.dart';

class ProfileMockPostContent extends StatelessWidget {
  ProfileMockPostContent({super.key});

  final posts = <_MockPostItem>[
    _MockPostItem('Weekend trip', 'Beautiful mountain view', CupertinoIcons.photo_fill, 238, [const Color(0xFF4F8DF7), const Color(0xFF86C6FF)]),
    _MockPostItem('Coffee time', 'Starting the day', CupertinoIcons.heart_fill, 174, [const Color(0xFFB77B5A), const Color(0xFFE8B48D)]),
    _MockPostItem('New workspace', 'Simple and productive', CupertinoIcons.desktopcomputer, 312, [const Color(0xFF7C6CF2), const Color(0xFFB19CFF)]),
    _MockPostItem('City walk', 'Exploring new places', CupertinoIcons.building_2_fill, 421, [const Color(0xFF4F6272), const Color(0xFF92A6B8)]),
    _MockPostItem('Healthy meal', 'Fresh and delicious', CupertinoIcons.bag_fill, 196, [const Color(0xFF4FAF74), const Color(0xFF90D7A8)]),
    _MockPostItem('Sunset', 'A peaceful evening', CupertinoIcons.sun_max_fill, 503, [const Color(0xFFF2766B), const Color(0xFFFFB36B)]),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (_, index) => _ProfilePostCard(post: posts[index]),
    );
  }
}

class _ProfilePostCard extends StatelessWidget {
  final _MockPostItem post;

  const _ProfilePostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ProfileContentCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: post.gradientColors,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      post.icon,
                      color: Colors.white.withValues(alpha: 0.92),
                      size: 46,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.32),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(CupertinoIcons.eye_fill, color: Colors.white, size: 11),
                          const SizedBox(width: 4),
                          Text(
                            '${post.viewCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  post.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockPostItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final int viewCount;
  final List<Color> gradientColors;

  _MockPostItem(this.title, this.subtitle, this.icon, this.viewCount, this.gradientColors);
}