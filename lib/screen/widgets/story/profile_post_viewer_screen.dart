import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/profile_story_post_model.dart';

class ProfilePostViewerScreen extends StatelessWidget {
  final ProfilePostItem post;

  const ProfilePostViewerScreen({
    super.key,
    required this.post,
  });

  void _showPostOptions(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.archivebox,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    post.isArchived ? 'restore_post'.tr : 'archive_post'.tr,
                  ),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.arrow_down_to_line,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text('save_image'.tr),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(sheetContext);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.trash,
                    size: 20,
                    color: CupertinoColors.destructiveRed,
                  ),
                  SizedBox(width: 8),
                  Text('delete_post'.tr),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(sheetContext),
            child: Text('cancel'.tr),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

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
                  filterQuality: FilterQuality.high,
                  loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                      ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    double? progress;
                    int? totalBytes = loadingProgress.expectedTotalBytes;

                    if (totalBytes != null && totalBytes > 0) {
                      progress =
                          loadingProgress.cumulativeBytesLoaded / totalBytes;
                    }

                    return Center(
                      child: CircularProgressIndicator(
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
              icon: CupertinoIcons.xmark,
              onTap: () {
                Get.back();
              },
            ),
          ),
          Positioned(
            top: mediaQuery.padding.top + 10,
            right: 12,
            child: _ViewerButton(
              icon: CupertinoIcons.ellipsis,
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
}

class _PostInformation extends StatelessWidget {
  final ProfilePostItem post;

  const _PostInformation({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 36,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: 0.55,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.15,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.eye_fill,
                color: Colors.white,
                size: 15,
              ),
              SizedBox(width: 6),
              Text(
                '${post.viewCount}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        if (post.isArchived)
          Container(
            height: 36,
            padding: EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: 0.55,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.15,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.archivebox_fill,
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 6),
                Text(
                  'archived'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ViewerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ViewerButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.45,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.20,
          ),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.20,
            ),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size(40, 40),
        onPressed: onTap,
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _ImageErrorState extends StatelessWidget {
  const _ImageErrorState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          CupertinoIcons.photo,
          color: Colors.white70,
          size: 48,
        ),
        SizedBox(height: 12),
        Text(
          'unable_to_load_post'.tr,
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