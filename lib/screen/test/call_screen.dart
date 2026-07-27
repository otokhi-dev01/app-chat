// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
//
// class CallScreen extends StatefulWidget {
//   final String channelName;
//   final String token; // fetched from your backend
//   final int uid;
//
//   const CallScreen({
//     super.key,
//     required this.channelName,
//     required this.token,
//     required this.uid,
//   });
//
//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }
//
// class _CallScreenState extends State<CallScreen> {
//   static const String appId = "YOUR_AGORA_APP_ID";
//   late final RtcEngine _engine;
//   int? _remoteUid;
//   bool _localUserJoined = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initAgora();
//   }
//
//   Future<void> _initAgora() async {
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(appId: appId));
//
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (connection, elapsed) {
//           setState(() => _localUserJoined = true);
//         },
//         onUserJoined: (connection, remoteUid, elapsed) {
//           setState(() => _remoteUid = remoteUid);
//         },
//         onUserOffline: (connection, remoteUid, reason) {
//           setState(() => _remoteUid = null);
//         },
//       ),
//     );
//
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//       token: widget.token,
//       channelId: widget.channelName,
//       uid: widget.uid,
//       options: const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         channelProfile: ChannelProfileType.channelProfileCommunication,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Remote video (full screen)
//           Center(
//             child: _remoteUid != null
//                 ? AgoraVideoView(
//               controller: VideoViewController.remote(
//                 rtcEngine: _engine,
//                 canvas: VideoCanvas(uid: _remoteUid),
//                 connection: RtcConnection(channelId: widget.channelName),
//               ),
//             )
//                 : const Text('Waiting for the other user to join...'),
//           ),
//
//           // Local video (small preview, top-right)
//           if (_localUserJoined)
//             Positioned(
//               top: 40,
//               right: 20,
//               width: 100,
//               height: 150,
//               child: AgoraVideoView(
//                 controller: VideoViewController(
//                   rtcEngine: _engine,
//                   canvas: const VideoCanvas(uid: 0),
//                 ),
//               ),
//             ),
//
//           // Call controls
//           Positioned(
//             bottom: 40,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FloatingActionButton(
//                   onPressed: () => _engine.muteLocalAudioStream(true),
//                   child: const Icon(Icons.mic_off),
//                 ),
//                 const SizedBox(width: 20),
//                 FloatingActionButton(
//                   backgroundColor: Colors.red,
//                   onPressed: () => Navigator.pop(context),
//                   child: const Icon(Icons.call_end),
//                 ),
//                 const SizedBox(width: 20),
//                 FloatingActionButton(
//                   onPressed: () => _engine.switchCamera(),
//                   child: const Icon(Icons.cameraswitch),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }