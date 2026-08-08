import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// UPDATED: Unit UI active voice recording bar featuring pulse recording indicator, slide-to-cancel chevrons, timer, and action buttons
class ChatVoiceRecordingBar extends StatefulWidget {
  final double dragDx;
  final double cancelThreshold;
  final bool isHoldMode;
  final VoidCallback onCancel;
  final ValueChanged<Duration> onSend;

  const ChatVoiceRecordingBar({
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

class _ChatVoiceRecordingBarState extends State<ChatVoiceRecordingBar>
    with TickerProviderStateMixin {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // UPDATED: Bouncing "slide to cancel" chevrons animation controller
  late AnimationController _chevronController;

  @override
  void initState() {
    super.initState();

    // UPDATED: Initialize 850ms pulse animation for red recording indicator
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.35,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(reverse: true);

    // UPDATED: Initialize 900ms repeat animation for bouncing chevrons
    _chevronController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    // UPDATED: Periodic 1-second timer tracking elapsed recording duration
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) return;
        setState(() {
          _elapsed += const Duration(seconds: 1);
        });
      },
    );
  }

  /// UPDATED: Formats elapsed recording duration as MM:SS with tabular figures
  String _formatDuration(Duration duration) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _sendRecording() {
    widget.onSend(_elapsed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _chevronController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UPDATED: Retrieve current theme and colorScheme for dynamic styling
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    // UPDATED: Calculates cancel drag progress (0.0 to 1.0)
    double progress =
    (widget.dragDx / widget.cancelThreshold).clamp(0.0, 1.0);
    bool nearCancel = progress >= 0.65;

    double translationX =
    widget.dragDx.clamp(widget.cancelThreshold, 0.0).toDouble();

    // UPDATED: Standardized unit UI colors for glass surfaces, borders, and danger highlights
    Color backgroundColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color secondaryBackground = isDark
        ? const Color(0xFF26282E)
        : Colors.black.withValues(alpha: 0.035);

    Color dangerColor = colorScheme.error;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: nearCancel
            ? dangerColor.withValues(alpha: isDark ? 0.16 : 0.08)
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
          // UPDATED: Cancel recording button with Cupertino xmark icon
          Material(
            color: dangerColor.withValues(alpha: 0.11),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: widget.onCancel,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  CupertinoIcons.xmark,
                  color: dangerColor,
                  size: 20,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // UPDATED: Recording status container with pulsing red dot, timer, and slide-to-cancel prompt
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: secondaryBackground,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  // UPDATED: Pulsing red dot recording indicator
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

                  const SizedBox(width: 9),

                  // UPDATED: Elapsed timer text with tabular figures to prevent width jumping
                  Text(
                    _formatDuration(_elapsed),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // UPDATED: Slide-to-cancel prompt or tap-send instructions
                  Expanded(
                    child: widget.isHoldMode
                        ? Transform.translate(
                      offset: Offset(translationX * 0.20, 0),
                      child: AnimatedBuilder(
                        animation: _chevronController,
                        builder: (context, child) {
                          double bounce = nearCancel
                              ? 0.0
                              : math.sin(_chevronController.value *
                              2 *
                              math.pi) *
                              3;
                          return Transform.translate(
                            offset: Offset(bounce, 0),
                            child: child,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.chevron_left_2,
                              color: nearCancel
                                  ? dangerColor
                                  : colorScheme.onSurfaceVariant,
                              size: 16,
                            ),

                            const SizedBox(width: 4),

                            Flexible(
                              child: Text(
                                nearCancel
                                    ? 'Release to cancel'
                                    : 'Slide left to cancel',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: nearCancel
                                      ? dangerColor
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight: nearCancel
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Text(
                      'Tap send when ready',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // UPDATED: Right action indicator (mic or send button)
          widget.isHoldMode
              ? Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: nearCancel
                  ? dangerColor.withValues(alpha: 0.13)
                  : colorScheme.primary.withValues(alpha: 0.11),
              shape: BoxShape.circle,
            ),
            child: Icon(
              nearCancel
                  ? CupertinoIcons.trash
                  : CupertinoIcons.mic_fill,
              color: nearCancel ? dangerColor : colorScheme.primary,
              size: 22,
            ),
          )
              : Material(
            color: colorScheme.primary,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: _sendRecording,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  CupertinoIcons.paperplane_fill,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}