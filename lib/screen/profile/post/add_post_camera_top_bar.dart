import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AddPostCameraTopBar
    extends StatelessWidget {
  final FlashMode flashMode;
  final bool gridEnabled;
  final bool recording;
  final VoidCallback onBack;
  final VoidCallback onFlash;
  final VoidCallback onGrid;

  AddPostCameraTopBar({
    super.key,
    required this.flashMode,
    required this.gridEnabled,
    required this.recording,
    required this.onBack,
    required this.onFlash,
    required this.onGrid,
  });

  IconData get flashIcon {
    if (flashMode == FlashMode.auto) {
      return Icons.flash_auto_rounded;
    }

    if (flashMode == FlashMode.always ||
        flashMode == FlashMode.torch) {
      return Icons.flash_on_rounded;
    }

    return Icons.flash_off_rounded;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          8,
          12,
          0,
        ),
        child: Row(
          children: [
            _TopButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBack,
            ),
            Spacer(),
            _TopButton(
              icon: flashIcon,
              active: flashMode != FlashMode.off,
              activeColor: colorScheme.primary,
              onTap: recording
                  ? null
                  : onFlash,
            ),
            SizedBox(width: 9),
            _TopButton(
              icon: Icons.grid_3x3_rounded,
              active: gridEnabled,
              activeColor: colorScheme.primary,
              onTap: onGrid,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool active;
  final Color? activeColor;

  _TopButton({
    required this.icon,
    required this.onTap,
    this.active = false,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = active
        ? activeColor ?? Colors.white
        : Colors.white;

    if (onTap == null) {
      iconColor = Colors.white.withValues(
        alpha: 0.38,
      );
    }

    return Material(
      color: Colors.black.withValues(
        alpha: 0.34,
      ),
      shape: CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: CircleBorder(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            color: iconColor,
            size: 21,
          ),
        ),
      ),
    );
  }
}