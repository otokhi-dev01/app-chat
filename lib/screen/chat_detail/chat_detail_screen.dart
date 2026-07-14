import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/chat_message_model.dart';
import '../../models/chat_model.dart';
import '../../services/chat_camera_services.dart';
import '../widgets/chat_detail/chat_attachment_item.dart';
import '../widgets/chat_detail/chat_date_divider.dart';
import '../widgets/chat_detail/chat_detail_app_bar.dart';
import '../widgets/chat_detail/chat_empty_conversation.dart';
import '../widgets/chat_detail/chat_input_bar.dart';
import '../widgets/chat_detail/chat_message_bubble.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatModel chat;

  ChatDetailScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatDetailScreen> createState() {
    return _ChatDetailScreenState();
  }
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late final TextEditingController messageController;
  late final ScrollController scrollController;
  late final FocusNode messageFocusNode;

  final List<ChatMessageModel> messages = [];

  final ChatCameraService cameraService =
  ChatCameraService();

  bool isRecordingVoice = false;
  bool isTapRecordingMode = false;

  double voiceDragDx = 0;

  static final double cancelDragThreshold = -80;

  @override
  void initState() {
    super.initState();

    messageController = TextEditingController();
    scrollController = ScrollController();
    messageFocusNode = FocusNode();

    messageFocusNode.addListener(
      _handleMessageFocusChange,
    );

    _loadSampleMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(
        animated: false,
      );
    });
  }

  void _handleMessageFocusChange() {
    if (messageFocusNode.hasFocus) {
      Future.delayed(
        Duration(milliseconds: 250),
            () {
          if (!mounted) {
            return;
          }

          _scrollToBottom();
        },
      );
    }
  }

  void _loadSampleMessages() {
    DateTime now = DateTime.now();

    messages.addAll([
      ChatMessageModel(
        id: 'message-1',
        text: 'Hello! How are you?',
        sentAt: now.subtract(
          Duration(minutes: 24),
        ),
        isMe: false,
      ),
      ChatMessageModel(
        id: 'message-2',
        text:
        'I am doing well. I am currently working on the chat application.',
        sentAt: now.subtract(
          Duration(minutes: 21),
        ),
        isMe: true,
        isRead: true,
      ),
      ChatMessageModel(
        id: 'message-3',
        text: 'That sounds great. How is it going?',
        sentAt: now.subtract(
          Duration(minutes: 18),
        ),
        isMe: false,
      ),
      ChatMessageModel(
        id: 'message-4',
        text: widget.chat.message,
        sentAt: widget.chat.dateTime,
        isMe: widget.chat.isMe,
        isRead: true,
      ),
    ]);
  }

  void _sendMessage() {
    String text = messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    HapticFeedback.lightImpact();

    ChatMessageModel newMessage =
    ChatMessageModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      text: text,
      sentAt: DateTime.now(),
      isMe: true,
      isRead: false,
    );

    setState(() {
      messages.add(newMessage);
    });

    messageController.clear();

    _scrollToBottom();
  }

  Future<void> _openCamera() async {
    if (cameraService.isOpeningCamera) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      ChatMessageModel? photoMessage =
      await cameraService.takePhoto();

      if (!mounted || photoMessage == null) {
        return;
      }

      setState(() {
        messages.add(photoMessage);
      });

      _scrollToBottom();
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      _showSnackBar(
        message:
        'Camera error: ${error.message ?? error.code}',
        isError: true,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnackBar(
        message: 'Could not open camera: $error',
        isError: true,
      );
    }
  }

  void _onVoiceTap() {
    if (isRecordingVoice) {
      return;
    }

    HapticFeedback.lightImpact();

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      isRecordingVoice = true;
      isTapRecordingMode = true;
      voiceDragDx = 0;
    });

    // TODO:
    // Start actual audio recording here.
  }

  void _onVoiceStart() {
    if (isRecordingVoice) {
      return;
    }

    HapticFeedback.lightImpact();

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      isRecordingVoice = true;
      isTapRecordingMode = false;
      voiceDragDx = 0;
    });

    // TODO:
    // Start actual audio recording here.
  }

  void _onVoiceDrag(double dx) {
    if (!isRecordingVoice ||
        isTapRecordingMode) {
      return;
    }

    setState(() {
      voiceDragDx = dx;
    });
  }

  void _onVoiceEnd() {
    if (!isRecordingVoice ||
        isTapRecordingMode) {
      return;
    }

    bool shouldCancel =
        voiceDragDx <= cancelDragThreshold;

    if (shouldCancel) {
      _cancelVoiceRecording();
    } else {
      _sendVoiceRecording(
        Duration.zero,
      );
    }
  }

  void _cancelVoiceRecording() {
    if (!isRecordingVoice) {
      return;
    }

    HapticFeedback.lightImpact();

    // TODO:
    // Stop recorder and delete temporary audio file.

    setState(() {
      isRecordingVoice = false;
      isTapRecordingMode = false;
      voiceDragDx = 0;
    });
  }

  void _sendVoiceRecording(
      Duration duration,
      ) {
    if (!isRecordingVoice) {
      return;
    }

    // TODO:
    // Stop the recorder and get the saved audio path.
    //
    // String? audioPath = await recorder.stop();

    ChatMessageModel voiceMessage =
    ChatMessageModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      text: '',
      sentAt: DateTime.now(),
      isMe: true,
      isRead: false,
    );

    HapticFeedback.mediumImpact();

    setState(() {
      isRecordingVoice = false;
      isTapRecordingMode = false;
      voiceDragDx = 0;

      messages.add(voiceMessage);
    });

    _scrollToBottom();
  }

  void _scrollToBottom({
    bool animated = true,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !scrollController.hasClients) {
        return;
      }

      double target =
          scrollController.position.maxScrollExtent;

      if (animated) {
        scrollController.animateTo(
          target,
          duration: Duration(
            milliseconds: 280,
          ),
          curve: Curves.easeOutCubic,
        );
      } else {
        scrollController.jumpTo(target);
      }
    });
  }

  void _showAttachmentOptions() {
    FocusManager.instance.primaryFocus?.unfocus();

    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color sheetColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor:
      Colors.black.withValues(alpha: 0.35),
      builder: (BuildContext sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
            border: Border(
              top: BorderSide(
                color: borderColor,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.25),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),

                  SizedBox(height: 18),

                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colorScheme.primary
                              .withValues(alpha: 0.11),
                          borderRadius:
                          BorderRadius.circular(13),
                        ),
                        child: Icon(
                          Icons.attach_file_rounded,
                          color: colorScheme.primary,
                          size: 22,
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          'Share content',
                          style: theme
                              .textTheme.titleMedium
                              ?.copyWith(
                            color:
                            colorScheme.onSurface,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ),

                      IconButton(
                        tooltip: 'Close',
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                          );
                        },
                        icon: Icon(
                          Icons.close_rounded,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      ChatAttachmentItem(
                        icon: Icons.image_outlined,
                        label: 'Gallery',
                        onTap: () {
                          Navigator.pop(
                            sheetContext,
                          );

                          // TODO:
                          // Open image gallery.
                        },
                      ),
                      ChatAttachmentItem(
                        icon:
                        Icons.camera_alt_outlined,
                        label: 'Camera',
                        onTap: () {
                          Navigator.pop(
                            sheetContext,
                          );

                          _openCamera();
                        },
                      ),
                      ChatAttachmentItem(
                        icon: Icons
                            .insert_drive_file_outlined,
                        label: 'File',
                        onTap: () {
                          Navigator.pop(
                            sheetContext,
                          );

                          // TODO:
                          // Open file picker.
                        },
                      ),
                      ChatAttachmentItem(
                        icon:
                        Icons.location_on_outlined,
                        label: 'Location',
                        onTap: () {
                          Navigator.pop(
                            sheetContext,
                          );

                          // TODO:
                          // Open location picker.
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMessageActions(
      ChatMessageModel message,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color sheetColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor:
      Colors.black.withValues(alpha: 0.35),
      builder: (BuildContext sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
            border: Border(
              top: BorderSide(
                color: borderColor,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                12,
                12,
                12,
                16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.25),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),

                  SizedBox(height: 12),

                  _MessageActionTile(
                    icon: Icons.copy_rounded,
                    title: 'Copy',
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: message.text,
                        ),
                      );

                      Navigator.pop(
                        sheetContext,
                      );

                      _showSnackBar(
                        message: 'Message copied',
                      );
                    },
                  ),

                  _MessageActionTile(
                    icon: Icons.reply_rounded,
                    title: 'Reply',
                    onTap: () {
                      Navigator.pop(
                        sheetContext,
                      );

                      Future.delayed(
                        Duration(
                          milliseconds: 150,
                        ),
                            () {
                          if (!mounted) {
                            return;
                          }

                          messageFocusNode
                              .requestFocus();
                        },
                      );
                    },
                  ),

                  if (message.isMe)
                    _MessageActionTile(
                      icon: Icons
                          .delete_outline_rounded,
                      title: 'Delete',
                      isDanger: true,
                      onTap: () {
                        Navigator.pop(
                          sheetContext,
                        );

                        setState(() {
                          messages.removeWhere(
                                (
                                ChatMessageModel item,
                                ) {
                              return item.id ==
                                  message.id;
                            },
                          );
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleMenu(String value) {
    switch (value) {
      case 'clear':
        setState(() {
          messages.clear();
        });
        break;

      case 'search':
        _showSnackBar(
          message: 'Search messages selected',
        );
        break;

      case 'mute':
        _showSnackBar(
          message: widget.chat.isMuted
              ? 'Notifications unmuted'
              : 'Notifications muted',
        );
        break;

      case 'view_profile':
        _showSnackBar(
          message:
          'Open ${widget.chat.name} profile',
        );
        break;
    }
  }

  void _showSnackBar({
    required String message,
    bool isError = false,
  }) {
    if (!mounted) {
      return;
    }

    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          backgroundColor: isError
              ? colorScheme.error
              : colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  void dispose() {
    messageFocusNode.removeListener(
      _handleMessageFocusChange,
    );

    messageFocusNode.unfocus();

    messageController.dispose();
    scrollController.dispose();
    messageFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    double appBarSpace =
        MediaQuery.paddingOf(context).top + 68;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: ChatDetailAppBar(
        chat: widget.chat,
        onAudioCall: () {
          _showSnackBar(
            message: 'Calling ${widget.chat.name}...',
          );
        },
        onMenuSelected: _handleMenu,
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: Duration(
                milliseconds: 250,
              ),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: messages.isEmpty
                  ? KeyedSubtree(
                key: ValueKey(
                  'empty-conversation',
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: appBarSpace,
                    bottom: 100,
                  ),
                  child: ChatEmptyConversation(
                    name: widget.chat.name,
                  ),
                ),
              )
                  : ListView.builder(
                key: ValueKey(
                  'message-list',
                ),
                controller: scrollController,
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,
                padding: EdgeInsets.fromLTRB(
                  0,
                  appBarSpace + 8,
                  0,
                  108,
                ),
                itemCount: messages.length + 1,
                itemBuilder: (
                    BuildContext context,
                    int index,
                    ) {
                  if (index == 0) {
                    return ChatDateDivider(
                      label: 'Today',
                    );
                  }

                  ChatMessageModel message =
                  messages[index - 1];

                  return KeyedSubtree(
                    key: ValueKey(
                      message.id,
                    ),
                    child: ChatMessageBubble(
                      message: message,
                      onLongPress: () {
                        _showMessageActions(
                          message,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ChatInputBar(
              key: ValueKey(
                'chat-input-bar',
              ),
              controller: messageController,
              focusNode: messageFocusNode,
              onSend: _sendMessage,
              onAttachment:
              _showAttachmentOptions,
              onCamera: _openCamera,

              isRecording:
              isRecordingVoice,
              isHoldRecording:
              isRecordingVoice &&
                  !isTapRecordingMode,
              voiceDragDx:
              voiceDragDx,
              cancelThreshold:
              cancelDragThreshold,

              onVoiceTap:
              _onVoiceTap,
              onVoiceStart:
              _onVoiceStart,
              onVoiceDrag:
              _onVoiceDrag,
              onVoiceEnd:
              _onVoiceEnd,
              onVoiceCancel:
              _cancelVoiceRecording,
              onVoiceSend:
              _sendVoiceRecording,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDanger;

  _MessageActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color itemColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(14),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 9,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: itemColor.withValues(
                    alpha: 0.11,
                  ),
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: itemColor,
                  size: 21,
                ),
              ),

              SizedBox(width: 13),

              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(
                    color: isDanger
                        ? colorScheme.error
                        : colorScheme.onSurface,
                    fontWeight:
                    FontWeight.w600,
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