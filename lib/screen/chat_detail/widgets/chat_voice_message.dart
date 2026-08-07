import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ChatVoiceRecordingBar extends StatefulWidget {
  final bool isHoldMode;
  final double dragDx;
  final double cancelThreshold;

  const ChatVoiceRecordingBar({
    super.key,
    required this.isHoldMode,
    required this.dragDx,
    required this.cancelThreshold,
  });

  @override
  State<ChatVoiceRecordingBar> createState() => _ChatVoiceRecordingBarState();
}

class _ChatVoiceRecordingBarState extends State<ChatVoiceRecordingBar>
    with TickerProviderStateMixin {
  late final Timer _timer;
  Duration _elapsed = Duration.zero;

  // Pulsing red recording dot
  late final AnimationController _pulseController;

  // Bouncing "slide to cancel" chevrons
  late final AnimationController _chevronController;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsed += const Duration(seconds: 1));
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _chevronController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    _chevronController.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    String m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    String s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    double cancelProgress =
    (widget.dragDx / widget.cancelThreshold).clamp(0.0, 1.0);

    Color cancelColor = Color.lerp(
      colorScheme.onSurfaceVariant,
      colorScheme.error,
      cancelProgress,
    )!;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Recording indicator: pulsing red dot
          FadeTransition(
            opacity: Tween(begin: 0.35, end: 1.0).animate(
              CurvedAnimation(
                parent: _pulseController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Timer
          Text(
            _format(_elapsed),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),

          const Spacer(),

          // "Slide to cancel" — fades out and shifts left as user drags,
          // turns red near the cancel threshold. Chevrons gently bounce
          // left/right the way Telegram's do.
          if (widget.isHoldMode)
            Opacity(
              opacity: 1 - cancelProgress,
              child: Transform.translate(
                offset: Offset(-50 * cancelProgress, 0),
                child: AnimatedBuilder(
                  animation: _chevronController,
                  builder: (context, child) {
                    double bounce = math.sin(
                      _chevronController.value * 2 * math.pi,
                    ) * 3;
                    return Transform.translate(
                      offset: Offset(bounce, 0),
                      child: child,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.keyboard_double_arrow_left_rounded,
                        size: 18,
                        color: cancelColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Slide to cancel',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cancelColor,
                          fontWeight: cancelProgress > 0.6
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mic_none_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Tap to stop',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}