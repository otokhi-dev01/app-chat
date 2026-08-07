import 'package:flutter/material.dart';

class ChatSendOrVoiceButton extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onVoiceStart;
  final void Function(double dx)? onVoiceDrag;
  final VoidCallback? onVoiceEnd;

  /// Called when the OS cancels the long-press gesture mid-recording
  /// (e.g. incoming call, system UI takeover). Without this, recording
  /// can be left running with no way for the UI to know it stopped.
  final VoidCallback? onVoiceCancel;

  const ChatSendOrVoiceButton({
    super.key,
    required this.controller,
    required this.onSend,
    this.onVoiceTap,
    this.onVoiceStart,
    this.onVoiceDrag,
    this.onVoiceEnd,
    this.onVoiceCancel,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (BuildContext context, TextEditingValue value, Widget? child) {
        bool hasMessage = value.text.trim().isNotEmpty;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1).animate(animation),
                child: child,
              ),
            );
          },
          child: hasMessage
              ? Material(
            key: const ValueKey('send-button'),
            color: colorScheme.primary,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onSend,
              customBorder: const CircleBorder(),
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
          )
              : GestureDetector(
            key: const ValueKey('voice-button'),
            behavior: HitTestBehavior.opaque,
            onTap: onVoiceTap,
            onLongPressStart: (_) => onVoiceStart?.call(),
            onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
              onVoiceDrag?.call(details.offsetFromOrigin.dx);
            },
            onLongPressEnd: (_) => onVoiceEnd?.call(),
            // Fires if the gesture is cancelled by the system rather
            // than released normally — cleans up recording state so
            // it never gets stuck "in progress".
            onLongPressCancel: onVoiceCancel,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic_none_rounded,
                color: colorScheme.primary,
                size: 26,
              ),
            ),
          ),
        );
      },
    );
  }
}