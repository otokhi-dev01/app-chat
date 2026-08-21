// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// /// ADDED: Floating Picture-in-Picture camera preview thumbnail for video calls
// class CallSelfCameraThumbnail extends StatelessWidget {
//   final VoidCallback? onSwitchCamera;
//
//   const CallSelfCameraThumbnail({
//     super.key,
//     this.onSwitchCamera,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 140,
//       decoration: BoxDecoration(
//         color: const Color(0xFF282C35),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.white24, width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.35),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             const Icon(
//               CupertinoIcons.person_crop_circle_fill,
//               color: Colors.white38,
//               size: 40,
//             ),
//             Positioned(
//               bottom: 8,
//               right: 8,
//               child: GestureDetector(
//                 onTap: onSwitchCamera,
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withValues(alpha: 0.50),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     CupertinoIcons.camera_rotate_fill,
//                     color: Colors.white,
//                     size: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }