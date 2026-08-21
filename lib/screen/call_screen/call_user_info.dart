// import 'package:flutter/material.dart';
//
// /// ADDED: User profile avatar, contact name, and call duration status display
// class CallUserInfo extends StatelessWidget {
//   final String name;
//   final String avatarUrl;
//   final String formattedDuration;
//   final Color primaryColor;
//
//   const CallUserInfo({
//     super.key,
//     required this.name,
//     required this.avatarUrl,
//     required this.formattedDuration,
//     required this.primaryColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Pulsing Avatar Ring
//         Container(
//           width: 120,
//           height: 120,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: primaryColor.withValues(alpha: 0.35),
//               width: 3,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: primaryColor.withValues(alpha: 0.20),
//                 blurRadius: 30,
//                 spreadRadius: 5,
//               ),
//             ],
//           ),
//           child: CircleAvatar(
//             radius: 56,
//             backgroundColor: primaryColor.withValues(alpha: 0.15),
//             backgroundImage:
//             avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
//             child: avatarUrl.isEmpty
//                 ? Text(
//               name.isNotEmpty ? name[0].toUpperCase() : '?',
//               style: TextStyle(
//                 color: primaryColor,
//                 fontSize: 38,
//                 fontWeight: FontWeight.w800,
//               ),
//             )
//                 : null,
//           ),
//         ),
//
//         const SizedBox(height: 24),
//
//         // Contact Name
//         Text(
//           name,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.w800,
//             letterSpacing: -0.5,
//           ),
//         ),
//
//         const SizedBox(height: 8),
//
//         // Call Status
//         Text(
//           'In Call • $formattedDuration',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.white.withValues(alpha: 0.70),
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }