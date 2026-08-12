import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'profile_content_card.dart';

class ProfileMockVoiceContent extends StatelessWidget {
  ProfileMockVoiceContent({super.key});

  final voiceMessages = <_MockVoiceItem>[
    _MockVoiceItem('0:18', 'Today, 10:14 AM', 0.72),
    _MockVoiceItem('0:42', 'Yesterday, 4:36 PM', 0.38),
    _MockVoiceItem('1:05', 'Jul 21, 11:05 AM', 0.56),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < voiceMessages.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == voiceMessages.length - 1 ? 0 : 8),
            child: _ProfileVoiceCard(voice: voiceMessages[i]),
          ),
      ],
    );
  }
}

class _ProfileVoiceCard extends StatelessWidget {
  final _MockVoiceItem voice;

  const _ProfileVoiceCard({required this.voice});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ProfileContentCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
            child: Icon(CupertinoIcons.play_fill, color: colors.onPrimary, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: voice.progress,
                          minHeight: 4,
                          backgroundColor: colors.primary.withValues(alpha: 0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      voice.duration,
                      style: TextStyle(color: colors.onSurface, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  voice.date,
                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(CupertinoIcons.ellipsis, color: colors.onSurfaceVariant, size: 18),
        ],
      ),
    );
  }
}

class _MockVoiceItem {
  final String duration;
  final String date;
  final double progress;

  _MockVoiceItem(this.duration, this.date, this.progress);
}
