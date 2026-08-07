import 'dart:ui';

import 'package:flutter/material.dart';

import 'chat_input_action_button.dart';
import 'chat_input_text_field.dart';
import 'chat_send_or_voice_button.dart';
import 'chat_voice_recording.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  final VoidCallback onSend;
  final VoidCallback? onAttachment;
  final VoidCallback? onCamera;

  final bool isRecording;
  final bool isHoldRecording;
  final double voiceDragDx;
  final double cancelThreshold;

  final VoidCallback? onVoiceTap;
  final VoidCallback? onVoiceStart;
  final void Function(double dx)? onVoiceDrag;
  final VoidCallback? onVoiceEnd;
  final VoidCallback? onVoiceCancel;
  final ValueChanged<Duration>? onVoiceSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.isRecording,
    required this.isHoldRecording,
    required this.voiceDragDx,
    required this.cancelThreshold,
    this.onAttachment,
    this.onCamera,
    this.onVoiceTap,
    this.onVoiceStart,
    this.onVoiceDrag,
    this.onVoiceEnd,
    this.onVoiceCancel,
    this.onVoiceSend,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color navigationColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.96)
        : Colors.white.withValues(alpha: 0.96);

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.09)
        : Colors.black.withValues(alpha: 0.07);

    Color inputColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.035);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(10, 4, 10, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Stack(
            children: [
              // Wrapped in IgnorePointer while recording — previously
              // this row was only visually faded (opacity 0) but still
              // received taps underneath the recording bar overlay.
              IgnorePointer(
                ignoring: isRecording,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutCubic,
                  opacity: isRecording ? 0 : 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: navigationColor,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.20 : 0.08,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ChatInputActionButton(
                          tooltip: 'Attach',
                          icon: Icons.add_rounded,
                          iconColor: colorScheme.primary,
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.11,
                          ),
                          onPressed: onAttachment,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: ChatInputTextField(
                            controller: controller,
                            focusNode: focusNode,
                            onCamera: onCamera,
                            inputColor: inputColor,
                            borderColor: borderColor,
                          ),
                        ),
                        const SizedBox(width: 7),
                        ChatSendOrVoiceButton(
                          controller: controller,
                          onSend: onSend,
                          onVoiceTap: onVoiceTap,
                          onVoiceStart: onVoiceStart,
                          onVoiceDrag: onVoiceDrag,
                          onVoiceEnd: onVoiceEnd,
                          onVoiceCancel: onVoiceCancel,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.97, end: 1).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: isRecording
                      ? ChatVoiceRecordingBar(
                    key: ValueKey(
                      isHoldRecording ? 'hold-recording' : 'tap-recording',
                    ),
                    dragDx: voiceDragDx,
                    cancelThreshold: cancelThreshold,
                    isHoldMode: isHoldRecording,
                    onCancel: () => onVoiceCancel?.call(),
                    onSend: (Duration duration) => onVoiceSend?.call(duration),
                  )
                      : const SizedBox.shrink(key: ValueKey('recording-hidden')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}