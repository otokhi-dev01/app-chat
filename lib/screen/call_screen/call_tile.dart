import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/chat_model.dart';
import 'call_actions_sheet.dart';

/// UPDATED: Unit UI call tile with gesture detector supporting long-press action sheet
class CallTile extends StatelessWidget {
  final ChatModel call;
  final VoidCallback onAudioCall;
  final VoidCallback onVideoCall;
  final VoidCallback? onSendMessage;
  final VoidCallback? onDeleteCall;

  const CallTile({
    super.key,
    required this.call,
    required this.onAudioCall,
    required this.onVideoCall,
    this.onSendMessage,
    this.onDeleteCall,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    final bool hasAvatar = call.image.trim().isNotEmpty;

    // UPDATED: Call direction icon (Incoming green, Outgoing blue, Missed red)
    IconData directionIcon;
    Color directionColor;

    final bool isMissed = call.unread > 0;
    final bool isIncoming = !call.isMe;

    if (isMissed) {
      directionIcon = CupertinoIcons.phone_down_fill;
      directionColor = colorScheme.error;
    } else if (isIncoming) {
      directionIcon = CupertinoIcons.arrow_down_left;
      directionColor = const Color(0xFF32C766); // Green
    } else {
      directionIcon = CupertinoIcons.arrow_up_right;
      directionColor = colorScheme.primary; // Blue
    }

    // ADDED: Wrapped in GestureDetector to open CallActionsSheet on long-press (hold)
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        CallActionsSheet.show(
          context: context,
          call: call,
          onAudioCall: onAudioCall,
          onVideoCall: onVideoCall,
          onSendMessage: onSendMessage ?? () {},
          onDeleteCall: onDeleteCall ?? () {},
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Avatar (28px radius)
            CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.surfaceContainerHighest,
              backgroundImage: hasAvatar ? NetworkImage(call.image) : null,
              child: hasAvatar
                  ? null
                  : Text(
                call.name.isNotEmpty ? call.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Name, Call Direction, and Timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    call.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        directionIcon,
                        color: directionColor,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${isMissed ? "Missed" : (isIncoming ? "Incoming" : "Outgoing")} • ${call.message}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isMissed
                                ? colorScheme.error
                                : colorScheme.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: isMissed
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Quick Action Buttons (Audio Call & Video Call)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Audio Call Action Button
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(36, 36),
                  onPressed: onAudioCall,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.11),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.phone_fill,
                      color: colorScheme.primary,
                      size: 17,
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                // Video Call Action Button
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(36, 36),
                  onPressed: onVideoCall,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.11),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.videocam_fill,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}