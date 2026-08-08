import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/chat_message_model.dart';
import '../../models/save_message_model.dart';
import '../../services/picker_service/chat_camera_services.dart';
import '../../services/picker_service/chat_voice_recorder_service.dart';
import '../../services/saved_service/save_message_service.dart';

class SavedMessagesController extends GetxController {
  final SavedMessageService savedMessageService;

  SavedMessagesController({
    required this.savedMessageService,
  });

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode messageFocusNode = FocusNode();

  final ChatCameraService cameraService = ChatCameraService();
  final ChatVoiceRecorderService voiceRecorderService = ChatVoiceRecorderService();

  final RxList<SavedMessageModel> messages = <SavedMessageModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxString errorMessage = ''.obs;

  // Voice recording state — same shape as ChatDetailController so
  // ChatInputBar / ChatVoiceRecordingBar work unmodified here too.
  final RxBool isRecordingVoice = false.obs;
  final RxBool isTapRecordingMode = false.obs;
  final RxDouble voiceDragDx = 0.0.obs;
  static const double cancelDragThreshold = -80.0;
  DateTime? voiceRecordingStartedAt;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  @override
  void onClose() {
    FocusManager.instance.primaryFocus?.unfocus();

    textController.dispose();
    scrollController.dispose();
    messageFocusNode.dispose();

    if (isRecordingVoice.value) {
      voiceRecorderService.cancelRecording();
    }
    voiceRecorderService.dispose();

    messages.clear();
    errorMessage.value = '';

    super.onClose();
  }

  // ---------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------

  Future<void> loadMessages() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      List<SavedMessageModel> result = await savedMessageService.getSavedMessages();

      result.sort(
            (SavedMessageModel first, SavedMessageModel second) {
          return first.dateTime.compareTo(second.dateTime);
        },
      );

      messages.assignAll(result);

      _scrollToBottom(animated: false);
    } catch (error) {
      errorMessage.value = 'Failed to load saved messages: $error';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMessages() async {
    await loadMessages();
  }

  Future<void> retry() async {
    await loadMessages();
  }

  // ---------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------

  Future<void> sendMessage() async {
    String text = textController.text.trim();

    if (text.isEmpty || isSending.value) {
      return;
    }

    HapticFeedback.lightImpact();

    try {
      isSending.value = true;
      errorMessage.value = '';

      SavedMessageModel message = await savedMessageService.sendSavedMessage(text);

      _appendIfNew(message);

      textController.clear();
      FocusManager.instance.primaryFocus?.unfocus();

      _scrollToBottom();
    } catch (error) {
      errorMessage.value = 'Failed to save message: $error';
      Get.snackbar(
        'Unable to save message',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }

  Future<void> deleteMessage(String id) async {
    int index = messages.indexWhere(
          (SavedMessageModel message) {
        return message.id == id;
      },
    );

    if (index < 0) {
      return;
    }

    SavedMessageModel removedMessage = messages[index];
    messages.removeAt(index);

    try {
      errorMessage.value = '';
      await savedMessageService.deleteSavedMessage(id);
    } catch (error) {
      messages.insert(index, removedMessage);
      errorMessage.value = 'Failed to delete message: $error';

      Get.snackbar(
        'Unable to delete message',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearInput() {
    textController.clear();
  }

  // ---------------------------------------------------------------------
  // Attachments — camera / gallery / file / location. The camera service
  // already returns ChatMessageModel (same as ChatDetailController), so
  // we just wrap the result in SavedMessageModel.fromMessage and re-stamp
  // it with the "saved" conversation id before sending it to the service.
  // ---------------------------------------------------------------------

  Future<void> openCamera() async {
    if (cameraService.isOpeningCamera) return;
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      ChatMessageModel? photo = await cameraService.takePhoto();
      if (isClosed || photo == null) return;

      await _sendMedia(_asSavedDraft(photo));
    } on PlatformException catch (error) {
      _showError('Camera error: ${error.message ?? error.code}');
    } catch (error) {
      _showError('Could not open camera: $error');
    }
  }

  Future<void> openGallery() async {
    if (cameraService.isOpeningCamera) return;

    try {
      ChatMessageModel? photo = await cameraService.pickFromGallery();
      if (photo == null || isClosed) return;

      await _sendMedia(_asSavedDraft(photo));
    } on PlatformException catch (error) {
      _showError('Gallery error: ${error.message ?? error.code}');
    } catch (error) {
      _showError('Could not open gallery: $error');
    }
  }

  Future<void> openFilePicker() async {
    if (cameraService.isOpeningCamera) return;

    try {
      ChatMessageModel? file = await cameraService.pickFile();
      if (file == null || isClosed) return;

      await _sendMedia(_asSavedDraft(file));
    } on PlatformException catch (error) {
      _showError('File picker error: ${error.message ?? error.code}');
    } catch (error) {
      _showError('Could not open file picker: $error');
    }
  }

  Future<void> openLocationPicker() async {
    if (cameraService.isPickingLocation) return;
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      ChatMessageModel? location = await cameraService.pickLocation();
      if (isClosed || location == null) return;

      await _sendMedia(_asSavedDraft(location));
    } catch (error) {
      _showError('$error');
    }
  }

  /// Wraps a ChatMessageModel coming from a picker/camera/location service
  /// into a SavedMessageModel, stamping it as belonging to the saved
  /// conversation regardless of what conversationId the service set.
  SavedMessageModel _asSavedDraft(ChatMessageModel source) {
    return SavedMessageModel.fromMessage(
      source.copyWith(
        conversationId: 'conversation_saved',
        isRead: true,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Voice recording — identical state machine to ChatDetailController.
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
    } catch (error) {
      _showError('Could not start recording: $error');
    }
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
    } catch (error) {
      _showError('Could not start recording: $error');
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
      _showError('Recording was too short.');
      return;
    }

    HapticFeedback.mediumImpact();

    await _sendMedia(
      SavedMessageModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: '',
        dateTime: DateTime.now(),
        type: ChatMessageType.voice,
        mediaPath: audioPath,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------

  Future<void> _sendMedia(SavedMessageModel draft) async {
    try {
      isSending.value = true;
      errorMessage.value = '';

      SavedMessageModel saved = await savedMessageService.sendSavedMedia(draft);

      _appendIfNew(saved);
      _scrollToBottom();
    } catch (error) {
      errorMessage.value = 'Failed to save message: $error';
      Get.snackbar(
        'Unable to save message',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }

  void _appendIfNew(SavedMessageModel message) {
    bool alreadyExists = messages.any(
          (SavedMessageModel item) {
        return item.id == message.id;
      },
    );

    if (!alreadyExists) {
      messages.add(message);
    }

    messages.sort(
          (SavedMessageModel first, SavedMessageModel second) {
        return first.dateTime.compareTo(second.dateTime);
      },
    );
  }

  void _showError(String message) {
    errorMessage.value = message;
    Get.snackbar(
      'Something went wrong',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback(
          (Duration timeStamp) {
        if (!scrollController.hasClients) {
          return;
        }

        double bottomPosition = scrollController.position.maxScrollExtent;

        if (animated) {
          scrollController.animateTo(
            bottomPosition,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
          return;
        }

        scrollController.jumpTo(bottomPosition);
      },
    );
  }
}