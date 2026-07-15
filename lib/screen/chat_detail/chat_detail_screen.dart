import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/chat_message_model.dart';
import '../../models/chat_model.dart';
import '../../services/chat_camera_services.dart';
import '../../services/chat_voice_recorder_service.dart';
import '../widgets/chat_detail/chat_attachment_sheet.dart';
import '../widgets/chat_detail/chat_voice_message.dart';
import 'chat_detail_app_bar.dart';
import '../widgets/chat_detail/chat_detail_content.dart';
import '../widgets/chat_detail/chat_message_action_sheet.dart';
import '../widgets/chat_detail/chat_sample_messages.dart';
import 'package:get/get.dart';
import 'chat_message_search_screen.dart';

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

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with WidgetsBindingObserver {
  late final TextEditingController messageController;

  late final ScrollController scrollController;
  late final FocusNode messageFocusNode;

  final List<ChatMessageModel> messages = [];

  final ChatCameraService cameraService = ChatCameraService();

  final ChatVoiceRecorderService voiceRecorderService =
  ChatVoiceRecorderService();

  DateTime? voiceRecordingStartedAt;

  bool isRecordingVoice = false;
  bool isTapRecordingMode = false;

  double voiceDragDx = 0;

  static final double cancelDragThreshold = -80;

  double _lastBottomInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    messageController = TextEditingController();

    scrollController = ScrollController();
    messageFocusNode = FocusNode();

    messageFocusNode.addListener(
      _handleMessageFocusChange,
    );

    messages.addAll(
      buildChatSampleMessages(widget.chat),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(
        animated: false,
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    messageFocusNode.removeListener(
      _handleMessageFocusChange,
    );

    messageFocusNode.unfocus();

    messageController.dispose();
    scrollController.dispose();
    messageFocusNode.dispose();

    if (isRecordingVoice) {
      voiceRecorderService.cancelRecording();
    }

    voiceRecorderService.dispose();

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) return;

    final double currentBottomInset =
        MediaQuery.maybeOf(context)?.viewInsets.bottom ?? 0;

    if (currentBottomInset > _lastBottomInset && currentBottomInset > 0) {
      _scrollToBottom(animated: true, durationMs: 180);
    }
    _lastBottomInset = currentBottomInset;
  }

  void _handleMessageFocusChange() {
    if (!messageFocusNode.hasFocus) {
      return;
    }

    Future<void>.delayed(
      const Duration(milliseconds: 100),
          () {
        if (!mounted) {
          return;
        }
        _scrollToBottom(animated: true, durationMs: 200);
      },
    );
  }

  void _sendMessage() {
    String text = messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    HapticFeedback.lightImpact();

    ChatMessageModel newMessage = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      sentAt: DateTime.now(),
      isMe: true,
      isRead: false,
    );

    setState(() {
      messages.add(newMessage);
    });

    messageController.clear();

    // Synchronously maintain focus on the text field
    messageFocusNode.requestFocus();

    _scrollToBottom();
  }

  Future<void> _openMessageSearch() async {
    FocusManager.instance.primaryFocus?.unfocus();

    String? selectedMessageId = await Get.to<String>(
          () {
        return ChatMessageSearchScreen(
          chatName: widget.chat.name,
          messages: List<ChatMessageModel>.from(
            messages,
          ),
        );
      },
      transition: Transition.cupertino,
      duration: Duration(milliseconds: 280),
    );

    if (!mounted || selectedMessageId == null) {
      return;
    }

    int messageIndex = messages.indexWhere(
          (ChatMessageModel message) {
        return message.id == selectedMessageId;
      },
    );

    if (messageIndex < 0) {
      return;
    }

    _scrollToSearchResult(messageIndex);
  }

  void _scrollToSearchResult(
      int messageIndex,
      ) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!mounted ||
            !scrollController.hasClients ||
            messages.isEmpty) {
          return;
        }

        double maxScrollExtent =
            scrollController.position.maxScrollExtent;

        double scrollPercent;

        if (messages.length <= 1) {
          scrollPercent = 0;
        } else {
          scrollPercent =
              messageIndex / (messages.length - 1);
        }

        double targetOffset =
            maxScrollExtent * scrollPercent;

        targetOffset = targetOffset.clamp(
          0,
          maxScrollExtent,
        );

        scrollController.animateTo(
          targetOffset,
          duration: Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        );
      },
    );
  }

  Future<void> _confirmClearConversation() async {
    bool? shouldClear = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'Clear conversation?',
        ),
        content: Text(
          'All messages in this conversation will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text(
              'Cancel',
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text(
              'Clear',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (!mounted || shouldClear != true) {
      return;
    }

    setState(() {
      messages.clear();
    });

    _showSnackBar(
      message: 'Conversation cleared',
    );
  }

  Future<void> _openCamera() async {
    if (cameraService.isOpeningCamera) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      ChatMessageModel? photoMessage = await cameraService.takePhoto();

      if (!mounted || photoMessage == null) {
        return;
      }

      setState(() {
        messages.add(photoMessage);
      });

      _scrollToBottom();
    } on PlatformException catch (error) {
      _showSnackBar(
        message: 'Camera error: ${error.message ?? error.code}',
        isError: true,
      );
    } catch (error) {
      _showSnackBar(
        message: 'Could not open camera: $error',
        isError: true,
      );
    }
  }

  Future<void> _openGallery() async {
    if (cameraService.isOpeningCamera) {
      return;
    }

    try {
      ChatMessageModel? photoMessage = await cameraService.pickFromGallery();

      if (photoMessage == null || !mounted) {
        return;
      }

      setState(() {
        messages.add(photoMessage);
      });

      _scrollToBottom();
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gallery error: ${e.message ?? e.code}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open gallery: $e'),
        ),
      );
    }
  }

  Future<void> _openFilePicker() async {
    if (cameraService.isOpeningCamera) {
      return;
    }

    try {
      ChatMessageModel? fileMessage = await cameraService.pickFile();

      if (fileMessage == null || !mounted) {
        return;
      }

      setState(() {
        messages.add(fileMessage);
      });

      _scrollToBottom();
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'File picker error: ${e.message ?? e.code}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open file picker: $e'),
        ),
      );
    }
  }

  Future<void> _openLocationPicker() async {
    if (cameraService.isPickingLocation) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      ChatMessageModel? locationMessage = await cameraService.pickLocation();

      if (!mounted || locationMessage == null) {
        return;
      }

      setState(() {
        messages.add(locationMessage);
      });

      _scrollToBottom();
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnackBar(
        message: '$error',
        isError: true,
      );
    }
  }

  void _showAttachmentOptions() {
    showChatAttachmentSheet(
      context: context,
      onCamera: _openCamera,
      onGallery: _openGallery,
      onFile: _openFilePicker,
      onLocation: _openLocationPicker,
    );
  }

  void _showMessageActions(
      ChatMessageModel message,
      ) {
    showChatMessageActionsSheet(
      context: context,
      message: message,
      onCopied: () {
        _showSnackBar(
          message: 'Message copied',
        );
      },
      onReply: () {
        if (!mounted) {
          return;
        }

        messageFocusNode.requestFocus();
      },
      onDelete: () {
        if (!mounted) {
          return;
        }

        setState(() {
          messages.removeWhere(
                (ChatMessageModel item) {
              return item.id == message.id;
            },
          );
        });
      },
    );
  }

  // ---------------------------------------------------------------------
  // Voice recording
  // ---------------------------------------------------------------------

  Future<void> _onVoiceTap() async {
    if (isRecordingVoice) {
      await _sendVoiceRecording(
        voiceRecorderService.recordedDuration,
      );

      return;
    }

    HapticFeedback.lightImpact();

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await voiceRecorderService.startRecording();

      if (!mounted) {
        return;
      }

      setState(() {
        isRecordingVoice = true;
        isTapRecordingMode = true;
        voiceDragDx = 0;
        voiceRecordingStartedAt = DateTime.now();
      });
    } on ChatMicPermissionException catch (error) {
      if (!mounted) return;
      await _handleMicPermissionError(error);
    } catch (error) {
      _showSnackBar(
        message: 'Could not start recording: $error',
        isError: true,
      );
    }
  }

  Future<void> _handleMicPermissionError(
      ChatMicPermissionException error,
      ) async {
    if (error.type == ChatMicPermissionError.denied) {
      bool shouldRetry = await _showPermissionDialog(
        title: 'Microphone access needed',
        message:
        'Allow microphone access so you can record and send voice messages.',
        confirmLabel: 'Allow',
      );

      if (shouldRetry && mounted) {
        await _onVoiceTap();
      }

      return;
    }

    bool shouldOpenSettings = await _showPermissionDialog(
      title: 'Microphone access disabled',
      message: error.type == ChatMicPermissionError.restricted
          ? 'Microphone access is restricted on this device and can\'t be changed here.'
          : 'Voice messages need microphone access. '
          'Enable it for this app in Settings.',
      confirmLabel: error.type == ChatMicPermissionError.restricted
          ? 'OK'
          : 'Open Settings',
      showSettingsAction: error.type != ChatMicPermissionError.restricted,
    );

    if (shouldOpenSettings) {
      await ChatVoiceRecorderService.openSettings();
    }
  }

  Future<bool> _showPermissionDialog({
    required String title,
    required String message,
    required String confirmLabel,
    bool showSettingsAction = true,
  }) async {
    if (!mounted) return false;

    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _onVoiceStart() async {
    if (isRecordingVoice) {
      return;
    }

    HapticFeedback.lightImpact();

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await voiceRecorderService.startRecording();

      if (!mounted) {
        return;
      }

      setState(() {
        isRecordingVoice = true;
        isTapRecordingMode = false;
        voiceDragDx = 0;
        voiceRecordingStartedAt = DateTime.now();
      });
    } on ChatMicPermissionException catch (error) {
      if (!mounted) return;
      await _handleMicPermissionError(error);
    } catch (error) {
      _showSnackBar(
        message: 'Could not start recording: $error',
        isError: true,
      );
    }
  }

  void _onVoiceDrag(double dx) {
    if (!isRecordingVoice || isTapRecordingMode) {
      return;
    }

    setState(() {
      voiceDragDx = dx;
    });
  }

  Future<void> _onVoiceEnd() async {
    if (!isRecordingVoice || isTapRecordingMode) {
      return;
    }

    bool shouldCancel = voiceDragDx <= cancelDragThreshold;

    if (shouldCancel) {
      await _cancelVoiceRecording();
      return;
    }

    await _sendVoiceRecording(
      voiceRecorderService.recordedDuration,
    );
  }

  Future<void> _cancelVoiceRecording() async {
    if (!isRecordingVoice) {
      return;
    }

    HapticFeedback.lightImpact();

    await voiceRecorderService.cancelRecording();

    if (!mounted) {
      return;
    }

    setState(() {
      isRecordingVoice = false;
      isTapRecordingMode = false;
      voiceDragDx = 0;
      voiceRecordingStartedAt = null;
    });
  }

  Future<void> _sendVoiceRecording(
      Duration duration,
      ) async {
    if (!isRecordingVoice) {
      return;
    }

    String? audioPath = await voiceRecorderService.stopRecording();

    if (!mounted) {
      return;
    }

    setState(() {
      isRecordingVoice = false;
      isTapRecordingMode = false;
      voiceDragDx = 0;
      voiceRecordingStartedAt = null;
    });

    if (audioPath == null || audioPath.trim().isEmpty) {
      _showSnackBar(
        message: 'Recording was too short.',
        isError: true,
      );

      return;
    }

    HapticFeedback.mediumImpact();

    ChatMessageModel voiceMessage = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: '',
      sentAt: DateTime.now(),
      isMe: true,
      isRead: false,
      type: ChatMessageType.voice,
      mediaPath: audioPath,
    );

    setState(() {
      messages.add(voiceMessage);
    });

    _scrollToBottom();
  }

  // ---------------------------------------------------------------------

  void _handleMenu(String value) {
    switch (value) {
      case 'view_profile':
        _showSnackBar(
          message:
          'Open ${widget.chat.name} profile',
        );
        break;

      case 'search':
        _openMessageSearch();
        break;

      case 'mute':
        _showSnackBar(
          message: widget.chat.isMuted
              ? 'Notifications unmuted'
              : 'Notifications muted',
        );
        break;

      case 'clear':
        _confirmClearConversation();
        break;
    }
  }

  void _scrollToBottom({
    bool animated = true,
    int durationMs = 280,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !scrollController.hasClients) {
        return;
      }

      double target = scrollController.position.maxScrollExtent;

      if (!animated) {
        scrollController.jumpTo(target);
        return;
      }

      scrollController.animateTo(
        target,
        duration: Duration(
          milliseconds: durationMs,
        ),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _showSnackBar({
    required String message,
    bool isError = false,
  }) {
    if (!mounted) {
      return;
    }

    ColorScheme colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          backgroundColor: isError ? colorScheme.error : colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    double appBarSpace = MediaQuery.paddingOf(context).top + 68;

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        // Excludes the entire bottom input bar area (with a 90dp safety margin) from dismissing the keyboard.
        // This stops focus loss when tapping send, camera, voice, or surrounding margins.
        final double dismissBoundary = screenHeight - keyboardHeight - 90;

        if (details.globalPosition.dy < dismissBoundary) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
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
        body: ChatDetailContent(
          chatName: widget.chat.name,
          messages: messages,
          appBarSpace: appBarSpace,
          scrollController: scrollController,
          messageController: messageController,
          messageFocusNode: messageFocusNode,
          onSend: _sendMessage,
          onAttachment: _showAttachmentOptions,
          onCamera: _openCamera,
          onMessageLongPress: _showMessageActions,
          isRecording: isRecordingVoice,
          isHoldRecording: isRecordingVoice && !isTapRecordingMode,
          voiceDragDx: voiceDragDx,
          cancelThreshold: cancelDragThreshold,
          onVoiceTap: _onVoiceTap,
          onVoiceStart: _onVoiceStart,
          onVoiceDrag: _onVoiceDrag,
          onVoiceEnd: _onVoiceEnd,
          onVoiceCancel: _cancelVoiceRecording,
          onVoiceSend: _sendVoiceRecording,
        ),
      ),
    );
  }
}