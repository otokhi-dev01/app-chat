import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/chat_message_model.dart';
import '../../../services/chat_camera_services.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({
    super.key,
  });

  @override
  State<AddPostScreen> createState() {
    return _AddPostScreenState();
  }
}

class _AddPostScreenState
    extends State<AddPostScreen> {
  final ChatCameraService _cameraService =
  ChatCameraService();

  final TextEditingController
  _captionController =
  TextEditingController();

  String _imagePath = '';
  bool _isPickingImage = false;
  bool _isPublishing = false;

  bool get hasImage {
    return _imagePath.trim().isNotEmpty;
  }

  bool get canPublish {
    return hasImage &&
        !_isPickingImage &&
        !_isPublishing;
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    if (_isPickingImage) {
      return;
    }

    setState(() {
      _isPickingImage = true;
    });

    try {
      ChatMessageModel? result =
      await _cameraService.pickFromGallery();

      String path =
          result?.mediaPath?.trim() ?? '';

      if (!mounted || path.isEmpty) {
        return;
      }

      setState(() {
        _imagePath = path;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to select the photo.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_isPickingImage) {
      return;
    }

    setState(() {
      _isPickingImage = true;
    });

    try {
      ChatMessageModel? result =
      await _cameraService.takePhoto();

      String path =
          result?.mediaPath?.trim() ?? '';

      if (!mounted || path.isEmpty) {
        return;
      }

      setState(() {
        _imagePath = path;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to take the photo.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<void> _openPhotoOptions() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color sheetColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: 0.38,
      ),
      builder: (
          BuildContext sheetContext,
          ) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            14,
            9,
            14,
            18,
          ),
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
            ),
            border: Border(
              top: BorderSide(
                color: borderColor,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme
                      .onSurfaceVariant
                      .withValues(
                    alpha: 0.25,
                  ),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _PhotoOption(
                      imagePath:
                      'assets/images/chat_attachment/gallery.png',
                      fallbackIcon:
                      Icons.photo_library_outlined,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.of(sheetContext)
                            .pop();

                        Future<void>.delayed(
                          Duration(
                            milliseconds: 100,
                          ),
                          _pickFromGallery,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _PhotoOption(
                      imagePath:
                      'assets/images/chat_attachment/camera.png',
                      fallbackIcon:
                      Icons.camera_alt_outlined,
                      label: 'Camera',
                      onTap: () {
                        Navigator.of(sheetContext)
                            .pop();

                        Future<void>.delayed(
                          Duration(
                            milliseconds: 100,
                          ),
                          _takePhoto,
                        );
                      },
                    ),
                  ),
                  if (hasImage) ...[
                    SizedBox(width: 8),
                    Expanded(
                      child: _PhotoOption(
                        fallbackIcon:
                        Icons.delete_outline_rounded,
                        label: 'Remove',
                        isDanger: true,
                        onTap: () {
                          Navigator.of(sheetContext)
                              .pop();

                          setState(() {
                            _imagePath = '';
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _publishPost() async {
    if (!canPublish) {
      return;
    }

    FocusManager.instance.primaryFocus
        ?.unfocus();

    setState(() {
      _isPublishing = true;
    });

    try {
      await Future<void>.delayed(
        Duration(
          milliseconds: 600,
        ),
      );

      if (!mounted) {
        return;
      }

      Get.back(
        result: <String, dynamic>{
          'imagePath': _imagePath,
          'caption':
          _captionController.text.trim(),
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to publish the post.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPublishing = false;
        });
      }
    }
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: isError
                  ? colorScheme.onError
                  : colorScheme.onPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: isError
              ? colorScheme.error
              : colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color pageColor =
        theme.scaffoldBackgroundColor;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Scaffold(
      backgroundColor: pageColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: pageColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 72,
        leading: TextButton(
          onPressed: _isPublishing
              ? null
              : () {
            Get.back();
          },
          child: Text(
            'Cancel',
            style: theme.textTheme.bodyMedium
                ?.copyWith(
              color:
              colorScheme.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          'New Post',
          style: theme.textTheme.titleMedium
              ?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: _PublishButton(
              enabled: canPublish,
              loading: _isPublishing,
              onTap: _publishPost,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,
          physics: BouncingScrollPhysics(
            parent:
            AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(
            14,
            10,
            14,
            120,
          ),
          children: [
            _PostImageCard(
              imagePath: _imagePath,
              loading: _isPickingImage,
              cardColor: cardColor,
              borderColor: borderColor,
              onTap: _openPhotoOptions,
            ),
            SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                14,
                12,
                14,
                8,
              ),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                BorderRadius.circular(18),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: TextField(
                controller: _captionController,
                maxLines: 7,
                minLines: 3,
                maxLength: 500,
                textCapitalization:
                TextCapitalization.sentences,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  height: 1.4,
                ),
                decoration: InputDecoration(
                  hintText:
                  'Write a caption...',
                  hintStyle: theme
                      .textTheme.bodyMedium
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  counterStyle: theme
                      .textTheme.bodySmall
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),
            _PostSettingTile(
              icon:
              Icons.public_rounded,
              title: 'Audience',
              subtitle: 'Everyone',
              cardColor: cardColor,
              borderColor: borderColor,
              onTap: () {
                _showMessage(
                  'Audience settings are not implemented yet.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PostImageCard extends StatelessWidget {
  final String imagePath;
  final bool loading;
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onTap;

  _PostImageCard({
    required this.imagePath,
    required this.loading,
    required this.cardColor,
    required this.borderColor,
    required this.onTap,
  });

  bool get hasImage {
    return imagePath.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onTap,
          borderRadius: BorderRadius.circular(
            20,
          ),
          splashColor: Colors.transparent,
          highlightColor:
          Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius:
              BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasImage)
                  Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    filterQuality:
                    FilterQuality.medium,
                    errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                        ) {
                      return _EmptyImageView();
                    },
                  )
                else
                  _EmptyImageView(),
                if (hasImage && !loading)
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      height: 36,
                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 11,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withValues(
                          alpha: 0.52,
                        ),
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .photo_camera_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Change',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (loading)
                  Container(
                    alignment: Alignment.center,
                    color: Colors.black.withValues(
                      alpha: 0.28,
                    ),
                    child:
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyImageView
    extends StatelessWidget {
  _EmptyImageView();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Container(
      alignment: Alignment.center,
      color: colorScheme
          .surfaceContainerHighest
          .withValues(
        alpha: 0.45,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withValues(
                alpha: 0.11,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: colorScheme.primary,
              size: 31,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Add a photo',
            style: theme.textTheme.titleMedium
                ?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Choose from gallery or camera',
            style: theme.textTheme.bodySmall
                ?.copyWith(
              color: colorScheme
                  .onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _PublishButton
    extends StatelessWidget {
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  _PublishButton({
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Material(
      color: enabled
          ? colorScheme.primary
          : colorScheme.onSurfaceVariant
          .withValues(
        alpha: 0.12,
      ),
      borderRadius: BorderRadius.circular(
        14,
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(
          14,
        ),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        child: SizedBox(
          height: 36,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 13,
            ),
            child: Center(
              child: loading
                  ? SizedBox(
                width: 17,
                height: 17,
                child:
                CircularProgressIndicator(
                  color:
                  colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                'Post',
                style: TextStyle(
                  color: enabled
                      ? colorScheme.onPrimary
                      : colorScheme
                      .onSurfaceVariant,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final String? imagePath;
  final IconData fallbackIcon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;

  _PhotoOption({
    required this.fallbackIcon,
    required this.label,
    required this.onTap,
    this.imagePath,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color contentColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          14,
        ),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        child: Container(
          height: 76,
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: contentColor.withValues(
              alpha: isDark ? 0.14 : 0.09,
            ),
            borderRadius:
            BorderRadius.circular(14),
            border: Border.all(
              color: contentColor.withValues(
                alpha: 0.16,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              _OptionImage(
                imagePath: imagePath,
                fallbackIcon: fallbackIcon,
                color: contentColor,
              ),
              SizedBox(height: 7),
              Text(
                label,
                style: theme
                    .textTheme.bodySmall
                    ?.copyWith(
                  color: contentColor,
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionImage extends StatelessWidget {
  final String? imagePath;
  final IconData fallbackIcon;
  final Color color;

  _OptionImage({
    required this.imagePath,
    required this.fallbackIcon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    String path = imagePath?.trim() ?? '';

    if (path.isEmpty) {
      return Icon(
        fallbackIcon,
        color: color,
        size: 25,
      );
    }

    return SizedBox(
      width: 27,
      height: 27,
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          return Icon(
            fallbackIcon,
            color: color,
            size: 25,
          );
        },
      ),
    );
  }
}

class _PostSettingTile
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onTap;

  _PostSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cardColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(
        17,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          17,
        ),
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(17),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(
                    alpha: 0.11,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme
                          .textTheme.bodyMedium
                          ?.copyWith(
                        color:
                        colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme
                    .onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}