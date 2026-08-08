import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/chat_message_model.dart';

/// UPDATED: Unit UI voice player with playback speed toggles (1x/1.5x/2x) and audio seeking
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
  State<ChatVoiceMessage> createState() {
    return _ChatVoiceMessageState();
  }
}

class _ChatVoiceMessageState extends State<ChatVoiceMessage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;

  bool _isLoading = true;
  bool _hasError = false;

  static const List<double> _speeds = [1.0, 1.5, 2.0];
  int _speedIndex = 0;

  bool _isSeeking = false;
  double _seekPreviewValue = 0;

  @override
  void initState() {
    super.initState();
    _loadVoice();
  }

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
      Uri? uri = Uri.tryParse(audioPath);

      if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
        loadedDuration = await _audioPlayer.setUrl(audioPath);
      } else if (uri != null && uri.scheme == 'file') {
        loadedDuration = await _audioPlayer.setFilePath(uri.toFilePath());
      } else {
        File audioFile = File(audioPath);
        bool exists = await audioFile.exists();
        if (!exists) throw Exception('Voice file not found.');
        loadedDuration = await _audioPlayer.setFilePath(audioPath);
      }

      if (!mounted) return;
      setState(() {
        _duration = loadedDuration ?? Duration.zero;
        _isLoading = false;
        _hasError = false;
      });
    } catch (_) {
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

  Future<void> _cycleSpeed() async {
    if (_isLoading || _hasError) return;
    HapticFeedback.selectionClick();

    setState(() {
      _speedIndex = (_speedIndex + 1) % _speeds.length;
    });

    try {
      await _audioPlayer.setSpeed(_speeds[_speedIndex]);
    } catch (_) {}
  }

  Future<void> _seek(double milliseconds) async {
    if (_duration == Duration.zero) return;
    await _audioPlayer.seek(
      Duration(milliseconds: milliseconds.round()),
    );
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

    Color primaryTextColor = isMe ? Colors.white : widget.receivedTextColor;
    Color secondaryTextColor = isMe
        ? Colors.white.withValues(alpha: 0.72)
        : colorScheme.onSurfaceVariant;

    Color buttonBackground = isMe ? Colors.white : colorScheme.primary;
    Color buttonForeground =
    isMe ? AppTheme.primaryColor : colorScheme.onPrimary;

    if (_hasError) {
      return SizedBox(
        width: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
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
                      color: primaryTextColor,
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
      width: 240,
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
              int durationMilliseconds = _duration.inMilliseconds;
              double maximum = durationMilliseconds > 0
                  ? durationMilliseconds.toDouble()
                  : 1;

              double value = _isSeeking
                  ? _seekPreviewValue
                  : position.inMilliseconds
                  .clamp(0,
                  durationMilliseconds > 0 ? durationMilliseconds : 0)
                  .toDouble();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Material(
                        color: buttonBackground,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: _isLoading ? null : _togglePlayback,
                          customBorder: const CircleBorder(),
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: _isLoading
                                ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: buttonForeground,
                              ),
                            )
                                : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: isPlaying
                                  ? Icon(
                                CupertinoIcons.pause_fill,
                                key: const ValueKey('pause'),
                                color: buttonForeground,
                                size: 22,
                              )
                                  : Icon(
                                CupertinoIcons.play_fill,
                                key: const ValueKey('play'),
                                color: buttonForeground,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 2.5,
                                activeTrackColor:
                                isMe ? Colors.white : colorScheme.primary,
                                inactiveTrackColor:
                                secondaryTextColor.withValues(alpha: 0.30),
                                thumbColor:
                                isMe ? Colors.white : colorScheme.primary,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 5,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 12,
                                ),
                              ),
                              child: Slider(
                                min: 0,
                                max: maximum,
                                value: value.clamp(0, maximum),
                                onChangeStart:
                                _isLoading || durationMilliseconds <= 0
                                    ? null
                                    : (double start) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _isSeeking = true;
                                    _seekPreviewValue = start;
                                  });
                                },
                                onChanged:
                                _isLoading || durationMilliseconds <= 0
                                    ? null
                                    : (double dragging) {
                                  setState(() {
                                    _seekPreviewValue = dragging;
                                  });
                                },
                                onChangeEnd:
                                _isLoading || durationMilliseconds <= 0
                                    ? null
                                    : (double end) {
                                  setState(() {
                                    _isSeeking = false;
                                  });
                                  _seek(end);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(
                                      _isSeeking
                                          ? Duration(
                                        milliseconds:
                                        _seekPreviewValue.round(),
                                      )
                                          : position,
                                    ),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: secondaryTextColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _cycleSpeed,
                                    child: Text(
                                      isPlaying || _speedIndex != 0
                                          ? '${_speeds[_speedIndex] == _speeds[_speedIndex].roundToDouble() ? _speeds[_speedIndex].round() : _speeds[_speedIndex]}x'
                                          : _formatDuration(_duration),
                                      style:
                                      theme.textTheme.bodySmall?.copyWith(
                                        color: secondaryTextColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  widget.timeStatus,
                ],
              );
            },
          );
        },
      ),
    );
  }
}