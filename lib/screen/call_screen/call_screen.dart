import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/call/call_controller.dart';

/// ADDED: Unit UI CallScreen supporting both Audio and Video calls with glassmorphic controls
class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallController controller = Get.find<CallController>();

  Timer? _callTimer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    // ADDED: Timer tracking call duration (MM:SS)
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsed += const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  SystemUiOverlayStyle _overlayStyle() {
    return SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    final SystemUiOverlayStyle overlayStyle = _overlayStyle();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFF111318), // ADDED: Immersive dark call background
        body: Obx(() {
          bool isVideo = controller.callType == CallType.video && controller.isVideoOn.value;

          return Stack(
            children: [
              // ADDED: Video background view or Audio blurred background
              Positioned.fill(
                child: isVideo
                    ? _buildVideoBackground()
                    : _buildAudioBackground(colorScheme),
              ),

              // ADDED: Main call content (Header, Avatar, Timer, Controls)
              Positioned.fill(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Top Header Bar
                      _buildHeaderBar(context),

                      const Spacer(),

                      // Center User Info (for Audio mode)
                      if (!isVideo) _buildAudioUserInfo(theme, colorScheme),

                      const Spacer(),

                      // Bottom Action Controls Bar
                      _buildBottomControlsBar(colorScheme),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // ADDED: Floating Picture-in-Picture Self Camera Thumbnail (Video Mode)
              if (isVideo)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 70,
                  right: 16,
                  child: _buildSelfCameraThumbnail(borderColor: Colors.white24),
                ),
            ],
          );
        }),
      ),
    );
  }

  /// ADDED: Glassmorphic top header bar with 40x40 back button and call duration
  Widget _buildHeaderBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 40x40 Elevated circular back/minimize button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1D22).withValues(alpha: 0.70),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              },
              child: const Icon(
                CupertinoIcons.chevron_left,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),

          // Call Type Indicator & Timer
          Column(
            children: [
              Text(
                controller.callType == CallType.video
                    ? 'Video Call'
                    : 'Audio Call',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDuration(_elapsed),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),

          const SizedBox(width: 40), // Spacer to balance header alignment
        ],
      ),
    );
  }

  /// ADDED: Audio call user info with pulsing avatar ring
  Widget _buildAudioUserInfo(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pulsing Avatar Ring
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.35),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.20),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 56,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
            backgroundImage: controller.avatarUrl.isNotEmpty
                ? NetworkImage(controller.avatarUrl)
                : null,
            child: controller.avatarUrl.isEmpty
                ? Text(
              controller.name.isNotEmpty
                  ? controller.name[0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 38,
                fontWeight: FontWeight.w800,
              ),
            )
                : null,
          ),
        ),

        const SizedBox(height: 24),

        // Contact Name
        Text(
          controller.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 8),

        // Call Status
        Text(
          'In Call • ${_formatDuration(_elapsed)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.70),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// ADDED: Bottom controls bar with Mute, Speaker, Video Toggle, and End Call
  Widget _buildBottomControlsBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1D22).withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mute Mic Button
                _CallControlButton(
                  icon: controller.isMuted.value
                      ? CupertinoIcons.mic_slash_fill
                      : CupertinoIcons.mic_fill,
                  label: controller.isMuted.value ? 'Unmute' : 'Mute',
                  isActive: controller.isMuted.value,
                  onTap: () => controller.toggleMute(),
                ),

                // Speaker Button
                _CallControlButton(
                  icon: controller.isSpeakerOn.value
                      ? CupertinoIcons.speaker_2_fill
                      : CupertinoIcons.speaker_slash_fill,
                  label: 'Speaker',
                  isActive: controller.isSpeakerOn.value,
                  onTap: () => controller.toggleSpeaker(),
                ),

                // Camera Toggle (Video Call Mode)
                if (controller.callType == CallType.video)
                  _CallControlButton(
                    icon: controller.isVideoOn.value
                        ? CupertinoIcons.videocam_fill
                        : CupertinoIcons.videocam_circle,
                    label: 'Camera',
                    isActive: controller.isVideoOn.value,
                    onTap: () => controller.toggleVideo(),
                  ),

                // End Call Button (Prominent Destructive Red)
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Get.back();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: CupertinoColors.destructiveRed,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.destructiveRed,
                              blurRadius: 12,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.phone_down_fill,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'End',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ADDED: Audio mode background gradient with soft primary radial glow
  Widget _buildAudioBackground(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            colorScheme.primary.withValues(alpha: 0.18),
            const Color(0xFF111318),
          ],
        ),
      ),
    );
  }

  /// ADDED: Video camera full background view
  Widget _buildVideoBackground() {
    return Container(
      color: const Color(0xFF1E222A),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.person_fill,
              size: 80,
              color: Colors.white.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 12),
            Text(
              controller.name,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.60),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ADDED: Floating Picture-in-Picture camera preview thumbnail for video calls
  Widget _buildSelfCameraThumbnail({required Color borderColor}) {
    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF282C35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              CupertinoIcons.person_crop_circle_fill,
              color: Colors.white38,
              size: 40,
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                // onTap: () => controller.switchCamera(),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.camera_rotate_fill,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ADDED: Individual call control action button widget (Mute, Speaker, Camera)
class _CallControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _CallControlButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonBg = isActive
        ? Colors.white
        : Colors.white.withValues(alpha: 0.12);

    Color iconColor = isActive ? const Color(0xFF111318) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: buttonBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}