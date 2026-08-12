import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileMockMediaContent extends StatelessWidget {
  ProfileMockMediaContent({super.key});

  final mediaItems = <_MockMediaItem>[
    _MockMediaItem(CupertinoIcons.camera_fill, 'photo'.tr, '', [const Color(0xFF4F8DF7), const Color(0xFF83C7FF)]),
    _MockMediaItem(CupertinoIcons.play_fill, 'video'.tr, '0:24', [const Color(0xFF6F61E8), const Color(0xFFAF9CFF)]),
    _MockMediaItem(CupertinoIcons.photo_fill, 'photo'.tr, '', [const Color(0xFF47A66D), const Color(0xFF91D6A9)]),
    _MockMediaItem(CupertinoIcons.play_fill, 'video'.tr, '1:05', [const Color(0xFFE36B6B), const Color(0xFFFFA86A)]),
    _MockMediaItem(CupertinoIcons.photo_on_rectangle, 'album'.tr, '8', [const Color(0xFF52616E), const Color(0xFF96AAB9)]),
    _MockMediaItem(CupertinoIcons.play_fill, 'video'.tr, '0:42', [const Color(0xFFAF7455), const Color(0xFFE6B28B)]),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: mediaItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, index) => _ProfileMediaCard(media: mediaItems[index]),
    );
  }
}

class _ProfileMediaCard extends StatelessWidget {
  final _MockMediaItem media;

  const _ProfileMediaCard({required this.media});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: media.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Center(child: Icon(media.icon, color: Colors.white.withValues(alpha: 0.94), size: 32)),
          Positioned(
            left: 7,
            bottom: 7,
            child: Text(
              media.label,
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
            ),
          ),
          if (media.duration.isNotEmpty)
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.38),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  media.duration,
                  style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MockMediaItem {
  final IconData icon;
  final String label;
  final String duration;
  final List<Color> gradientColors;

  _MockMediaItem(this.icon, this.label, this.duration, this.gradientColors);
}