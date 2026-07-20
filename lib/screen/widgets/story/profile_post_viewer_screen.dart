import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/profile_story_post_model.dart';

class ProfilePostViewerScreen extends StatelessWidget {
  final ProfilePostItem post;

  ProfilePostViewerScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery =
    MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.network(
                  post.imageUrl,
                  width: mediaQuery.size.width,
                  height: mediaQuery.size.height,
                  fit: BoxFit.contain,
                  filterQuality:
                  FilterQuality.high,
                  loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent?
                      loadingProgress,
                      ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    double? progress;

                    int? totalBytes =
                        loadingProgress
                            .expectedTotalBytes;

                    if (totalBytes != null &&
                        totalBytes > 0) {
                      progress = loadingProgress
                          .cumulativeBytesLoaded /
                          totalBytes;
                    }

                    return Center(
                      child:
                      CircularProgressIndicator(
                        value: progress,
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    );
                  },
                  errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                      ) {
                    return _ImageErrorState();
                  },
                ),
              ),
            ),
          ),

          Positioned(
            top: mediaQuery.padding.top + 10,
            left: 12,
            child: _ViewerButton(
              icon: Icons.close_rounded,
              onTap: () {
                Get.back();
              },
            ),
          ),

          Positioned(
            top: mediaQuery.padding.top + 10,
            right: 12,
            child: _ViewerButton(
              icon: Icons.more_horiz_rounded,
              onTap: () {
                _showPostOptions(context);
              },
            ),
          ),

          Positioned(
            left: 14,
            right: 14,
            bottom: mediaQuery.padding.bottom + 14,
            child: _PostInformation(
              post: post,
            ),
          ),
        ],
      ),
    );
  }

  void _showPostOptions(
      BuildContext context,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color sheetColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Get.bottomSheet(
      SafeArea(
        child: Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius:
            BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OptionTile(
                icon: post.isArchived
                    ? Icons
                    .unarchive_outlined
                    : Icons.archive_outlined,
                title: post.isArchived
                    ? 'Restore post'
                    : 'Archive post',
                onTap: () {
                  Get.back();
                },
              ),
              _OptionTile(
                icon: Icons
                    .download_outlined,
                title: 'Save image',
                onTap: () {
                  Get.back();
                },
              ),
              _OptionTile(
                icon: Icons.delete_outline_rounded,
                title: 'Delete post',
                color: colorScheme.error,
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _PostInformation
    extends StatelessWidget {
  final ProfilePostItem post;

  _PostInformation({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 34,
          padding: EdgeInsets.symmetric(
            horizontal: 11,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: 0.55,
            ),
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                '${post.viewCount}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        if (post.isArchived)
          Container(
            height: 34,
            padding: EdgeInsets.symmetric(
              horizontal: 11,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: 0.55,
              ),
              borderRadius:
              BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.10,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.archive_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                SizedBox(width: 6),
                Text(
                  'Archived',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ViewerButton
    extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  _ViewerButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(
        alpha: 0.48,
      ),
      shape: CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: CircleBorder(),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            color: Colors.white,
            size: 23,
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback onTap;

  _OptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    Color contentColor =
        color ?? colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: contentColor,
                size: 22,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: theme
                      .textTheme.bodyLarge
                      ?.copyWith(
                    color: contentColor,
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageErrorState
    extends StatelessWidget {
  _ImageErrorState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.broken_image_outlined,
          color: Colors.white70,
          size: 52,
        ),
        SizedBox(height: 12),
        Text(
          'Unable to load this post',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}