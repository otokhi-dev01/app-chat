// import 'dart:async';
// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import '../../controllers/call/call_controller.dart';
// import 'call_background_view.dart';
// import 'call_control_button.dart';
// import 'call_self_camera_thumbnail.dart';
// import 'call_user_info.dart';
//
// /// UPDATED: Concise CallScreen supporting Audio & Video calls with mock-up data fallback
// class CallScreen extends StatefulWidget {
//   const CallScreen({super.key});
//
//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }
//
// class _CallScreenState extends State<CallScreen> {
//   late final CallController controller;
//
//   Timer? _callTimer;
//   Duration _elapsed = Duration.zero;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // FIXED: Safely retrieves CallController or registers a Mock CallController fallback
//     if (Get.isRegistered<CallController>()) {
//       controller = Get.find<CallController>();
//     } else {
//       controller = Get.put(
//         CallController(
//           name: 'John Doe',
//           avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
//           callType: CallType.audio,
//         ),
//       );
//     }
//
//     // ADDED: Timer tracking call duration (MM:SS)
//     _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (mounted) {
//         setState(() => _elapsed += const Duration(seconds: 1));
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _callTimer?.cancel();
//     super.dispose();
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String minutes = twoDigits(duration.inMinutes.remainder(60));
//     String seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     ColorScheme colorScheme = theme.colorScheme;
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light.copyWith(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//         statusBarBrightness: Brightness.dark,
//       ),
//       child: Scaffold(
//         backgroundColor: const Color(0xFF111318),
//         body: Obx(() {
//           bool isVideo = controller.callType == CallType.video && controller.isVideoOn.value;
//
//           return Stack(
//             children: [
//               // 1. Background View (Audio gradient or Video stream)
//               Positioned.fill(
//                 child: CallBackgroundView(
//                   isVideo: isVideo,
//                   name: controller.name,
//                   primaryColor: colorScheme.primary,
//                 ),
//               ),
//
//               // 2. Main Overlay Content
//               Positioned.fill(
//                 child: SafeArea(
//                   child: Column(
//                     children: [
//                       // Header Bar
//                       _buildHeaderBar(),
//
//                       const Spacer(),
//
//                       // Center User Info (Audio Mode)
//                       if (!isVideo)
//                         CallUserInfo(
//                           name: controller.name,
//                           avatarUrl: controller.avatarUrl,
//                           formattedDuration: _formatDuration(_elapsed),
//                           primaryColor: colorScheme.primary,
//                         ),
//
//                       const Spacer(),
//
//                       // Floating Glass Control Bar
//                       _buildBottomControlsBar(),
//
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // 3. Floating Picture-in-Picture Camera Thumbnail (Video Mode)
//               // 3. Floating Picture-in-Picture Camera Thumbnail (Video Mode)
//               if (isVideo)
//                 Positioned(
//                   top: MediaQuery.of(context).padding.top + 70,
//                   right: 16,
//                   child: CallSelfCameraThumbnail(
//                     // FIXED: Safely calls switchCamera if defined on CallController, falling back to toggleVideo
//                     onSwitchCamera: () {
//                       try {
//                         (controller as dynamic).switchCamera();
//                       } catch (_) {
//                         controller.toggleVideo();
//                       }
//                     },
//                   ),
//                 ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildHeaderBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: const Color(0xFF1B1D22).withValues(alpha: 0.70),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Colors.white.withValues(alpha: 0.10),
//               ),
//             ),
//             child: CupertinoButton(
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 FocusManager.instance.primaryFocus?.unfocus();
//                 Get.back();
//               },
//               child: const Icon(
//                 CupertinoIcons.chevron_left,
//                 size: 20,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Text(
//                 controller.callType == CallType.video
//                     ? 'Video Call'
//                     : 'Audio Call',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 _formatDuration(_elapsed),
//                 style: TextStyle(
//                   color: Colors.white.withValues(alpha: 0.70),
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   fontFeatures: const [FontFeature.tabularFigures()],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 40),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomControlsBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(32),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1B1D22).withValues(alpha: 0.85),
//               borderRadius: BorderRadius.circular(32),
//               border: Border.all(
//                 color: Colors.white.withValues(alpha: 0.10),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.25),
//                   blurRadius: 20,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 CallControlButton(
//                   icon: controller.isMuted.value
//                       ? CupertinoIcons.mic_slash_fill
//                       : CupertinoIcons.mic_fill,
//                   label: controller.isMuted.value ? 'Unmute' : 'Mute',
//                   isActive: controller.isMuted.value,
//                   onTap: () => controller.toggleMute(),
//                 ),
//                 CallControlButton(
//                   icon: controller.isSpeakerOn.value
//                       ? CupertinoIcons.speaker_2_fill
//                       : CupertinoIcons.speaker_slash_fill,
//                   label: 'Speaker',
//                   isActive: controller.isSpeakerOn.value,
//                   onTap: () => controller.toggleSpeaker(),
//                 ),
//                 if (controller.callType == CallType.video)
//                   CallControlButton(
//                     icon: controller.isVideoOn.value
//                         ? CupertinoIcons.videocam_fill
//                         : CupertinoIcons.videocam_circle,
//                     label: 'Camera',
//                     isActive: controller.isVideoOn.value,
//                     onTap: () => controller.toggleVideo(),
//                   ),
//                 GestureDetector(
//                   onTap: () {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     Get.back();
//                   },
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 54,
//                         height: 54,
//                         decoration: const BoxDecoration(
//                           color: CupertinoColors.destructiveRed,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: CupertinoColors.destructiveRed,
//                               blurRadius: 12,
//                               spreadRadius: -2,
//                             ),
//                           ],
//                         ),
//                         child: const Icon(
//                           CupertinoIcons.phone_down_fill,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       const Text(
//                         'End',
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }