import 'dart:ui';

import 'package:flutter/material.dart';

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

  ChatInputBar({
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

    bool isDark =
        theme.brightness == Brightness.dark;

    Color navigationColor = isDark
        ? Color(0xFF1B1D22).withValues(alpha: 0.96)
        : Colors.white.withValues(alpha: 0.96);

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.09)
        : Colors.black.withValues(alpha: 0.07);

    Color inputColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.035);

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(
        10,
        4,
        10,
        8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Stack(
            children: [
              AnimatedOpacity(
                duration: Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                opacity: isRecording ? 0 : 1,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: navigationColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: borderColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.20 : 0.08,
                        ),
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      _InputActionButton(
                        tooltip: 'Attach',
                        icon: Icons.add_rounded,
                        iconColor: colorScheme.primary,
                        backgroundColor:
                        colorScheme.primary.withValues(
                          alpha: 0.11,
                        ),
                        onPressed: onAttachment,
                      ),

                      SizedBox(width: 7),

                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: 44,
                            maxHeight: 130,
                          ),
                          decoration: BoxDecoration(
                            color: inputColor,
                            borderRadius:
                            BorderRadius.circular(22),
                            border: Border.all(
                              color: borderColor,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  minLines: 1,
                                  maxLines: 5,
                                  keyboardType:
                                  TextInputType.multiline,
                                  textInputAction:
                                  TextInputAction.newline,
                                  textCapitalization:
                                  TextCapitalization
                                      .sentences,
                                  cursorColor:
                                  colorScheme.primary,
                                  style: theme
                                      .textTheme.bodyLarge
                                      ?.copyWith(
                                    color:
                                    colorScheme.onSurface,
                                  ),
                                  onTapOutside:
                                      (PointerDownEvent event) {
                                    FocusManager.instance
                                        .primaryFocus
                                        ?.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Message',
                                    hintStyle: TextStyle(
                                      color: colorScheme
                                          .onSurfaceVariant
                                          .withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder:
                                    InputBorder.none,
                                    focusedBorder:
                                    InputBorder.none,
                                    isDense: true,
                                    contentPadding:
                                    EdgeInsets.fromLTRB(
                                      15,
                                      12,
                                      8,
                                      12,
                                    ),
                                  ),
                                ),
                              ),

                              IconButton(
                                tooltip: 'Camera',
                                onPressed: onCamera,
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: colorScheme
                                      .onSurfaceVariant,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 7),

                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller,
                        builder: (
                            BuildContext context,
                            TextEditingValue value,
                            Widget? child,
                            ) {
                          bool hasMessage =
                              value.text.trim().isNotEmpty;

                          return AnimatedSwitcher(
                            duration:
                            Duration(milliseconds: 180),
                            switchInCurve:
                            Curves.easeOutCubic,
                            switchOutCurve:
                            Curves.easeInCubic,
                            transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                                ) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween<double>(
                                    begin: 0.85,
                                    end: 1,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: hasMessage
                                ? Material(
                              key: ValueKey(
                                'send-button',
                              ),
                              color:
                              colorScheme.primary,
                              shape: CircleBorder(),
                              child: InkWell(
                                onTap: onSend,
                                customBorder:
                                CircleBorder(),
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Icon(
                                    Icons.send_rounded,
                                    color: colorScheme
                                        .onPrimary,
                                    size: 21,
                                  ),
                                ),
                              ),
                            )
                                : GestureDetector(
                              key: ValueKey(
                                'voice-button',
                              ),
                              behavior:
                              HitTestBehavior.opaque,

                              onTap: () {
                                onVoiceTap?.call();
                              },

                              onLongPressStart: (_) {
                                onVoiceStart?.call();
                              },

                              onLongPressMoveUpdate: (
                                  LongPressMoveUpdateDetails
                                  details,
                                  ) {
                                onVoiceDrag?.call(
                                  details
                                      .offsetFromOrigin.dx,
                                );
                              },

                              onLongPressEnd: (_) {
                                onVoiceEnd?.call();
                              },

                              child: Container(
                                width: 44,
                                height: 44,
                                alignment:
                                Alignment.center,
                                decoration: BoxDecoration(
                                  color: colorScheme
                                      .primary
                                      .withValues(
                                    alpha: 0.11,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.mic_none_rounded,
                                  color:
                                  colorScheme.primary,
                                  size: 26,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      ) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.97,
                          end: 1,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: isRecording
                      ? ChatVoiceRecordingBar(
                    key: ValueKey(
                      isHoldRecording
                          ? 'hold-recording'
                          : 'tap-recording',
                    ),
                    dragDx: voiceDragDx,
                    cancelThreshold:
                    cancelThreshold,
                    isHoldMode:
                    isHoldRecording,
                    onCancel: () {
                      onVoiceCancel?.call();
                    },
                    onSend: (Duration duration) {
                      onVoiceSend?.call(duration);
                    },
                  )
                      : SizedBox.shrink(
                    key: ValueKey(
                      'recording-hidden',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  _InputActionButton({
    required this.tooltip,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        shape: CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: CircleBorder(),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              color: iconColor,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}