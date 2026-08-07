import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/profile_story_post_model.dart';

class ProfilePostGrid extends StatelessWidget {
  final List<ProfilePostItem> posts;
  final bool showArchived;
  final ValueChanged<ProfilePostItem>? onPostTap;

  const ProfilePostGrid({
    super.key,
    required this.posts,
    required this.showArchived,
    this.onPostTap,
  });

  int _columnCount(double width) {
    if (width >= 900) {
      return 5;
    }

    if (width >= 600) {
      return 4;
    }

    return 3;
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return _EmptyPostState(
        showArchived: showArchived,
      );
    }

    return LayoutBuilder(
      builder: (
          BuildContext context,
          BoxConstraints constraints,
          ) {
        return GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(6),
          itemCount: posts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _columnCount(constraints.maxWidth),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1,
          ),
          itemBuilder: (
              BuildContext context,
              int index,
              ) {
            ProfilePostItem post = posts[index];

            return _PostItem(
              post: post,
              onTap: () {
                onPostTap?.call(post);
              },
            );
          },
        );
      },
    );
  }
}

class _PostItem extends StatelessWidget {
  final ProfilePostItem post;
  final VoidCallback onTap;

 const _PostItem({
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _PostImage(
              imageUrl: post.imageUrl,
            ),
            if (post.isArchived)
              Positioned(
                top: 6,
                right: 6,
                child: _OverlayBadge(
                  icon: CupertinoIcons.archivebox_fill,
                ),
              ),
            if (post.viewCount > 0)
              Positioned(
                left: 6,
                bottom: 6,
                child: _ViewBadge(
                  count: post.viewCount,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OverlayBadge extends StatelessWidget {
  final IconData icon;

 const _OverlayBadge({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.50,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 14,
      ),
    );
  }
}

class _ViewBadge extends StatelessWidget {
  final int count;

 const _ViewBadge({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.50,
        ),
        borderRadius: BorderRadius.circular(12),
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
            '$count',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              height: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPostState extends StatelessWidget {
  final bool showArchived;

  const _EmptyPostState({
    required this.showArchived,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    String title = showArchived ? 'no_archived_posts'.tr : 'no_posts_yet'.tr;

    String subtitle =
    showArchived ? 'archived_posts_hint'.tr : 'new_posts_hint'.tr;

    IconData icon =
    showArchived ? CupertinoIcons.archivebox : CupertinoIcons.photo;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 36,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: 0.11,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          SizedBox(height: 14),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  final String imageUrl;

  const _PostImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget fallback = Container(
      alignment: Alignment.center,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        CupertinoIcons.photo,
        color: colorScheme.onSurfaceVariant,
        size: 26,
      ),
    );

    if (imageUrl.trim().isEmpty) {
      return fallback;
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
          ) {
        return fallback;
      },
    );
  }
}