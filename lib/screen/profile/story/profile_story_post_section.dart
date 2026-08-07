import 'package:flutter/material.dart';

import '../../../models/profile_story_post_model.dart';
import 'profile_post_filter.dart';
import 'profile_post_grid.dart';

class ProfileStoryPostSection extends StatefulWidget {
  final List<ProfilePostItem> posts;
  final ValueChanged<ProfilePostItem>? onPostTap;

  const ProfileStoryPostSection({
    super.key,
    required this.posts,
    this.onPostTap,
  });

  @override
  State<ProfileStoryPostSection> createState() {
    return _ProfileStoryPostSectionState();
  }
}

class _ProfileStoryPostSectionState extends State<ProfileStoryPostSection> {
  bool showArchived = false;

  List<ProfilePostItem> get activePosts {
    return widget.posts.where(
          (ProfilePostItem post) {
        return !post.isArchived;
      },
    ).toList(
      growable: false,
    );
  }

  List<ProfilePostItem> get archivedPosts {
    return widget.posts.where(
          (ProfilePostItem post) {
        return post.isArchived;
      },
    ).toList(
      growable: false,
    );
  }

  void _changeFilter(bool archived) {
    if (showArchived == archived) {
      return;
    }

    setState(() {
      showArchived = archived;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    List<ProfilePostItem> visiblePosts =
    showArchived ? archivedPosts : activePosts;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfilePostFilter(
            showArchived: showArchived,
            onChanged: _changeFilter,
          ),
          ProfilePostGrid(
            posts: visiblePosts,
            showArchived: showArchived,
            onPostTap: widget.onPostTap,
          ),
        ],
      ),
    );
  }
}