import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/chat_message_model.dart';

/// UPDATED: Standalone file attachment tile widget with extension icons and tap-to-open launcher
class ChatFileMessage extends StatefulWidget {
  final ChatMessageModel message;
  final Color receivedTextColor;
  final Widget timeStatus;

  const ChatFileMessage({
    super.key,
    required this.message,
    required this.receivedTextColor,
    required this.timeStatus,
  });

  @override
  State<ChatFileMessage> createState() => _ChatFileMessageState();
}

class _ChatFileMessageState extends State<ChatFileMessage> {
  bool _isOpening = false;

  String get _fileName {
    String name = widget.message.text.trim();

    if (name.isEmpty && widget.message.mediaPath != null) {
      name = widget.message.mediaPath!.split(Platform.pathSeparator).last;
    }

    return name.isEmpty ? 'File' : name;
  }

  String get _extension {
    int dotIndex = _fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == _fileName.length - 1) {
      return '';
    }
    return _fileName.substring(dotIndex + 1).toLowerCase();
  }

  IconData get _iconForType {
    switch (_extension) {
      case 'pdf':
      case 'doc':
      case 'docx':
        return CupertinoIcons.doc_text_fill;
      case 'xls':
      case 'xlsx':
      case 'csv':
        return CupertinoIcons.table;
      case 'ppt':
      case 'pptx':
        return CupertinoIcons.tv;
      case 'zip':
      case 'rar':
      case '7z':
        return CupertinoIcons.folder_fill;
      case 'mp3':
      case 'wav':
      case 'm4a':
        return CupertinoIcons.music_note;
      case 'mp4':
      case 'mov':
      case 'avi':
        return CupertinoIcons.film;
      default:
        return CupertinoIcons.doc_fill;
    }
  }

  String get _subtitleLabel {
    if (_isOpening) return 'Opening…';
    return _extension.isEmpty ? 'Document' : _extension.toUpperCase();
  }

  Future<void> _openFile() async {
    String? path = widget.message.mediaPath;
    if (path == null || path.trim().isEmpty || _isOpening) return;

    HapticFeedback.selectionClick();
    setState(() => _isOpening = true);

    try {
      bool didOpen = await launchUrl(
        Uri.file(path),
        mode: LaunchMode.externalApplication,
      );

      if (!didOpen && mounted) _showUnavailable();
    } catch (_) {
      if (mounted) _showUnavailable();
    } finally {
      if (mounted) setState(() => _isOpening = false);
    }
  }

  void _showUnavailable() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Could not open this file.'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isMe = widget.message.isMe;

    Color iconBackground = isMe
        ? Colors.white.withValues(alpha: 0.16)
        : colorScheme.primary.withValues(alpha: 0.12);

    Color iconColor = isMe ? Colors.white : colorScheme.primary;
    Color titleColor = isMe ? Colors.white : widget.receivedTextColor;
    Color subtitleColor = isMe
        ? Colors.white.withValues(alpha: 0.72)
        : colorScheme.onSurfaceVariant;

    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _openFile,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: iconBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        child: _isOpening
                            ? SizedBox(
                          key: const ValueKey('opening'),
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: iconColor,
                          ),
                        )
                            : Icon(
                          _iconForType,
                          key: const ValueKey('icon'),
                          color: iconColor,
                          size: 23,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fileName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _subtitleLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: subtitleColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          widget.timeStatus,
        ],
      ),
    );
  }
}