// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// /// ADDED: Background view rendering audio gradient glow or video camera view
// class CallBackgroundView extends StatelessWidget {
//   final bool isVideo;
//   final String name;
//   final Color primaryColor;
//
//   const CallBackgroundView({
//     super.key,
//     required this.isVideo,
//     required this.name,
//     required this.primaryColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (isVideo) {
//       return Container(
//         color: const Color(0xFF1E222A),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 CupertinoIcons.person_fill,
//                 size: 80,
//                 color: Colors.white.withValues(alpha: 0.35),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 name,
//                 style: TextStyle(
//                   color: Colors.white.withValues(alpha: 0.60),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           center: Alignment.center,
//           radius: 1.2,
//           colors: [
//             primaryColor.withValues(alpha: 0.18),
//             const Color(0xFF111318),
//           ],
//         ),
//       ),
//     );
//   }
// }