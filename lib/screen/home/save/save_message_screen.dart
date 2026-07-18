import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/save/save_message_controller.dart';
import '../../../models/save_message_model.dart';
import '../../../services/message_service.dart';
import '../../../services/mock/mock_message_service.dart';
import '../../../services/mock/mock_saved_message_service.dart';
import '../../../services/save_message_service.dart';
import '../../chat_detail/chat_detail_app_bar_button.dart';
import '../../widgets/save/saved_nessage_input_bar.dart';

class SavedMessagesScreen extends StatelessWidget {
  SavedMessagesScreen({
    super.key,
  });

  SavedMessagesController get controller {
    if (!Get.isRegistered<MessageService>()) {
      Get.put<MessageService>(
        MockMessageService(),
        permanent: true,
      );
    }

    if (!Get.isRegistered<SavedMessageService>()) {
      Get.put<SavedMessageService>(
        MockSavedMessageService(
          messageService:
          Get.find<MessageService>(),
        ),
        permanent: true,
      );
    }

    if (Get.isRegistered<
        SavedMessagesController>()) {
      return Get.find<
          SavedMessagesController>();
    }

    return Get.put<SavedMessagesController>(
      SavedMessagesController(
        savedMessageService:
        Get.find<SavedMessageService>(),
      ),
      permanent: true,
    );
  }

  String _formatTime(
      DateTime dateTime,
      ) {
    int hour = dateTime.hour;

    String period =
    hour >= 12 ? 'PM' : 'AM';

    int formattedHour = hour % 12;

    if (formattedHour == 0) {
      formattedHour = 12;
    }

    String minute = dateTime.minute
        .toString()
        .padLeft(2, '0');

    return '$formattedHour:$minute $period';
  }

