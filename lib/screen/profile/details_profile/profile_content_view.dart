import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_content_filter.dart';

class ProfileContentView extends StatelessWidget {
  final ProfileContentFilterType selectedFilter;

  final Widget? postsContent;
  final Widget? mediaContent;
  final Widget? linksContent;
  final Widget? filesContent;
  final Widget? voiceContent;

  ProfileContentView({
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

class ProfileMockPostContent extends StatelessWidget {
  ProfileMockPostContent({
    super.key,
  });

  final List<_MockPostItem> posts = <_MockPostItem>[
    _MockPostItem(
      title: 'Weekend trip',
      subtitle: 'Beautiful mountain view',
      icon: CupertinoIcons.photo_fill,
      viewCount: 238,
      gradientColors: <Color>[
        Color(0xFF4F8DF7),
        Color(0xFF86C6FF),
      ],
    ),
    _MockPostItem(
      title: 'Coffee time',
      subtitle: 'Starting the day',
      icon: CupertinoIcons.heart_fill,
      viewCount: 174,
      gradientColors: <Color>[
        Color(0xFFB77B5A),
        Color(0xFFE8B48D),
      ],
    ),
    _MockPostItem(
      title: 'New workspace',
      subtitle: 'Simple and productive',
      icon: CupertinoIcons.desktopcomputer,
      viewCount: 312,
      gradientColors: <Color>[
        Color(0xFF7C6CF2),
        Color(0xFFB19CFF),
      ],
    ),
    _MockPostItem(
      title: 'City walk',
      subtitle: 'Exploring new places',
      icon: CupertinoIcons.building_2_fill,
      viewCount: 421,
      gradientColors: <Color>[
        Color(0xFF4F6272),
        Color(0xFF92A6B8),
      ],
    ),
    _MockPostItem(
      title: 'Healthy meal',
      subtitle: 'Fresh and delicious',
      icon: CupertinoIcons.bag_fill,
      viewCount: 196,
      gradientColors: <Color>[
        Color(0xFF4FAF74),
        Color(0xFF90D7A8),
      ],
    ),
    _MockPostItem(
      title: 'Sunset',
      subtitle: 'A peaceful evening',
      icon: CupertinoIcons.sun_max_fill,
      viewCount: 503,
      gradientColors: <Color>[
        Color(0xFFF2766B),
        Color(0xFFFFB36B),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (
          BuildContext context,
          int index,
          ) {
        return _ProfilePostCard(
          post: posts[index],
        );
      },
    );
  }
}

class _ProfilePostCard extends StatelessWidget {
  final _MockPostItem post;

  _ProfilePostCard({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
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
                      color: Colors.white.withValues(
                        alpha: 0.92,
                      ),
                      size: 46,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(
                          alpha: 0.32,
                        ),
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.eye_fill,
                            color: Colors.white,
                            size: 11,
                          ),
                          SizedBox(width: 4),
                          Text(
                            post.viewCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
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
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  post.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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

class ProfileMockMediaContent extends StatelessWidget {
  ProfileMockMediaContent({
    super.key,
  });

  final List<_MockMediaItem> mediaItems = <_MockMediaItem>[
    _MockMediaItem(
      icon: CupertinoIcons.camera_fill,
      label: 'photo'.tr,
      duration: '',
      gradientColors: <Color>[
        Color(0xFF4F8DF7),
        Color(0xFF83C7FF),
      ],
    ),
    _MockMediaItem(
      icon: CupertinoIcons.play_fill,
      label: 'video'.tr,
      duration: '0:24',
      gradientColors: <Color>[
        Color(0xFF6F61E8),
        Color(0xFFAF9CFF),
      ],
    ),
    _MockMediaItem(
      icon: CupertinoIcons.photo_fill,
      label: 'photo'.tr,
      duration: '',
      gradientColors: <Color>[
        Color(0xFF47A66D),
        Color(0xFF91D6A9),
      ],
    ),
    _MockMediaItem(
      icon: CupertinoIcons.play_fill,
      label: 'video'.tr,
      duration: '1:05',
      gradientColors: <Color>[
        Color(0xFFE36B6B),
        Color(0xFFFFA86A),
      ],
    ),
    _MockMediaItem(
      icon: CupertinoIcons.photo_on_rectangle,
      label: 'album'.tr,
      duration: '8',
      gradientColors: <Color>[
        Color(0xFF52616E),
        Color(0xFF96AAB9),
      ],
    ),
    _MockMediaItem(
      icon: CupertinoIcons.play_fill,
      label: 'video'.tr,
      duration: '0:42',
      gradientColors: <Color>[
        Color(0xFFAF7455),
        Color(0xFFE6B28B),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: mediaItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemBuilder: (
          BuildContext context,
          int index,
          ) {
        return _ProfileMediaCard(
          media: mediaItems[index],
        );
      },
    );
  }
}

class _ProfileMediaCard extends StatelessWidget {
  final _MockMediaItem media;

  _ProfileMediaCard({
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: media.gradientColors,
        ),
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Center(
            child: Icon(
              media.icon,
              color: Colors.white.withValues(
                alpha: 0.94,
              ),
              size: 32,
            ),
          ),
          Positioned(
            left: 7,
            bottom: 7,
            child: Text(
              media.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (media.duration.isNotEmpty)
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: 0.38,
                  ),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Text(
                  media.duration,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProfileMockLinkContent extends StatelessWidget {
  ProfileMockLinkContent({
    super.key,
  });

  final List<_MockLinkItem> links = <_MockLinkItem>[
    _MockLinkItem(
      title: 'Flutter documentation',
      url: 'docs.flutter.dev',
      description: 'Build beautiful multiplatform apps.',
      icon: CupertinoIcons.link,
    ),
    _MockLinkItem(
      title: 'Project design',
      url: 'figma.com/piitsiitchat',
      description: 'Latest PiitsiitChat UI design.',
      icon: CupertinoIcons.square_pencil,
    ),
    _MockLinkItem(
      title: 'Project repository',
      url: 'github.com/piitsiitchat',
      description: 'Source code and project updates.',
      icon: CupertinoIcons.text_quote,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        links.length,
            (int index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == links.length - 1 ? 0 : 8,
            ),
            child: _ProfileLinkCard(
              link: links[index],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileLinkCard extends StatelessWidget {
  final _MockLinkItem link;

  _ProfileLinkCard({
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.11,
              ),
              borderRadius: BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              link.icon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  link.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  link.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.arrow_up_right,
            color: colorScheme.onSurfaceVariant,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class ProfileMockFileContent extends StatelessWidget {
  ProfileMockFileContent({
    super.key,
  });

  final List<_MockFileItem> files = <_MockFileItem>[
    _MockFileItem(
      name: 'Project proposal.pdf',
      size: '3.8 MB',
      date: 'Today, 9:42 AM',
      icon: CupertinoIcons.doc_fill,
    ),
    _MockFileItem(
      name: 'UI design assets.zip',
      size: '18.2 MB',
      date: 'Yesterday',
      icon: CupertinoIcons.archivebox_fill,
    ),
    _MockFileItem(
      name: 'Meeting notes.docx',
      size: '842 KB',
      date: 'Jul 20',
      icon: CupertinoIcons.doc_text_fill,
    ),
    _MockFileItem(
      name: 'Budget report.xlsx',
      size: '1.4 MB',
      date: 'Jul 18',
      icon: CupertinoIcons.table_fill,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        files.length,
            (int index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == files.length - 1 ? 0 : 8,
            ),
            child: _ProfileFileCard(
              file: files[index],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileFileCard extends StatelessWidget {
  final _MockFileItem file;

  _ProfileFileCard({
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.11,
              ),
              borderRadius: BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              file.icon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${file.size} • ${file.date}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.arrow_down_to_line,
            color: colorScheme.primary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class ProfileMockVoiceContent extends StatelessWidget {
  ProfileMockVoiceContent({
    super.key,
  });

  final List<_MockVoiceItem> voiceMessages = <_MockVoiceItem>[
    _MockVoiceItem(
      duration: '0:18',
      date: 'Today, 10:14 AM',
      progress: 0.72,
    ),
    _MockVoiceItem(
      duration: '0:42',
      date: 'Yesterday, 4:36 PM',
      progress: 0.38,
    ),
    _MockVoiceItem(
      duration: '1:05',
      date: 'Jul 21, 11:05 AM',
      progress: 0.56,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        voiceMessages.length,
            (int index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == voiceMessages.length - 1 ? 0 : 8,
            ),
            child: _ProfileVoiceCard(
              voice: voiceMessages[index],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileVoiceCard extends StatelessWidget {
  final _MockVoiceItem voice;

  _ProfileVoiceCard({
    required this.voice,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.play_fill,
              color: colorScheme.onPrimary,
              size: 20,
            ),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        child: LinearProgressIndicator(
                          value: voice.progress,
                          minHeight: 4,
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      voice.duration,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7),
                Text(
                  voice.date,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(
            CupertinoIcons.ellipsis,
            color: colorScheme.onSurfaceVariant,
            size: 18,
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

  _MockPostItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.viewCount,
    required this.gradientColors,
  });
}

class _MockMediaItem {
  final IconData icon;
  final String label;
  final String duration;
  final List<Color> gradientColors;

  _MockMediaItem({
    required this.icon,
    required this.label,
    required this.duration,
    required this.gradientColors,
  });
}

class _MockLinkItem {
  final String title;
  final String url;
  final String description;
  final IconData icon;

  _MockLinkItem({
    required this.title,
    required this.url,
    required this.description,
    required this.icon,
  });
}

class _MockFileItem {
  final String name;
  final String size;
  final String date;
  final IconData icon;

  _MockFileItem({
    required this.name,
    required this.size,
    required this.date,
    required this.icon,
  });
}

class _MockVoiceItem {
  final String duration;
  final String date;
  final double progress;

  _MockVoiceItem({
    required this.duration,
    required this.date,
    required this.progress,
  });
}