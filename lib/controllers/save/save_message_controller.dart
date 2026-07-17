import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/save_message_model.dart';
import '../../services/save_message_service.dart';

class SavedMessagesController
    extends GetxController {
  final SavedMessageService savedMessageService;

  SavedMessagesController({
    required this.savedMessageService,
  });

  final TextEditingController textController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();

  final RxList<SavedMessageModel> messages =
      <SavedMessageModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    loadMessages();
  }

  Future<void> loadMessages() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      List<SavedMessageModel> result =
      await savedMessageService
          .getSavedMessages();

      result.sort(
            (
            SavedMessageModel first,
            SavedMessageModel second,
            ) {
          return first.dateTime.compareTo(
            second.dateTime,
          );
        },
      );

      messages.assignAll(result);

      _scrollToBottom(
        animated: false,
      );
    } catch (error) {
      errorMessage.value =
      'Failed to load saved messages: $error';
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

  Future<void> sendMessage() async {
    String text =
    textController.text.trim();

    if (text.isEmpty ||
        isSending.value) {
      return;
    }

    try {
      isSending.value = true;
      errorMessage.value = '';

      SavedMessageModel message =
      await savedMessageService
          .sendSavedMessage(text);

      bool alreadyExists = messages.any(
            (SavedMessageModel item) {
          return item.id == message.id;
        },
      );

      if (!alreadyExists) {
        messages.add(message);
      }

      messages.sort(
            (
            SavedMessageModel first,
            SavedMessageModel second,
            ) {
          return first.dateTime.compareTo(
            second.dateTime,
          );
        },
      );

      textController.clear();

      FocusManager.instance.primaryFocus
          ?.unfocus();

      _scrollToBottom();
    } catch (error) {
      errorMessage.value =
      'Failed to save message: $error';

      Get.snackbar(
        'Unable to save message',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }

  Future<void> deleteMessage(
      String id,
      ) async {
    int index = messages.indexWhere(
          (SavedMessageModel message) {
        return message.id == id;
      },
    );

    if (index < 0) {
      return;
    }

    SavedMessageModel removedMessage =
    messages[index];

    messages.removeAt(index);

    try {
      errorMessage.value = '';

      await savedMessageService
          .deleteSavedMessage(id);
    } catch (error) {
      messages.insert(
        index,
        removedMessage,
      );

      errorMessage.value =
      'Failed to delete message: $error';

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

  void _scrollToBottom({
    bool animated = true,
  }) {
    WidgetsBinding.instance
        .addPostFrameCallback(
          (Duration timeStamp) {
        if (!scrollController.hasClients) {
          return;
        }

        double bottomPosition =
            scrollController
                .position.maxScrollExtent;

        if (animated) {
          scrollController.animateTo(
            bottomPosition,
            duration: Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeOut,
          );

          return;
        }

        scrollController.jumpTo(
          bottomPosition,
        );
      },
    );
  }

  @override
  void onClose() {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    textController.dispose();
    scrollController.dispose();

    messages.clear();
    errorMessage.value = '';

    super.onClose();
  }
}