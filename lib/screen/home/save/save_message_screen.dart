import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/save/save_message_controller.dart';
import '../../../models/chat_message_model.dart';
import '../../../models/save_message_model.dart';
import '../../../services/message_service.dart';
import '../../../services/mock/mock_message_service.dart';
import '../../../services/mock/mock_saved_message_service.dart';
import '../../../services/save_message_service.dart';
import '../../chat_detail/chat_detail_app_bar_button.dart';
import '../../widgets/chat_detail/chat_attachment_sheet.dart';
import '../../widgets/chat_detail/chat_input_bar.dart';
import '../../widgets/chat_detail/chat_message_list.dart';

class SavedMessagesScreen extends StatelessWidget {
  const SavedMessagesScreen({super.key});

  SavedMessagesController get controller {
    if (!Get.isRegistered<MessageService>()) {
      Get.put<MessageService>(MockMessageService(), permanent: true);
    }

    if (!Get.isRegistered<SavedMessageService>()) {
      Get.put<SavedMessageService>(
        MockSavedMessageService(messageService: Get.find<MessageService>()),
        permanent: true,
      );
    }

    if (Get.isRegistered<SavedMessagesController>()) {
      return Get.find<SavedMessagesController>();
    }

    return Get.put<SavedMessagesController>(
      SavedMessagesController(savedMessageService: Get.find<SavedMessageService>()),
      permanent: true,
    );
  }

  SystemUiOverlayStyle _overlayStyle(ThemeData theme, bool isDark) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    }
    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  void _closeScreen() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.back();
  }

  void _showDeleteSheet(BuildContext context, SavedMessageModel message) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    Color cancelColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : const Color(0xFFF2F4F7);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      builder: (BuildContext sheetContext) {
        return Material(
          color: cardColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            side: BorderSide(color: borderColor),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.error.withValues(alpha: 0.11),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(Icons.delete_outline_rounded, color: colorScheme.error, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete message?',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'This message will be permanently removed.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(height: 1, color: borderColor),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: cancelColor,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () => Navigator.of(sheetContext).pop(),
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            height: 52,
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Material(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            controller.deleteMessage(message.id);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            height: 52,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline_rounded, color: colorScheme.onError, size: 20),
                                const SizedBox(width: 7),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: colorScheme.onError,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.94)
        : Colors.white.withValues(alpha: 0.98);
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    Color actionBackground = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFF2F4F7);

    return AppBar(
      toolbarHeight: 68,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leadingWidth: 58,
      systemOverlayStyle: _overlayStyle(theme, isDark),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: appBarColor,
              border: Border(bottom: BorderSide(color: borderColor, width: 1)),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 6, 12),
        child: ChatDetailAppBarButton(
          tooltip: 'Back',
          icon: Icons.arrow_back_ios_new_rounded,
          iconSize: 18,
          backgroundColor: actionBackground,
          foregroundColor: colorScheme.onSurface,
          onPressed: _closeScreen,
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: isDark ? 0.16 : 0.11),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: isDark ? 0.24 : 0.16),
              ),
            ),
            child: Icon(Icons.bookmark_rounded, color: colorScheme.primary, size: 21),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saved Messages',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your private notes',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 340),
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.11),
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary.withValues(alpha: 0.14)),
                ),
                child: Icon(Icons.bookmark_border_rounded, color: colorScheme.primary, size: 37),
              ),
              const SizedBox(height: 20),
              Text(
                'No saved messages',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Send yourself a note, photo, voice message, file, or location — it\'ll stay here.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    Color pageColor = isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF6F7F9);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: pageColor,
        appBar: _buildAppBar(context),
        body: Obx(() {
          // controller.messages is List<SavedMessageModel>; ChatMessageList
          // renders ChatMessageModel, so convert at the boundary via the
          // model's own toChatMessage(). A Map keeps saved-id -> original
          // SavedMessageModel so long-press delete still works with the
          // real saved id, not just the underlying chat message id.
          List<SavedMessageModel> savedMessages = controller.messages.toList();
          List<ChatMessageModel> messages =
          savedMessages.map((SavedMessageModel item) => item.toChatMessage()).toList();

          Map<String, SavedMessageModel> savedById = {
            for (SavedMessageModel item in savedMessages) item.id: item,
          };

          return Stack(
            children: [
              Positioned.fill(
                bottom: 76,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: messages.isEmpty
                      ? KeyedSubtree(
                    key: const ValueKey('empty'),
                    child: _buildEmptyState(context),
                  )
                      : ChatMessageList(
                    key: const ValueKey('message-list'),
                    messages: messages,
                    appBarSpace: 0,
                    scrollController: controller.scrollController,
                    onMessageLongPress: (ChatMessageModel message) {
                      SavedMessageModel? saved = savedById[message.id];
                      if (saved != null) {
                        _showDeleteSheet(context, saved);
                      }
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ChatInputBar(
                  controller: controller.textController,
                  focusNode: controller.messageFocusNode,
                  onSend: controller.sendMessage,
                  onAttachment: () {
                    showChatAttachmentSheet(
                      context: context,
                      onCamera: controller.openCamera,
                      onGallery: controller.openGallery,
                      onFile: controller.openFilePicker,
                      onLocation: controller.openLocationPicker,
                    );
                  },
                  onCamera: controller.openCamera,
                  isRecording: controller.isRecordingVoice.value,
                  isHoldRecording:
                  controller.isRecordingVoice.value && !controller.isTapRecordingMode.value,
                  voiceDragDx: controller.voiceDragDx.value,
                  cancelThreshold: SavedMessagesController.cancelDragThreshold,
                  onVoiceTap: controller.onVoiceTap,
                  onVoiceStart: controller.onVoiceStart,
                  onVoiceDrag: controller.onVoiceDrag,
                  onVoiceEnd: controller.onVoiceEnd,
                  onVoiceCancel: controller.cancelVoiceRecording,
                  onVoiceSend: controller.sendVoiceRecording,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}