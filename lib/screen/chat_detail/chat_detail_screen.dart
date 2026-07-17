import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/call/call_controller.dart';
import '../../models/chat_message_model.dart';
import '../../models/chat_model.dart';
import '../../route/app_route.dart';
import '../../services/chat_camera_services.dart';
import '../../services/chat_voice_recorder_service.dart';
import '../widgets/chat_detail/chat_attachment_sheet.dart';
import '../widgets/chat_detail/chat_voice_message.dart';
import 'call/call_screen.dart';
import 'chat_detail_app_bar.dart';
import '../widgets/chat_detail/chat_detail_content.dart';
import '../widgets/chat_detail/chat_message_action_sheet.dart';
import '../widgets/chat_detail/chat_sample_messages.dart';
import 'chat_message_search_screen.dart';

// ---------------------------------------------------------------------
// 1. Controller handling all state and lifecycles
// ---------------------------------------------------------------------
class ChatDetailController extends GetxController with WidgetsBindingObserver {
  final ChatModel chat;

  ChatDetailController({required this.chat});

  late final TextEditingController messageController;
  late final ScrollController scrollController;
  late final FocusNode messageFocusNode;

  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  final ChatCameraService cameraService = ChatCameraService();
  final ChatVoiceRecorderService voiceRecorderService = ChatVoiceRecorderService();

  DateTime? voiceRecordingStartedAt;

  final RxBool isRecordingVoice = false.obs;
  final RxBool isTapRecordingMode = false.obs;
  final RxDouble voiceDragDx = 0.0.obs;

  static const double cancelDragThreshold = -80.0;
  double _lastBottomInset = 0.0;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    messageController = TextEditingController();
    scrollController = ScrollController();
    messageFocusNode = FocusNode();

    messageFocusNode.addListener(_handleMessageFocusChange);

    messages.addAll(buildChatSampleMessages(chat));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(animated: false);
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    messageFocusNode.removeListener(_handleMessageFocusChange);
    messageFocusNode.unfocus();

    messageController.dispose();
    scrollController.dispose();
    messageFocusNode.dispose();

    if (isRecordingVoice.value) {
      voiceRecorderService.cancelRecording();
    }
    voiceRecorderService.dispose();

    super.onClose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (isClosed) return;

    final double currentBottomInset = Get.mediaQuery.viewInsets.bottom;

