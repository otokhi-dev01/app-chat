import 'dart:async';
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
    with SingleTickerProviderStateMixin {
  late final Timer _timer;
  Duration _elapsed = Duration.zero;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(seconds: 1));
    });
    _pulseController =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    String m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    String s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    double cancelProgress =
    (widget.dragDx / widget.cancelThreshold).clamp(0.0, 1.0);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          FadeTransition(
            opacity: _pulseController,
            child: const CircleAvatar(
              radius: 5,
              backgroundColor: Colors.red,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _format(_elapsed),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (widget.isHoldMode)
            Opacity(
              opacity: 1 - cancelProgress,
              child: Transform.translate(
                offset: Offset(-40 * cancelProgress, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.chevron_left_rounded, size: 20),
                    Text('Slide to cancel', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            )
          else
            const Text(
              'Tap to stop',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}