  SystemUiOverlayStyle _overlayStyle(
      ThemeData theme,
      bool isDark,
      ) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
        Brightness.light,
        statusBarBrightness:
        Brightness.dark,
        systemNavigationBarColor:
        theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
        Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      Brightness.dark,
      statusBarBrightness:
      Brightness.light,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
      Brightness.dark,
    );
  }

  void _closeScreen() {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    Get.back();
  }

  void _showDeleteSheet(
      BuildContext context,
      SavedMessageModel message,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color cancelColor = isDark
        ? Colors.white.withValues(
      alpha: 0.07,
    )
        : Color(0xFFF2F4F7);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: 0.42,
      ),
      builder: (
          BuildContext sheetContext,
          ) {
        return Material(
          color: cardColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            side: BorderSide(
              color: borderColor,
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              20,
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
                        .withValues(
                      alpha: 0.25,
                    ),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.error
                            .withValues(
                          alpha: 0.11,
                        ),
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: colorScheme.error,
                        size: 24,
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete message?',
                            style: theme
                                .textTheme.titleMedium
                                ?.copyWith(
                              color:
                              colorScheme.onSurface,
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'This message will be permanently removed.',
                            style: theme
                                .textTheme.bodySmall
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Divider(
                  height: 1,
                  color: borderColor,
                ),

                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: cancelColor,
                        borderRadius:
                        BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(
                              sheetContext,
                            ).pop();
                          },
                          borderRadius:
                          BorderRadius.circular(16),
                          child: SizedBox(
                            height: 52,
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: colorScheme
                                      .onSurface,
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Material(
                        color: colorScheme.error,
                        borderRadius:
                        BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(
                              sheetContext,
                            ).pop();

                            controller.deleteMessage(
                              message.id,
                            );
                          },
                          borderRadius:
                          BorderRadius.circular(16),
                          child: SizedBox(
                            height: 52,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                Icon(
                                  Icons
                                      .delete_outline_rounded,
                                  color:
                                  colorScheme.onError,
                                  size: 20,
                                ),

                                SizedBox(width: 7),

                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color:
                                    colorScheme.onError,
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w700,
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

  PreferredSizeWidget _buildAppBar(
      BuildContext context,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.94,
    )
        : Colors.white.withValues(
      alpha: 0.98,
    );

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

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
      systemOverlayStyle: _overlayStyle(
        theme,
        isDark,
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18,
            sigmaY: 18,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: appBarColor,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.fromLTRB(
          8,
          12,
          6,
          12,
        ),
        child: ChatDetailAppBarButton(
          tooltip: 'Back',
          icon:
          Icons.arrow_back_ios_new_rounded,
          iconSize: 18,
          backgroundColor:
          actionBackground,
          foregroundColor:
          colorScheme.onSurface,
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
              color: colorScheme.primary
                  .withValues(
                alpha: isDark ? 0.16 : 0.11,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary
                    .withValues(
                  alpha: isDark ? 0.24 : 0.16,
                ),
              ),
            ),
            child: Icon(
              Icons.bookmark_rounded,
              color: colorScheme.primary,
              size: 21,
            ),
          ),

          SizedBox(width: 11),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Saved Messages',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme.titleMedium
                      ?.copyWith(
                    color:
                    colorScheme.onSurface,
                    fontSize: 16,
                    height: 1.1,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Your private notes',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme.bodySmall
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontSize: 11,
                    height: 1,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(28),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 340,
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            30,
            24,
            28,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
            BorderRadius.circular(26),
            border: Border.all(
              color: borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.18 : 0.06,
                ),
                blurRadius: 24,
                offset: Offset(0, 10),
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
                  color: colorScheme.primary
                      .withValues(
                    alpha: 0.11,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary
                        .withValues(
                      alpha: 0.14,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  color: colorScheme.primary,
                  size: 37,
                ),
              ),

              SizedBox(height: 20),

              Text(
                'No saved messages',
                textAlign: TextAlign.center,
                style: theme
                    .textTheme.titleMedium
                    ?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Send yourself a note or forward important messages here.',
                textAlign: TextAlign.center,
                style: theme
                    .textTheme.bodyMedium
                    ?.copyWith(
                  color: colorScheme
                      .onSurfaceVariant,
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

  Widget _buildMessageBubble(
      BuildContext context,
      SavedMessageModel message,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    double maximumWidth =
        MediaQuery.sizeOf(context).width *
            0.78;

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onLongPress: () {
          _showDeleteSheet(
            context,
            message,
          );
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: maximumWidth,
          ),
          margin: EdgeInsets.only(
            left: 52,
            top: 4,
            bottom: 4,
          ),
          padding: EdgeInsets.fromLTRB(
            13,
            9,
            10,
            7,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft:
              Radius.circular(18),
              bottomRight:
              Radius.circular(5),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary
                    .withValues(
                  alpha: 0.17,
                ),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment:
            WrapCrossAlignment.end,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                message.text,
                style: theme
                    .textTheme.bodyLarge
                    ?.copyWith(
                  color:
                  colorScheme.onPrimary,
                  fontSize: 14.5,
                  height: 1.35,
                  fontWeight:
                  FontWeight.w400,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  bottom: 1,
                ),
                child: Text(
                  _formatTime(
                    message.dateTime,
                  ),
                  style: theme
                      .textTheme.bodySmall
                      ?.copyWith(
                    color: colorScheme.onPrimary
                        .withValues(
                      alpha: 0.72,
                    ),
                    fontSize: 10.5,
                    height: 1,
                    fontWeight:
                    FontWeight.w500,
                  ),
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

    bool isDark =
        theme.brightness == Brightness.dark;

    Color pageColor = isDark
        ? theme.scaffoldBackgroundColor
        : Color(0xFFF6F7F9);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus
            ?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: pageColor,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: Obx(
                    () {
                  List<SavedMessageModel> messages =
                  controller.messages.toList();

                  if (messages.isEmpty) {
                    return _buildEmptyState(
                      context,
                    );
                  }

                  return ListView.builder(
                    controller:
                    controller.scrollController,
                    physics:
                    BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,
                    padding: EdgeInsets.fromLTRB(
                      14,
                      14,
                      14,
                      18,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (
                        BuildContext context,
                        int index,
                        ) {
                      SavedMessageModel message =
                      messages[index];

                      return _buildMessageBubble(
                        context,
                        message,
                      );
                    },
                  );
                },
              ),
            ),

            MessageInputBar(
              textController:
              controller.textController,
              hintText: 'Message',
              onSend: controller.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}