    if (currentBottomInset > _lastBottomInset && currentBottomInset > 0) {
      scrollToBottom(animated: true, durationMs: 180);
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
        if (isClosed) return;
        scrollToBottom(animated: true, durationMs: 200);
      },
    );
  }

  void sendMessage() {
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

    messages.add(newMessage);
    messageController.clear();

    messageFocusNode.requestFocus();
    scrollToBottom();
  }

  Future<void> openMessageSearch() async {
    FocusManager.instance.primaryFocus?.unfocus();

    String? selectedMessageId = await Get.to<String>(
          () => ChatMessageSearchScreen(
        chatName: chat.name,
        messages: List<ChatMessageModel>.from(messages),
      ),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 280),
    );

    if (isClosed || selectedMessageId == null) {
      return;
    }

    int messageIndex = messages.indexWhere(
          (ChatMessageModel msg) => msg.id == selectedMessageId,
    );

    if (messageIndex < 0) {
      return;
    }

    scrollToSearchResult(messageIndex);
  }

  void scrollToSearchResult(int messageIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed || !scrollController.hasClients || messages.isEmpty) {
        return;
      }

      double maxScrollExtent = scrollController.position.maxScrollExtent;
      double scrollPercent = messages.length <= 1 ? 0 : messageIndex / (messages.length - 1);
      double targetOffset = (maxScrollExtent * scrollPercent).clamp(0, maxScrollExtent);

      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> openProfileDetail() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Get.toNamed(AppRoutes.profileDetail);
  }

  Future<void> confirmClearConversation() async {
    bool? shouldClear = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear conversation?'),
        content: const Text('All messages in this conversation will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Clear',
              style: TextStyle(
                color: Get.theme.colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (isClosed || shouldClear != true) return;

    messages.clear();
    _showSnackBar(message: 'Conversation cleared');
  }

  Future<void> openCamera() async {
    if (cameraService.isOpeningCamera) return;

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      ChatMessageModel? photoMessage = await cameraService.takePhoto();

      if (isClosed || photoMessage == null) return;

      messages.add(photoMessage);
      scrollToBottom();
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

  Future<void> openGallery() async {
    if (cameraService.isOpeningCamera) return;

    try {
      ChatMessageModel? photoMessage = await cameraService.pickFromGallery();

      if (photoMessage == null || isClosed) return;

      messages.add(photoMessage);
      scrollToBottom();
    } on PlatformException catch (e) {
      _showSnackBar(message: 'Gallery error: ${e.message ?? e.code}', isError: true);
    } catch (e) {
      _showSnackBar(message: 'Could not open gallery: $e', isError: true);
    }
  }

  Future<void> openFilePicker() async {
    if (cameraService.isOpeningCamera) return;

    try {
      ChatMessageModel? fileMessage = await cameraService.pickFile();

      if (fileMessage == null || isClosed) return;

      messages.add(fileMessage);
      scrollToBottom();
    } on PlatformException catch (e) {
      _showSnackBar(message: 'File picker error: ${e.message ?? e.code}', isError: true);
    } catch (e) {
      _showSnackBar(message: 'Could not open file picker: $e', isError: true);
    }
  }

  Future<void> openLocationPicker() async {
    if (cameraService.isPickingLocation) return;

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      ChatMessageModel? locationMessage = await cameraService.pickLocation();

      if (isClosed || locationMessage == null) return;

      messages.add(locationMessage);
      scrollToBottom();
    } catch (error) {
      _showSnackBar(message: '$error', isError: true);
    }
  }

  void showAttachmentOptions() {
    showChatAttachmentSheet(
      context: Get.context!,
      onCamera: openCamera,
      onGallery: openGallery,
      onFile: openFilePicker,
      onLocation: openLocationPicker,
    );
  }

  void showMessageActions(ChatMessageModel message) {
    showChatMessageActionsSheet(
      context: Get.context!,
      message: message,
      onCopied: () => _showSnackBar(message: 'Message copied'),
      onReply: () {
        if (isClosed) return;
        messageFocusNode.requestFocus();
      },
      onDelete: () {
        if (isClosed) return;
        messages.removeWhere((ChatMessageModel item) => item.id == message.id);
      },
    );
  }

  // ---------------------------------------------------------------------
  // Voice recording
  // ---------------------------------------------------------------------

  Future<void> onVoiceTap() async {
    if (isRecordingVoice.value) {
      await sendVoiceRecording(voiceRecorderService.recordedDuration);
      return;
    }

    HapticFeedback.lightImpact();
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await voiceRecorderService.startRecording();

      if (isClosed) return;

      isRecordingVoice.value = true;
      isTapRecordingMode.value = true;
      voiceDragDx.value = 0.0;
      voiceRecordingStartedAt = DateTime.now();
    } on ChatMicPermissionException catch (error) {
      await _handleMicPermissionError(error);
    } catch (error) {
      _showSnackBar(message: 'Could not start recording: $error', isError: true);
    }
  }

  Future<void> _handleMicPermissionError(ChatMicPermissionException error) async {
    if (error.type == ChatMicPermissionError.denied) {
      bool shouldRetry = await _showPermissionDialog(
        title: 'Microphone access needed',
        message: 'Allow microphone access so you can record and send voice messages.',
        confirmLabel: 'Allow',
      );

      if (shouldRetry && !isClosed) {
        await onVoiceTap();
      }
      return;
    }

    bool shouldOpenSettings = await _showPermissionDialog(
      title: 'Microphone access disabled',
      message: error.type == ChatMicPermissionError.restricted
          ? 'Microphone access is restricted on this device and can\'t be changed here.'
          : 'Voice messages need microphone access. Enable it for this app in Settings.',
      confirmLabel: error.type == ChatMicPermissionError.restricted ? 'OK' : 'Open Settings',
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
    bool? result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> onVoiceStart() async {
    if (isRecordingVoice.value) return;

    HapticFeedback.lightImpact();
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await voiceRecorderService.startRecording();

      if (isClosed) return;

      isRecordingVoice.value = true;
      isTapRecordingMode.value = false;
      voiceDragDx.value = 0.0;
      voiceRecordingStartedAt = DateTime.now();
    } on ChatMicPermissionException catch (error) {
      await _handleMicPermissionError(error);
    } catch (error) {
      _showSnackBar(message: 'Could not start recording: $error', isError: true);
    }
  }

  void onVoiceDrag(double dx) {
    if (!isRecordingVoice.value || isTapRecordingMode.value) return;
    voiceDragDx.value = dx;
  }

  Future<void> onVoiceEnd() async {
    if (!isRecordingVoice.value || isTapRecordingMode.value) return;

    bool shouldCancel = voiceDragDx.value <= cancelDragThreshold;

    if (shouldCancel) {
      await cancelVoiceRecording();
      return;
    }

    await sendVoiceRecording(voiceRecorderService.recordedDuration);
  }

  Future<void> cancelVoiceRecording() async {
    if (!isRecordingVoice.value) return;

    HapticFeedback.lightImpact();
    await voiceRecorderService.cancelRecording();

    if (isClosed) return;

    isRecordingVoice.value = false;
    isTapRecordingMode.value = false;
    voiceDragDx.value = 0.0;
    voiceRecordingStartedAt = null;
  }

  Future<void> sendVoiceRecording(Duration duration) async {
    if (!isRecordingVoice.value) return;

    String? audioPath = await voiceRecorderService.stopRecording();

    if (isClosed) return;

    isRecordingVoice.value = false;
    isTapRecordingMode.value = false;
    voiceDragDx.value = 0.0;
    voiceRecordingStartedAt = null;

    if (audioPath == null || audioPath.trim().isEmpty) {
      _showSnackBar(message: 'Recording was too short.', isError: true);
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

    messages.add(voiceMessage);
    scrollToBottom();
  }

  void handleMenu(String value) {
    switch (value) {
      case 'view_profile':
        _showSnackBar(message: 'Open ${chat.name} profile');
        break;
      case 'search':
        openMessageSearch();
        break;
      case 'mute':
        _showSnackBar(
          message: chat.isMuted ? 'Notifications unmuted' : 'Notifications muted',
        );
        break;
      case 'clear':
        confirmClearConversation();
        break;
    }
  }

  void scrollToBottom({
    bool animated = true,
    int durationMs = 280,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed || !scrollController.hasClients) return;

      double target = scrollController.position.maxScrollExtent;

      if (!animated) {
        scrollController.jumpTo(target);
        return;
      }

      scrollController.animateTo(
        target,
        duration: Duration(milliseconds: durationMs),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _showSnackBar({
    required String message,
    bool isError = false,
  }) {
    final ColorScheme colorScheme = Get.theme.colorScheme;
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      backgroundColor: isError ? colorScheme.error : colorScheme.primary,
      borderRadius: 14,
      margin: const EdgeInsets.all(14),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(milliseconds: 2000),
    );
  }
}

// ---------------------------------------------------------------------
// 2. Pure, lightweight StatelessWidget Page
// ---------------------------------------------------------------------
class ChatDetailScreen extends StatelessWidget {
  final ChatModel chat;

  ChatDetailScreen({
    super.key,
    required this.chat,
  }) {
    // Registers a unique controller tagged by hash code so nested/parallel chats don't collide
    Get.put(
      ChatDetailController(chat: chat),
      tag: chat.hashCode.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String tag = chat.hashCode.toString();
    final ChatDetailController controller = Get.find<ChatDetailController>(tag: tag);
    final ThemeData theme = Theme.of(context);

    final double appBarSpace = MediaQuery.paddingOf(context).top + 68;

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        // Excludes bottom input bar area from dismissing keyboard
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
          chat: chat,
          onProfileTap: controller.openProfileDetail,
          onAudioCall: () {
            Get.put(
              CallController(
                name: chat.name,
                avatarUrl: chat.image,
                callType: CallType.audio,
              ),
            );
            Get.to(() => CallScreen());
          },
          onVideoCall: () {
            Get.put(
              CallController(
                name: chat.name,
                avatarUrl: chat.image,
                callType: CallType.video,
              ),
            );
            Get.to(() => CallScreen());
          },
          onMenuSelected: controller.handleMenu,
        ),
        // Obx monitors active streams like voice recording & message updates beautifully
        body: Obx(
              () => ChatDetailContent(
            chatName: chat.name,
            messages: controller.messages.toList(),
            appBarSpace: appBarSpace,
            scrollController: controller.scrollController,
            messageController: controller.messageController,
            messageFocusNode: controller.messageFocusNode,
            onSend: controller.sendMessage,
            onAttachment: controller.showAttachmentOptions,
            onCamera: controller.openCamera,
            onMessageLongPress: controller.showMessageActions,
            isRecording: controller.isRecordingVoice.value,
            isHoldRecording: controller.isRecordingVoice.value && !controller.isTapRecordingMode.value,
            voiceDragDx: controller.voiceDragDx.value,
            cancelThreshold: ChatDetailController.cancelDragThreshold,
            onVoiceTap: controller.onVoiceTap,
            onVoiceStart: controller.onVoiceStart,
            onVoiceDrag: controller.onVoiceDrag,
            onVoiceEnd: controller.onVoiceEnd,
            onVoiceCancel: controller.cancelVoiceRecording,
            onVoiceSend: controller.sendVoiceRecording,
          ),
        ),
      ),
    );
  }
}