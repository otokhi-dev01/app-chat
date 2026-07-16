import 'package:flutter/material.dart';

import 'call_action_button.dart';

class CallControls extends StatelessWidget {
  final bool isVideoCall;
  final bool isMuted;
  final bool isVideoOn;
  final bool isSpeakerOn;

  final VoidCallback onToggleMute;
  final VoidCallback onToggleVideo;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onFlipCamera;
  final VoidCallback onEndCall;

  CallControls({
    super.key,
    required this.isVideoCall,
    required this.isMuted,
    required this.isVideoOn,
    required this.isSpeakerOn,
    required this.onToggleMute,
    required this.onToggleVideo,
    required this.onToggleSpeaker,
    required this.onFlipCamera,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        14,
        18,
        14,
        18,
      ),
      decoration: BoxDecoration(
        color: cardColor.withValues(
          alpha: 0.96,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 18,
            children: [
              CallActionButton(
                label: isMuted
                    ? 'Unmute'
                    : 'Mute',
                tooltip: isMuted
                    ? 'Turn microphone on'
                    : 'Mute microphone',
                icon: isMuted
                    ? Icons.mic_off_rounded
                    : Icons.mic_none_rounded,
                isActive: isMuted,
                onTap: onToggleMute,
              ),

              if (isVideoCall)
                CallActionButton(
                  label: isVideoOn
                      ? 'Camera'
                      : 'Camera off',
                  tooltip: isVideoOn
                      ? 'Turn camera off'
                      : 'Turn camera on',
                  icon: isVideoOn
                      ? Icons.videocam_rounded
                      : Icons.videocam_off_rounded,
                  isActive: !isVideoOn,
                  onTap: onToggleVideo,
                )
              else
                CallActionButton(
                  label: 'Speaker',
                  tooltip: isSpeakerOn
                      ? 'Turn speaker off'
                      : 'Turn speaker on',
                  icon: isSpeakerOn
                      ? Icons.volume_up_rounded
                      : Icons.volume_down_rounded,
                  isActive: isSpeakerOn,
                  onTap: onToggleSpeaker,
                ),

              if (isVideoCall)
                CallActionButton(
                  label: 'Flip',
                  tooltip: 'Switch camera',
                  icon:
                  Icons.cameraswitch_rounded,
                  isActive: false,
                  onTap: onFlipCamera,
                ),
            ],
          ),

          SizedBox(height: 24),

          Material(
            color: colorScheme.error,
            borderRadius: BorderRadius.circular(19),
            child: InkWell(
              onTap: onEndCall,
              borderRadius:
              BorderRadius.circular(19),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.call_end_rounded,
                      color: colorScheme.onError,
                      size: 25,
                    ),

                    SizedBox(width: 10),

                    Text(
                      'End Call',
                      style: TextStyle(
                        color: colorScheme.onError,
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}