import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// UPDATED: Unit UI animated action button that toggles between Send (paperplane) and Voice Mic buttons based on text input state
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
    // UPDATED: Retrieve colorScheme for dynamic light/dark theme adaptation
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (BuildContext context, TextEditingValue value, Widget? child) {
        bool hasMessage = value.text.trim().isNotEmpty;

        // UPDATED: Smooth 180ms fade and scale transition when switching between send and voice mic buttons
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
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
              // UPDATED: Primary filled send button with Cupertino paperplane icon
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
            // UPDATED: Handles OS gesture cancellations (e.g. system UI / calls) so recording state doesn't get stuck
            onLongPressCancel: onVoiceCancel,
            // UPDATED: Unit UI circular microphone button with primary color tint (12% opacity)
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                shape: BoxShape.circle,
              ),
              // UPDATED: Replaced Material icon with Cupertino mic icon
              child: Icon(
                CupertinoIcons.mic,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
          ),
        );
      },
    );
  }
}