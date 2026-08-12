import 'package:flutter/material.dart';

import 'content_filter/profile_file_content.dart';
import 'content_filter/profile_link_content.dart';
import 'content_filter/profile_media_content.dart';
import 'content_filter/profile_post_content.dart';
import 'content_filter/profile_voice_content.dart';
import 'profile_content_filter.dart';

class ProfileContentView extends StatelessWidget {
  final ProfileContentFilterType selectedFilter;
  final Widget? postsContent;
  final Widget? mediaContent;
  final Widget? linksContent;
  final Widget? filesContent;
  final Widget? voiceContent;

  const ProfileContentView({
    super.key,
    required this.selectedFilter,
    this.postsContent,
    this.mediaContent,
    this.linksContent,
    this.filesContent,
    this.voiceContent,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedFilter) {
      case ProfileContentFilterType.posts:
        return postsContent ?? ProfileMockPostContent();
      case ProfileContentFilterType.media:
        return mediaContent ?? ProfileMockMediaContent();
      case ProfileContentFilterType.links:
        return linksContent ?? ProfileMockLinkContent();
      case ProfileContentFilterType.files:
        return filesContent ?? ProfileMockFileContent();
      case ProfileContentFilterType.voice:
        return voiceContent ?? ProfileMockVoiceContent();
    }
  }
}
