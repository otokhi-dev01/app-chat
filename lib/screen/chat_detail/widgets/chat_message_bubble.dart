import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/chat_message_model.dart';
import 'chat_file_massage.dart';
import 'chat_voice_massage.dart';

/// UPDATED: Cleaned main bubble container routing message types to sub-widgets
class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final VoidCallback? onLongPress;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onLongPress,
  });

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    int formattedHour = hour % 12;

    if (formattedHour == 0) formattedHour = 12;
    String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }

  bool get _isImageMessage {
    return message.type == ChatMessageType.image &&
        message.mediaPath != null &&
        message.mediaPath!.trim().isNotEmpty;
  }

  bool get _isVoiceMessage => message.type == ChatMessageType.voice;
  bool get _isFileMessage => message.type == ChatMessageType.file;
  bool get _isLocationMessage {
    return message.type == ChatMessageType.location &&
        message.latitude != null &&
        message.longitude != null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    Color receivedBackground = isDark ? const Color(0xFF24272D) : Colors.white;
    Color receivedTextColor = isDark ? Colors.white : const Color(0xFF202124);

    EdgeInsets bubblePadding = (_isImageMessage || _isLocationMessage)
        ? const EdgeInsets.all(4)
        : const EdgeInsets.fromLTRB(13, 9, 10, 7);

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: _BouncyPressEffect(
        onLongPress: onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          margin: EdgeInsets.only(
            left: message.isMe ? 55 : 12,
            right: message.isMe ? 12 : 55,
            bottom: 7,
          ),
          padding: bubblePadding,
          decoration: BoxDecoration(
            color: message.isMe ? AppTheme.primaryColor : receivedBackground,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(message.isMe ? 18 : 4),
              bottomRight: Radius.circular(message.isMe ? 4 : 18),
            ),
            border: message.isMe
                ? null
                : Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.12 : 0.04,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildMessageContent(context, receivedTextColor),
        ),
      ),
    );
  }

  Widget _buildMessageContent(
      BuildContext context,
      Color receivedTextColor,
      ) {
    if (_isLocationMessage) {
      return _buildLocationMessage(context, receivedTextColor);
    }
    if (_isImageMessage) {
      return _buildImageMessage(context);
    }
    if (_isVoiceMessage) {
      return ChatVoiceMessage(
        message: message,
        receivedTextColor: receivedTextColor,
        timeStatus: _buildTimeStatus(),
      );
    }
    if (_isFileMessage) {
      return ChatFileMessage(
        message: message,
        receivedTextColor: receivedTextColor,
        timeStatus: _buildTimeStatus(),
      );
    }
    return _buildTextMessage(receivedTextColor);
  }

  Widget _buildTextMessage(Color receivedTextColor) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText(
            message.text,
            style: TextStyle(
              color: message.isMe ? Colors.white : receivedTextColor,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          _buildTimeStatus(),
        ],
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            _openFullImage(context);
          },
          child: Hero(
            tag: message.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(message.mediaPath!),
                width: 240,
                height: 280,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSync) {
                  if (wasSync) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: frame == null
                        ? Container(
                      width: 240,
                      height: 280,
                      color: message.isMe
                          ? Colors.white.withValues(alpha: 0.10)
                          : Colors.grey.withValues(alpha: 0.12),
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: message.isMe
                              ? Colors.white
                              : Colors.grey.shade500,
                        ),
                      ),
                    )
                        : child,
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  width: 240,
                  height: 180,
                  alignment: Alignment.center,
                  color: Colors.grey.shade300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.photo,
                        color: Colors.grey.shade700,
                        size: 42,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Image unavailable',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (message.text.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isMe ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 5, bottom: 3),
          child: _buildTimeStatus(),
        ),
      ],
    );
  }

  Widget _buildLocationMessage(
      BuildContext context,
      Color receivedTextColor,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    double latitude = message.latitude!;
    double longitude = message.longitude!;
    String coordinates =
        '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

    Color locationBackground = message.isMe
        ? Colors.white.withValues(alpha: 0.13)
        : colorScheme.primary.withValues(alpha: 0.10);

    Color titleColor = message.isMe ? Colors.white : receivedTextColor;
    Color subtitleColor = message.isMe
        ? Colors.white.withValues(alpha: 0.78)
        : colorScheme.onSurfaceVariant;

    return SizedBox(
      width: 245,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                _openLocation(context);
              },
              borderRadius: BorderRadius.circular(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: locationBackground,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _LocationPatternPainter(
                              color: message.isMe
                                  ? Colors.white.withValues(alpha: 0.10)
                                  : colorScheme.primary.withValues(alpha: 0.11),
                            ),
                          ),
                        ),
                        Container(
                          width: 58,
                          height: 58,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: message.isMe
                                ? Colors.white
                                : colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.16),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            CupertinoIcons.location_fill,
                            color: message.isMe
                                ? AppTheme.primaryColor
                                : colorScheme.onPrimary,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(11, 11, 9, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shared location',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: titleColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coordinates,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: subtitleColor,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Tap to open map',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: subtitleColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.arrow_up_right,
                          size: 18,
                          color: subtitleColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 5, bottom: 3),
            child: _buildTimeStatus(),
          ),
        ],
      ),
    );
  }

  Future<void> _openLocation(BuildContext context) async {
    double? latitude = message.latitude;
    double? longitude = message.longitude;
    if (latitude == null || longitude == null) return;

    Uri mapUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    try {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  /// FIXED: Replaced non-existent 'CupertinoIcons.checkmark_alt_wordmark' with 'Icons.done_all_rounded'
  Widget _buildTimeStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.sentAt),
          style: TextStyle(
            color: message.isMe
                ? Colors.white.withValues(alpha: 0.75)
                : Colors.grey,
            fontSize: 9,
            height: 1,
          ),
        ),
        if (message.isMe) ...[
          const SizedBox(width: 3),
          // FIXED: Used valid double checkmark icon for read receipts
          Icon(
            message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
            size: 14,
            color: message.isRead
                ? const Color(0xFF32C766)
                : Colors.white.withValues(alpha: 0.75),
          ),
        ],
      ],
    );
  }

  void _openFullImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              title: const Text('Photo'),
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 5,
                child: Hero(
                  tag: message.id,
                  child: Image.file(
                    File(message.mediaPath!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// UPDATED: Custom painter for location background grid pattern
class _LocationPatternPainter extends CustomPainter {
  final Color color;

  _LocationPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    double spacing = 24;

    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), paint);
    }

    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_LocationPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// UPDATED: Long press bouncy press effect wrapper
class _BouncyPressEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onLongPress;

  const _BouncyPressEffect({
    required this.child,
    this.onLongPress,
  });

  @override
  State<_BouncyPressEffect> createState() => _BouncyPressEffectState();
}

class _BouncyPressEffectState extends State<_BouncyPressEffect> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress == null
          ? null
          : () {
        HapticFeedback.mediumImpact();
        widget.onLongPress!();
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {},
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}