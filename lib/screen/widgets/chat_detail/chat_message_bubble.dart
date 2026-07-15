import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/chat_message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final VoidCallback? onLongPress;

  ChatMessageBubble({
    super.key,
    required this.message,
    this.onLongPress,
  });

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    String period = hour >= 12 ? 'PM' : 'AM';

    int formattedHour = hour % 12;

    if (formattedHour == 0) {
      formattedHour = 12;
    }

    String formattedMinute =
    minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute $period';
  }

  bool get _isImageMessage {
    return message.type == ChatMessageType.image &&
        message.mediaPath != null &&
        message.mediaPath!.trim().isNotEmpty;
  }

  bool get _isVoiceMessage {
    return message.type == ChatMessageType.voice;
  }

  bool get _isFileMessage {
    return message.type == ChatMessageType.file;
  }

  bool get _isLocationMessage {
    return message.type == ChatMessageType.location &&
        message.latitude != null &&
        message.longitude != null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark =
        theme.brightness == Brightness.dark;

    Color receivedBackground = isDark
        ? Color(0xFF24272D)
        : Colors.white;

    Color receivedTextColor = isDark
        ? Colors.white
        : Color(0xFF202124);

    EdgeInsets bubblePadding;

    if (_isImageMessage || _isLocationMessage) {
      bubblePadding = EdgeInsets.all(4);
    } else {
      bubblePadding = EdgeInsets.fromLTRB(
        13,
        9,
        10,
        7,
      );
    }

    return Align(
      alignment: message.isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth:
            MediaQuery.sizeOf(context).width *
                0.78,
          ),
          margin: EdgeInsets.only(
            left: message.isMe ? 55 : 12,
            right: message.isMe ? 12 : 55,
            bottom: 7,
          ),
          padding: bubblePadding,
          decoration: BoxDecoration(
            color: message.isMe
                ? AppTheme.primaryColor
                : receivedBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(
                message.isMe ? 18 : 4,
              ),
              bottomRight: Radius.circular(
                message.isMe ? 4 : 18,
              ),
            ),
            border: message.isMe
                ? null
                : Border.all(
              color: isDark
                  ? Colors.white.withValues(
                alpha: 0.05,
              )
                  : Colors.black.withValues(
                alpha: 0.05,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.12 : 0.04,
                ),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: _buildMessageContent(
            context,
            receivedTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(
      BuildContext context,
      Color receivedTextColor,
      ) {
    if (_isLocationMessage) {
      return _buildLocationMessage(
        context,
        receivedTextColor,
      );
    }

    if (_isImageMessage) {
      return _buildImageMessage(context);
    }

    if (_isVoiceMessage) {
      return ChatVoiceMessage(
        message: message,
        receivedTextColor: receivedTextColor,
        timeStatus: _buildTimeStatus(),
      );
    }

    if (_isFileMessage) {
      return _buildFileMessage(
        context,
        receivedTextColor,
      );
    }

    return _buildTextMessage(
      receivedTextColor,
    );
  }

  Widget _buildTextMessage(
      Color receivedTextColor,
      ) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.text,
            style: TextStyle(
              color: message.isMe
                  ? Colors.white
                  : receivedTextColor,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4),
          _buildTimeStatus(),
        ],
      ),
    );
  }

  Widget _buildImageMessage(
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            _openFullImage(context);
          },
          child: Hero(
            tag: message.id,
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(14),
              child: Image.file(
                File(message.mediaPath!),
                width: 240,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                    ) {
                  return Container(
                    width: 240,
                    height: 180,
                    alignment: Alignment.center,
                    color: Colors.grey.shade300,
                    child: Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Icon(
                          Icons
                              .broken_image_outlined,
                          color:
                          Colors.grey.shade700,
                          size: 42,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Image unavailable',
                          style: TextStyle(
                            color:
                            Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (message.text.trim().isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(
              8,
              8,
              8,
              2,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isMe
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
            top: 5,
            right: 5,
            bottom: 3,
          ),
          child: _buildTimeStatus(),
        ),
      ],
    );
  }

  Widget _buildFileMessage(
      BuildContext context,
      Color receivedTextColor,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    String fileName = message.text.trim();

    if (fileName.isEmpty &&
        message.mediaPath != null) {
      fileName = message.mediaPath!
          .split(Platform.pathSeparator)
          .last;
    }

    if (fileName.isEmpty) {
      fileName = 'File';
    }

    Color iconBackground = message.isMe
        ? Colors.white.withValues(alpha: 0.16)
        : colorScheme.primary.withValues(
      alpha: 0.12,
    );

    Color iconColor = message.isMe
        ? Colors.white
        : colorScheme.primary;

    Color titleColor = message.isMe
        ? Colors.white
        : receivedTextColor;

    Color subtitleColor = message.isMe
        ? Colors.white.withValues(alpha: 0.72)
        : colorScheme.onSurfaceVariant;

    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.insert_drive_file_rounded,
                  color: iconColor,
                  size: 25,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme.bodyMedium
                          ?.copyWith(
                        color: titleColor,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Document',
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: subtitleColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          _buildTimeStatus(),
        ],
      ),
    );
  }

  Widget _buildLocationMessage(
      BuildContext context,
      Color receivedTextColor,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    double latitude = message.latitude!;
    double longitude = message.longitude!;

    String coordinates =
        '${latitude.toStringAsFixed(6)}, '
        '${longitude.toStringAsFixed(6)}';

    Color locationBackground = message.isMe
        ? Colors.white.withValues(alpha: 0.13)
        : colorScheme.primary.withValues(
      alpha: 0.10,
    );

    Color titleColor = message.isMe
        ? Colors.white
        : receivedTextColor;

    Color subtitleColor = message.isMe
        ? Colors.white.withValues(alpha: 0.78)
        : colorScheme.onSurfaceVariant;

    return SizedBox(
      width: 245,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
        CrossAxisAlignment.end,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _openLocation(context);
              },
              borderRadius:
              BorderRadius.circular(14),
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: locationBackground,
                      borderRadius:
                      BorderRadius.vertical(
                        top:
                        Radius.circular(14),
                      ),
                    ),
                    child: Stack(
                      alignment:
                      Alignment.center,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter:
                            _LocationPatternPainter(
                              color: message.isMe
                                  ? Colors.white
                                  .withValues(
                                alpha: 0.10,
                              )
                                  : colorScheme
                                  .primary
                                  .withValues(
                                alpha: 0.11,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 58,
                          height: 58,
                          alignment:
                          Alignment.center,
                          decoration:
                          BoxDecoration(
                            color: message.isMe
                                ? Colors.white
                                : colorScheme
                                .primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(
                                  alpha: 0.16,
                                ),
                                blurRadius: 14,
                                offset:
                                Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons
                                .location_on_rounded,
                            color: message.isMe
                                ? AppTheme
                                .primaryColor
                                : colorScheme
                                .onPrimary,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.fromLTRB(
                      11,
                      11,
                      9,
                      4,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Text(
                                'Shared location',
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis,
                                style: theme
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  color: titleColor,
                                  fontWeight:
                                  FontWeight
                                      .w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                coordinates,
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis,
                                style: theme
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color:
                                  subtitleColor,
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Tap to open map',
                                style: theme
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color:
                                  subtitleColor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons
                              .open_in_new_rounded,
                          size: 18,
                          color: subtitleColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              right: 5,
              bottom: 3,
            ),
            child: _buildTimeStatus(),
          ),
        ],
      ),
    );
  }

  Future<void> _openLocation(
      BuildContext context,
      ) async {
    double? latitude = message.latitude;
    double? longitude = message.longitude;

    if (latitude == null ||
        longitude == null) {
      _showSnackBar(
        context,
        'Location information is unavailable.',
      );

      return;
    }

    Uri mapUri = Uri.parse(
      'https://www.google.com/maps/search/'
          '?api=1&query=$latitude,$longitude',
    );

    try {
      bool didOpen = await launchUrl(
        mapUri,
        mode: LaunchMode.externalApplication,
      );

      if (!didOpen && context.mounted) {
        _showSnackBar(
          context,
          'Could not open the map.',
        );
      }
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showSnackBar(
        context,
        'Could not open the map.',
      );
    }
  }

  void _showSnackBar(
      BuildContext context,
      String text,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }

  Widget _buildTimeStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.sentAt),
          style: TextStyle(
            color: message.isMe
                ? Colors.white.withValues(
              alpha: 0.75,
            )
                : Colors.grey,
            fontSize: 9,
            height: 1,
          ),
        ),
        if (message.isMe) ...[
          SizedBox(width: 3),
          Icon(
            message.isRead
                ? Icons.done_all_rounded
                : Icons.done_rounded,
            size: 14,
            color: message.isRead
                ? Color(0xFFB9F6CA)
                : Colors.white.withValues(
              alpha: 0.75,
            ),
          ),
        ],
      ],
    );
  }

  void _openFullImage(
      BuildContext context,
      ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (
            BuildContext context,
            ) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              title: Text('Photo'),
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 5,
                child: Hero(
                  tag: message.id,
                  child: Image.file(
                    File(message.mediaPath!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatVoiceMessage extends StatefulWidget {
  final ChatMessageModel message;
  final Color receivedTextColor;
  final Widget timeStatus;

  ChatVoiceMessage({
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

class _ChatVoiceMessageState
    extends State<ChatVoiceMessage> {
  final AudioPlayer _audioPlayer =
  AudioPlayer();

  Duration _duration = Duration.zero;

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _loadVoice();
  }

  Future<void> _loadVoice() async {
    String? audioPath =
        widget.message.mediaPath;

    if (audioPath == null ||
        audioPath.trim().isEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      return;
    }

    try {
      Duration? loadedDuration;

      Uri? uri = Uri.tryParse(audioPath);

      if (uri != null &&
          (uri.scheme == 'http' ||
              uri.scheme == 'https')) {
        loadedDuration =
        await _audioPlayer.setUrl(
          audioPath,
        );
      } else if (uri != null &&
          uri.scheme == 'file') {
        loadedDuration =
        await _audioPlayer.setFilePath(
          uri.toFilePath(),
        );
      } else {
        File audioFile = File(audioPath);

        bool exists =
        await audioFile.exists();

        if (!exists) {
          throw Exception(
            'Voice file not found.',
          );
        }

        loadedDuration =
        await _audioPlayer.setFilePath(
          audioPath,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _duration =
            loadedDuration ?? Duration.zero;

        _isLoading = false;
        _hasError = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _togglePlayback() async {
    if (_isLoading || _hasError) {
      return;
    }

    try {
      if (_audioPlayer.processingState ==
          ProcessingState.completed) {
        await _audioPlayer.seek(
          Duration.zero,
        );
      }

      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        unawaited(_audioPlayer.play());
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _hasError = true;
      });
    }
  }

  Future<void> _seek(
      double milliseconds,
      ) async {
    if (_duration == Duration.zero) {
      return;
    }

    await _audioPlayer.seek(
      Duration(
        milliseconds:
        milliseconds.round(),
      ),
    );
  }

  String _formatDuration(
      Duration duration,
      ) {
    int minutes = duration.inMinutes;

    int seconds =
    duration.inSeconds.remainder(60);

    return '$minutes:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isMe = widget.message.isMe;

    Color primaryTextColor = isMe
        ? Colors.white
        : widget.receivedTextColor;

    Color secondaryTextColor = isMe
        ? Colors.white.withValues(alpha: 0.72)
        : colorScheme.onSurfaceVariant;

    Color buttonBackground = isMe
        ? Colors.white
        : colorScheme.primary;

    Color buttonForeground = isMe
        ? AppTheme.primaryColor
        : colorScheme.onPrimary;

    if (_hasError) {
      return SizedBox(
        width: 230,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white
                        .withValues(
                      alpha: 0.14,
                    )
                        : colorScheme.error
                        .withValues(
                      alpha: 0.10,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons
                        .error_outline_rounded,
                    color: isMe
                        ? Colors.white
                        : colorScheme.error,
                    size: 22,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Voice unavailable',
                    style: theme
                        .textTheme.bodyMedium
                        ?.copyWith(
                      color: primaryTextColor,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            widget.timeStatus,
          ],
        ),
      );
    }

    return SizedBox(
      width: 240,
      child: StreamBuilder<PlayerState>(
        stream:
        _audioPlayer.playerStateStream,
        builder: (
            BuildContext context,
            AsyncSnapshot<PlayerState> snapshot,
            ) {
          PlayerState? playerState =
              snapshot.data;

          bool isPlaying =
              playerState?.playing ?? false;

          if (playerState
              ?.processingState ==
              ProcessingState.completed) {
            isPlaying = false;
          }

          return StreamBuilder<Duration>(
            stream:
            _audioPlayer.positionStream,
            initialData: Duration.zero,
            builder: (
                BuildContext context,
                AsyncSnapshot<Duration> snapshot,
                ) {
              Duration position =
                  snapshot.data ?? Duration.zero;

              int durationMilliseconds =
                  _duration.inMilliseconds;

              double maximum =
              durationMilliseconds > 0
                  ? durationMilliseconds
                  .toDouble()
                  : 1;

              double value = position
                  .inMilliseconds
                  .clamp(
                0,
                durationMilliseconds > 0
                    ? durationMilliseconds
                    : 0,
              )
                  .toDouble();

              return Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Material(
                        color:
                        buttonBackground,
                        shape: CircleBorder(),
                        child: InkWell(
                          onTap: _isLoading
                              ? null
                              : _togglePlayback,
                          customBorder:
                          CircleBorder(),
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: _isLoading
                                ? Padding(
                              padding:
                              EdgeInsets.all(
                                12,
                              ),
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                buttonForeground,
                              ),
                            )
                                : Icon(
                              isPlaying
                                  ? Icons
                                  .pause_rounded
                                  : Icons
                                  .play_arrow_rounded,
                              color:
                              buttonForeground,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(
                                context,
                              ).copyWith(
                                trackHeight: 2.5,
                                activeTrackColor: isMe
                                    ? Colors.white
                                    : colorScheme
                                    .primary,
                                inactiveTrackColor:
                                secondaryTextColor
                                    .withValues(
                                  alpha: 0.30,
                                ),
                                thumbColor: isMe
                                    ? Colors.white
                                    : colorScheme
                                    .primary,
                                thumbShape:
                                RoundSliderThumbShape(
                                  enabledThumbRadius:
                                  5,
                                ),
                                overlayShape:
                                RoundSliderOverlayShape(
                                  overlayRadius: 12,
                                ),
                              ),
                              child: Slider(
                                min: 0,
                                max: maximum,
                                value: value,
                                onChanged:
                                _isLoading ||
                                    durationMilliseconds <=
                                        0
                                    ? null
                                    : _seek,
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(
                                      position,
                                    ),
                                    style: theme
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color:
                                      secondaryTextColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight
                                          .w500,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(
                                      _duration,
                                    ),
                                    style: theme
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color:
                                      secondaryTextColor,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight
                                          .w500,
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
                  SizedBox(height: 5),
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

class _LocationPatternPainter
    extends CustomPainter {
  final Color color;

  _LocationPatternPainter({
    required this.color,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    double spacing = 24;

    for (
    double x = -size.height;
    x < size.width;
    x += spacing
    ) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(
          x + size.height,
          size.height,
        ),
        paint,
      );
    }

    for (
    double y = spacing;
    y < size.height;
    y += spacing
    ) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      _LocationPatternPainter oldDelegate,
      ) {
    return oldDelegate.color != color;
  }
}