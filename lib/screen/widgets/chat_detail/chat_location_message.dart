import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/chat_message_model.dart';

class ChatLocationMessage extends StatelessWidget {
  final ChatMessageModel message;

  ChatLocationMessage({
    super.key,
    required this.message,
  });

  Future<void> _openLocation(
      BuildContext context,
      ) async {
    double? latitude = message.latitude;
    double? longitude = message.longitude;

    if (latitude == null || longitude == null) {
      _showError(
        context,
        'Location information is unavailable.',
      );

      return;
    }

    Uri mapUri = Uri.parse(
      'https://www.google.com/maps/search/'
          '?api=1&query=$latitude,$longitude',
    );

    bool opened = await launchUrl(
      mapUri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      _showError(
        context,
        'Could not open the map.',
      );
    }
  }

  void _showError(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
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

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor;

    Color foregroundColor;

    Color secondaryColor;

    if (message.isMe) {
      cardColor = colorScheme.primary;
      foregroundColor = colorScheme.onPrimary;
      secondaryColor = colorScheme.onPrimary.withValues(
        alpha: 0.76,
      );
    } else {
      cardColor = isDark
          ? Color(0xFF24262C)
          : Colors.white;

      foregroundColor = colorScheme.onSurface;

      secondaryColor =
          colorScheme.onSurfaceVariant;
    }

    String coordinates =
    message.latitude != null &&
        message.longitude != null
        ? '${message.latitude!.toStringAsFixed(6)}, '
        '${message.longitude!.toStringAsFixed(6)}'
        : 'Location unavailable';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _openLocation(context);
        },
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
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _LocationPatternPainter(
                          color: message.isMe
                              ? colorScheme.onPrimary
                              .withValues(
                            alpha: 0.08,
                          )
                              : colorScheme.primary
                              .withValues(
                            alpha: 0.08,
                          ),
                        ),
                      ),
                    ),
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
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: message.isMe
                            ? colorScheme.primary
                            : colorScheme.onPrimary,
                        size: 29,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  14,
                  12,
                  14,
                  13,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Shared location',
                            style: theme
                                .textTheme.titleSmall
                                ?.copyWith(
                              color: foregroundColor,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 17,
                          color: secondaryColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      coordinates,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color: secondaryColor,
                        fontSize: 11.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap to open map',
                      style:
                      theme.textTheme.bodySmall?.copyWith(
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

class _LocationPatternPainter
    extends CustomPainter {
  final Color color;

  _LocationPatternPainter({
    required this.color,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    double spacing = 24;

    for (
    double x = -size.height;
    x < size.width;
    x += spacing
    ) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }

    for (
    double y = spacing;
    y < size.height;
    y += spacing
    ) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      _LocationPatternPainter oldDelegate,
      ) {
    return oldDelegate.color != color;
  }
}