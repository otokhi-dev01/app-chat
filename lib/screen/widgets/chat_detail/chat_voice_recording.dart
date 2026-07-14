import 'dart:async';

import 'package:flutter/material.dart';

class ChatVoiceRecordingBar extends StatefulWidget {
  final double dragDx;
  final double cancelThreshold;
  final bool isHoldMode;
  final VoidCallback onCancel;
  final ValueChanged<Duration> onSend;

  ChatVoiceRecordingBar({
    super.key,
    required this.dragDx,
    required this.cancelThreshold,
    required this.isHoldMode,
    required this.onCancel,
    required this.onSend,
  });

  @override
  State<ChatVoiceRecordingBar> createState() {
    return _ChatVoiceRecordingBarState();
  }
}

class _ChatVoiceRecordingBarState
    extends State<ChatVoiceRecordingBar>
    with SingleTickerProviderStateMixin {
  Timer? _timer;

  Duration _elapsed = Duration.zero;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 850),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.35,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(
      reverse: true,
    );

    _timer = Timer.periodic(
      Duration(seconds: 1),
          (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          _elapsed += Duration(seconds: 1);
        });
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    String minutes = twoDigits(
      duration.inMinutes.remainder(60),
    );

    String seconds = twoDigits(
      duration.inSeconds.remainder(60),
    );

    return '$minutes:$seconds';
  }

  void _sendRecording() {
    widget.onSend(_elapsed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    double progress = (
        widget.dragDx / widget.cancelThreshold
    ).clamp(0.0, 1.0);

    bool nearCancel = progress >= 0.65;

    double translationX = widget.dragDx.clamp(
      widget.cancelThreshold,
      0.0,
    ).toDouble();

    Color backgroundColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.09)
        : Colors.black.withValues(alpha: 0.07);

    Color secondaryBackground = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.035);

    Color dangerColor = colorScheme.error;

    return AnimatedContainer(
      duration: Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: nearCancel
            ? dangerColor.withValues(
          alpha: isDark ? 0.16 : 0.08,
        )
            : backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: nearCancel
              ? dangerColor.withValues(alpha: 0.35)
              : borderColor,
        ),
      ),
      child: Row(
        children: [
          Material(
            color: dangerColor.withValues(alpha: 0.11),
            shape: CircleBorder(),
            child: InkWell(
              onTap: widget.onCancel,
              customBorder: CircleBorder(),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.close_rounded,
                  color: dangerColor,
                  size: 23,
                ),
              ),
            ),
          ),

          SizedBox(width: 8),

          Expanded(
            child: Container(
              height: 44,
              padding: EdgeInsets.symmetric(
                horizontal: 13,
              ),
              decoration: BoxDecoration(
                color: secondaryBackground,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Row(
                children: [
                  FadeTransition(
                    opacity: _pulseAnimation,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: dangerColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  SizedBox(width: 9),

                  Text(
                    _formatDuration(_elapsed),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontFeatures: [
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: widget.isHoldMode
                        ? Transform.translate(
                      offset: Offset(
                        translationX * 0.20,
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons
                                .keyboard_double_arrow_left_rounded,
                            color: nearCancel
                                ? dangerColor
                                : colorScheme
                                .onSurfaceVariant,
                            size: 18,
                          ),

                          SizedBox(width: 3),

                          Flexible(
                            child: Text(
                              nearCancel
                                  ? 'Release to cancel'
                                  : 'Slide left to cancel',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: theme
                                  .textTheme.bodySmall
                                  ?.copyWith(
                                color: nearCancel
                                    ? dangerColor
                                    : colorScheme
                                    .onSurfaceVariant,
                                fontWeight: nearCancel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Text(
                      'Tap send when ready',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color:
                        colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 8),

          widget.isHoldMode
              ? Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: nearCancel
                  ? dangerColor.withValues(alpha: 0.13)
                  : colorScheme.primary.withValues(
                alpha: 0.11,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              nearCancel
                  ? Icons.delete_outline_rounded
                  : Icons.mic_rounded,
              color: nearCancel
                  ? dangerColor
                  : colorScheme.primary,
              size: 24,
            ),
          )
              : Material(
            color: colorScheme.primary,
            shape: CircleBorder(),
            child: InkWell(
              onTap: _sendRecording,
              customBorder: CircleBorder(),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.send_rounded,
                  color: colorScheme.onPrimary,
                  size: 21,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}