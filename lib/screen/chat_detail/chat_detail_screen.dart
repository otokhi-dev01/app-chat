import 'package:appchat/screen/chat_detail/widgets/chat_attachment_sheet.dart';
import 'package:appchat/screen/chat_detail/widgets/chat_detail_content.dart';
import 'package:appchat/screen/chat_detail/widgets/chat_message_action_sheet.dart';
import 'package:appchat/screen/chat_detail/widgets/chat_sample_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/call/call_controller.dart';
import '../../models/chat_message_model.dart';
import '../../models/chat_model.dart';
import '../../route/app_route.dart';
import '../../services/picker_service/chat_camera_services.dart';
import '../../services/picker_service/chat_voice_recorder_service.dart';
import '../widgets/app_feedback.dart';
import 'call/call_screen.dart';
import 'chat_detail_app_bar.dart';
import 'chat_search/chat_message_search_screen.dart';

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
  final ChatVoiceRecorderService voiceRecorderService =
  ChatVoiceRecorderService();

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
      double scrollPercent =
      messages.length <= 1 ? 0 : messageIndex / (messages.length - 1);
      double targetOffset =
      (maxScrollExtent * scrollPercent).clamp(0, maxScrollExtent);

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
    HapticFeedback.lightImpact();
    bool? shouldClear = await Get.dialog<bool>(
      CupertinoAlertDialog(
        title: const Text('Clear conversation?'),
        content:
        const Text('All messages in this conversation will be removed.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Get.back(result: true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (isClosed || shouldClear != true) return;

    messages.clear();
    AppFeedback.showMessage(
      title: 'Cleared',
      message: 'Conversation cleared successfully',
      icon: CupertinoIcons.trash,
    );
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
      AppFeedback.showMessage(
        title: 'Camera Error',
        message: error.message ?? error.code,
        icon: CupertinoIcons.exclamationmark_circle,
      );
    } catch (error) {
      AppFeedback.showMessage(
        title: 'Error',
        message: 'Could not open camera: $error',
        icon: CupertinoIcons.exclamationmark_circle,
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
      AppFeedback.showMessage(
        title: 'Gallery Error',
        message: e.message ?? e.code,
        icon: CupertinoIcons.exclamationmark_circle,
      );
    } catch (e) {
      AppFeedback.showMessage(
        title: 'Error',
        message: 'Could not open gallery: $e',
        icon: CupertinoIcons.exclamationmark_circle,
      );
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
      AppFeedback.showMessage(
        title: 'File Error',
        message: e.message ?? e.code,
        icon: CupertinoIcons.exclamationmark_circle,
      );
    } catch (e) {
      AppFeedback.showMessage(
        title: 'Error',
        message: 'Could not open file picker: $e',
        icon: CupertinoIcons.exclamationmark_circle,
      );
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
      AppFeedback.showMessage(
        title: 'Location Error',
        message: '$error',
        icon: CupertinoIcons.exclamationmark_circle,
      );
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
      onCopied: () {
        AppFeedback.showMessage(
          title: 'Copied',
          message: 'Message copied to clipboard',
          icon: CupertinoIcons.doc_on_doc,
        );
      },
      onReply: () {
        if (isClosed) return;
        messageFocusNode.requestFocus();
      },
      onForward: () {
        if (isClosed) return;

        // Open your forward screen here
        // Get.to(() => ForwardMessageView(message: message));
      },
      onDelete: () {
        if (isClosed) return;
        messages.removeWhere(
              (ChatMessageModel item) => item.id == message.id,
        );

        AppFeedback.showMessage(
          title: 'Deleted',
          message: 'Message deleted',
          icon: CupertinoIcons.trash,
        );
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
      AppFeedback.showMessage(
        title: 'Error',
        message: 'Could not start recording: $error',
        icon: CupertinoIcons.exclamationmark_circle,
      );
    }
  }

  Future<void> _handleMicPermissionError(
      ChatMicPermissionException error) async {
    if (error.type == ChatMicPermissionError.denied) {
      bool shouldRetry = await _showPermissionDialog(
        title: 'Microphone access needed',
        message:
        'Allow microphone access so you can record and send voice messages.',
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
          ? 'Microphone access is restricted on this device_service and can\'t be changed here.'
          : 'Voice messages need microphone access. Enable it for this app in Settings.',
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
    bool? result = await Get.dialog<bool>(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
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
      AppFeedback.showMessage(
        title: 'Error',
        message: 'Could not start recording: $error',
        icon: CupertinoIcons.exclamationmark_circle,
      );
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
      AppFeedback.showMessage(
        title: 'Recording Cancelled',
        message: 'Recording was too short.',
        icon: CupertinoIcons.info_circle,
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

    messages.add(voiceMessage);
    scrollToBottom();
  }

  void handleMenu(String value) {
    switch (value) {
      case 'view_profile':
        openProfileDetail();
        break;
      case 'search':
        openMessageSearch();
        break;
      case 'mute':
        AppFeedback.showMessage(
          title: 'Notifications',
          message:
          chat.isMuted ? 'Notifications unmuted' : 'Notifications muted',
          icon: chat.isMuted ? CupertinoIcons.bell : CupertinoIcons.bell_slash,
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
    Get.put(
      ChatDetailController(chat: chat),
      tag: chat.hashCode.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String tag = chat.hashCode.toString();
    final ChatDetailController controller =
    Get.find<ChatDetailController>(tag: tag);
    final ThemeData theme = Theme.of(context);

    final double appBarSpace = MediaQuery.paddingOf(context).top + 60;

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

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
            isHoldRecording: controller.isRecordingVoice.value &&
                !controller.isTapRecordingMode.value,
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