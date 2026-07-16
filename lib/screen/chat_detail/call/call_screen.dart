import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/call/call_controller.dart';
import '../../widgets/call/call_controls.dart';
import '../../widgets/call/call_person_section.dart';
import '../../widgets/call/call_top_app.dart';

class CallScreen extends GetView<CallController> {
  CallScreen({
    super.key,
  });

  SystemUiOverlayStyle _overlayStyle(
      ThemeData theme,
      bool isDark,
      ) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor:
        theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
        Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor:
      theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
      Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark =
        theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle(
        theme,
        isDark,
      ),
      child: Scaffold(
        backgroundColor:
        theme.scaffoldBackgroundColor,

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(68),
          child: Obx(
                () {
              bool isConnecting =
                  controller.isConnecting.value;

              return CallTopBar(
                name: controller.name,
                avatarUrl: controller.avatarUrl,
                isVideoCall:
                controller.isVideoCall,
                isConnecting: isConnecting,
                onBack: () {
                  FocusManager.instance.primaryFocus
                      ?.unfocus();

                  Get.back();
                },
              );
            },
          ),
        ),

        body: Obx(
              () {
            bool isConnecting =
                controller.isConnecting.value;

            bool isVideoOn =
                controller.isVideoOn.value;

            bool isMuted =
                controller.isMuted.value;

            bool isSpeakerOn =
                controller.isSpeakerOn.value;

            String duration =
                controller.formattedDuration;

            bool showRemoteVideo =
                controller.isVideoCall &&
                    isVideoOn &&
                    !isConnecting;

            bool showAvatar =
            !showRemoteVideo;

            bool showLocalPreview =
                controller.isVideoCall &&
                    isVideoOn;

            String statusText;

            if (isConnecting) {
              statusText =
              controller.isVideoCall
                  ? 'Video calling...'
                  : 'Calling...';
            } else {
              statusText = duration;
            }

            return Stack(
              children: [

                Positioned.fill(
                  child: SafeArea(
                    top: false,
                    child: LayoutBuilder(
                      builder: (
                          BuildContext context,
                          BoxConstraints constraints,
                          ) {
                        double minHeight =
                            constraints.maxHeight - 48;

                        if (minHeight < 0) {
                          minHeight = 0;
                        }

                        return SingleChildScrollView(
                          physics:
                          BouncingScrollPhysics(),
                          keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior
                              .onDrag,
                          padding: EdgeInsets.fromLTRB(
                            16,
                            24,
                            16,
                            24,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: minHeight,
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                CallPersonSection(
                                  name: controller.name,
                                  avatarUrl:
                                  controller.avatarUrl,
                                  statusText:
                                  statusText,
                                  isConnecting:
                                  isConnecting,
                                  showAvatar:
                                  showAvatar,
                                  showLocalPreview:
                                  showLocalPreview,
                                ),

                                Padding(
                                  padding:
                                  EdgeInsets.only(
                                    top: 36,
                                  ),
                                  child: CallControls(
                                    isVideoCall:
                                    controller
                                        .isVideoCall,
                                    isMuted: isMuted,
                                    isVideoOn:
                                    isVideoOn,
                                    isSpeakerOn:
                                    isSpeakerOn,
                                    onToggleMute:
                                    controller
                                        .toggleMute,
                                    onToggleVideo:
                                    controller
                                        .toggleVideo,
                                    onToggleSpeaker:
                                    controller
                                        .toggleSpeaker,
                                    onFlipCamera:
                                    controller
                                        .flipCamera,
                                    onEndCall:
                                    controller.endCall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}