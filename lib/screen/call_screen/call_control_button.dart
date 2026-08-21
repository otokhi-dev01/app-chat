// import 'package:flutter/material.dart';
//
// /// ADDED: Standalone call action control button widget (Mute, Speaker, Camera)
// class CallControlButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isActive;
//   final VoidCallback onTap;
//
//   const CallControlButton({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.isActive,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Color buttonBg = isActive
//         ? Colors.white
//         : Colors.white.withValues(alpha: 0.12);
//
//     Color iconColor = isActive ? const Color(0xFF111318) : Colors.white;
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 180),
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: buttonBg,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: iconColor,
//               size: 22,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }