import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/chat_message_model.dart';
import '../../widgets/app_feedback.dart';

/// UPDATED: Unit UI chat location card with map pattern grid, coordinates preview, and external map launcher
class ChatLocationMessage extends StatelessWidget {
  final ChatMessageModel message;

  const ChatLocationMessage({
    super.key,
    required this.message,
  });

  /// UPDATED: Launches external Google Maps application with latitude and longitude coordinates
  Future<void> _openLocation(BuildContext context) async {
    // ADDED: Tactile haptic feedback on location card tap
    HapticFeedback.selectionClick();

    double? latitude = message.latitude;
    double? longitude = message.longitude;

    if (latitude == null || longitude == null) {
      _showError('Location information is unavailable.');
      return;
    }

    Uri mapUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    try {
      bool opened = await launchUrl(
        mapUri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        _showError('Could not open the map.');
      }
    } catch (_) {
      _showError('Could not open the map.');
    }
  }

  /// UPDATED: Displays location error message using AppFeedback toast
  void _showError(String messageText) {
    AppFeedback.showMessage(
      title: 'Location Error',
      message: messageText,
      icon: CupertinoIcons.exclamationmark_circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    // UPDATED: Access current theme and colorScheme for dynamic dark/light mode adaptation
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor;
    Color foregroundColor;
    Color secondaryColor;

    // UPDATED: Theme awareness for sent (isMe) vs received location card bubbles
    if (message.isMe) {
      cardColor = colorScheme.primary;
      foregroundColor = colorScheme.onPrimary;
      secondaryColor = colorScheme.onPrimary.withValues(
        alpha: 0.76,
      );
    } else {
      cardColor = isDark ? const Color(0xFF24262C) : Colors.white;
      foregroundColor = colorScheme.onSurface;
      secondaryColor = colorScheme.onSurfaceVariant;
    }

    String coordinates = message.latitude != null && message.longitude != null
        ? '${message.latitude!.toStringAsFixed(6)}, ${message.longitude!.toStringAsFixed(6)}'
        : 'Location unavailable';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openLocation(context),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 245,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: message.isMe
                ? null
                : Border.all(
              color: isDark
                  ? Colors.white.withValues(
                alpha: 0.08,
              )
                  : Colors.black.withValues(
                alpha: 0.06,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UPDATED: Map grid preview container with centered circular location pin icon
              Container(
                height: 112,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: message.isMe
                      ? colorScheme.onPrimary.withValues(
                    alpha: 0.12,
                  )
                      : colorScheme.primary.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // UPDATED: Custom painter rendering decorative grid map pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _LocationPatternPainter(
                          color: message.isMe
                              ? colorScheme.onPrimary.withValues(
                            alpha: 0.08,
                          )
                              : colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                        ),
                      ),
                    ),
                    // UPDATED: 56x56 circular pin container with Cupertino location icon
                    Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: message.isMe
                            ? colorScheme.onPrimary
                            : colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.16,
                            ),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      // UPDATED: Replaced Material pin icon with Cupertino location icon
                      child: Icon(
                        CupertinoIcons.location_fill,
                        color: message.isMe
                            ? colorScheme.primary
                            : colorScheme.onPrimary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              // UPDATED: Location details header, coordinates, and tap indicator
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  12,
                  14,
                  13,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Shared location',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: foregroundColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        // UPDATED: Replaced Material open-in-new icon with Cupertino arrow icon
                        Icon(
                          CupertinoIcons.arrow_up_right,
                          size: 17,
                          color: secondaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      coordinates,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondaryColor,
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to open map',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondaryColor,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// UPDATED: Custom painter rendering grid pattern overlay for location preview cards
class _LocationPatternPainter extends CustomPainter {
  final Color color;

  _LocationPatternPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    double spacing = 24;

    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }

    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_LocationPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}