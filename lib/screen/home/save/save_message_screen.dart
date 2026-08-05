import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
    FocusManager.instance.primaryFocus?.unfocus();

    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text('delete_message_question'.tr),
          content: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('delete_message_desc'.tr),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancel'.tr),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(dialogContext);
                controller.deleteMessage(message.id);
              },
              child: Text('delete'.tr),
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color actionBackground = isDark ? Color(0xFF1B1D22) : Colors.white;

    return AppBar(
      toolbarHeight: 60,
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
        padding: EdgeInsets.fromLTRB(12, 10, 6, 10),
        child: Tooltip(
          message: 'back'.tr,
          child: Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: actionBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.15 : 0.04,
                  ),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size(40, 40),
              onPressed: _closeScreen,
              child: Icon(
                CupertinoIcons.chevron_left,
                size: 20,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.11),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.20),
              ),
            ),
            child: Icon(
              CupertinoIcons.bookmark_fill,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'saved_messages'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'private_notes'.tr,
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

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(28),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 340),
          padding: EdgeInsets.fromLTRB(24, 30, 24, 28),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
                blurRadius: 20,
                offset: Offset(0, 8),
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
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.14),
                  ),
                ),
                child: Icon(
                  CupertinoIcons.bookmark,
                  color: colorScheme.primary,
                  size: 36,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'no_saved_messages'.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'saved_messages_empty_desc'.tr,
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

    Color pageColor = isDark ? theme.scaffoldBackgroundColor : Color(0xFFF6F7F9);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: pageColor,
        appBar: _buildAppBar(context),
        body: Obx(() {
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
                  duration: Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: messages.isEmpty
                      ? KeyedSubtree(
                    key: ValueKey('empty'),
                    child: _buildEmptyState(context),
                  )
                      : ChatMessageList(
                    key: ValueKey('message-list'),
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