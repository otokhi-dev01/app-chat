import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import '../../../models/chat_message_model.dart';

/// REPLACED: Modern Voice Message Bubble (Replaces old Slider UI with Waveform Visualizer + Soft Pink Play Button + Transcript)
class ChatVoiceMessage extends StatefulWidget {
  final ChatMessageModel message;
  final Color receivedTextColor;
  final Widget timeStatus;

  const ChatVoiceMessage({
    super.key,
    required this.message,
    required this.receivedTextColor,
    required this.timeStatus,
  });

  @override
  State<ChatVoiceMessage> createState() => _ChatVoiceMessageState();
}

class _ChatVoiceMessageState extends State<ChatVoiceMessage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;

  bool _isLoading = true;
  bool _hasError = false;

  // REPLACED: Vertical waveform bar heights replacing the old Slider line
  static const List<double> _waveformHeights = [
    6, 10, 14, 8, 18, 22, 12, 16, 20, 10, 14, 18, 24, 20, 14, 10, 16, 22, 18,
    12, 8, 14, 10, 6, 12, 8, 16, 10, 6
  ];

  @override
  void initState() {
    super.initState();
    _loadVoice();
  }

  /// FIXED: Audio loading logic supporting local file paths & URIs safely
  Future<void> _loadVoice() async {
    String? audioPath = widget.message.mediaPath;

    if (audioPath == null || audioPath.trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    try {
      Duration? loadedDuration;
      String cleanPath = audioPath.trim();

      if (cleanPath.startsWith('file://')) {
        cleanPath = Uri.parse(cleanPath).toFilePath();
      }

      if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
        loadedDuration = await _audioPlayer.setUrl(cleanPath);
      } else {
        File file = File(cleanPath);

        if (!await file.exists()) {
          await Future.delayed(const Duration(milliseconds: 100));
        }

        if (await file.exists()) {
          loadedDuration = await _audioPlayer.setAudioSource(
            AudioSource.uri(Uri.file(file.path)),
          );
        } else {
          throw Exception('Voice file not found at path: $cleanPath');
        }
      }

      if (!mounted) return;

      setState(() {
        _duration = loadedDuration ?? _audioPlayer.duration ?? Duration.zero;
        _isLoading = false;
        _hasError = false;
      });
    } catch (error) {
      debugPrint('Error loading voice message: $error');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _togglePlayback() async {
    if (_isLoading || _hasError) return;
    HapticFeedback.selectionClick();

    try {
      if (_audioPlayer.processingState == ProcessingState.completed) {
        await _audioPlayer.seek(Duration.zero);
      }
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        unawaited(_audioPlayer.play());
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
    }
  }

  /// ADDED: Tap & Drag gesture seeking across the waveform bars
  void _seekToPercent(double percent) {
    if (_duration == Duration.zero) return;
    int targetMs = (_duration.inMilliseconds * percent.clamp(0.0, 1.0)).round();
    _audioPlayer.seek(Duration(milliseconds: targetMs));
  }

  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isMe = widget.message.isMe;

    // REPLACED: Soft pink circular play button background (matches target design)
    Color playButtonBg = isMe
        ? Colors.white.withValues(alpha: 0.25)
        : const Color(0xFFFDE8EC);

    Color playIconColor = isMe ? Colors.white : const Color(0xFF2C3E50);

    Color activeWaveColor = isMe ? Colors.white : const Color(0xFF1E293B);

    Color inactiveWaveColor = isMe
        ? Colors.white.withValues(alpha: 0.38)
        : const Color(0xFFCBD5E1);

    Color textColor = isMe
        ? Colors.white.withValues(alpha: 0.82)
        : const Color(0xFF64748B);

    if (_hasError) {
      return SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.14)
                        : colorScheme.error.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.exclamationmark_circle,
                    color: isMe ? Colors.white : colorScheme.error,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Voice unavailable',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isMe ? Colors.white : widget.receivedTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            widget.timeStatus,
          ],
        ),
      );
    }

    return SizedBox(
      width: 250,
      child: StreamBuilder<PlayerState>(
        stream: _audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          PlayerState? playerState = snapshot.data;
          bool isPlaying = playerState?.playing ?? false;

          if (playerState?.processingState == ProcessingState.completed) {
            isPlaying = false;
          }

          return StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            initialData: Duration.zero,
            builder: (context, snapshot) {
              Duration position = snapshot.data ?? Duration.zero;
              double progress = _duration.inMilliseconds > 0
                  ? (position.inMilliseconds / _duration.inMilliseconds)
                  .clamp(0.0, 1.0)
                  : 0.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // REPLACED: Top Row - Soft Pink Play Button + Audio Waveform Visualizer
                  Row(
                    children: [
                      // REPLACED: Circular soft-pink play/pause button
                      GestureDetector(
                        onTap: _isLoading ? null : _togglePlayback,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: playButtonBg,
                            shape: BoxShape.circle,
                          ),
                          child: _isLoading
                              ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: playIconColor,
                            ),
                          )
                              : Icon(
                            isPlaying
                                ? CupertinoIcons.pause_fill
                                : CupertinoIcons.play_fill,
                            color: playIconColor,
                            size: 20,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // REPLACED: Vertical waveform visualizer bars replacing old Slider line
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (details) {
                            RenderBox? box =
                            context.findRenderObject() as RenderBox?;
                            if (box != null) {
                              double dx = details.localPosition.dx;
                              _seekToPercent(dx / box.size.width);
                            }
                          },
                          onHorizontalDragUpdate: (details) {
                            RenderBox? box =
                            context.findRenderObject() as RenderBox?;
                            if (box != null) {
                              double dx = details.localPosition.dx;
                              _seekToPercent(dx / box.size.width);
                            }
                          },
                          child: SizedBox(
                            height: 28,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                _waveformHeights.length,
                                    (index) {
                                  double barProgress =
                                      (index + 1) / _waveformHeights.length;
                                  bool isPlayed = barProgress <= progress;

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    width: 2.8,
                                    height: _waveformHeights[index],
                                    decoration: BoxDecoration(
                                      color: isPlayed
                                          ? activeWaveColor
                                          : inactiveWaveColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // REPLACED: Bottom Row - Transcript Text Preview & Duration Timestamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // REPLACED: Transcript preview text ("Generating transcript..." or transcribed text)
                      Expanded(
                        child: Text(
                          widget.message.text.trim().isNotEmpty
                              ? widget.message.text
                              : 'Generating transcript...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // REPLACED: Duration timestamp on right (e.g., 0:03 or 00:23)
                      Text(
                        _formatDuration(isPlaying ? position : _duration),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // ADDED: Timestamp and read status ticks at bottom right
                  Align(
                    alignment: Alignment.centerRight,
                    child: widget.timeStatus,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}