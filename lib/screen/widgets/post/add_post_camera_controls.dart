import 'package:flutter/material.dart';

import '../../../../controllers/profile/add_post_camera_controller.dart';

class AddPostCameraControls
    extends StatelessWidget {
  final AddPostCameraMode selectedMode;
  final bool recording;
  final bool busy;
  final bool canSwitchCamera;
  final VoidCallback onGallery;
  final VoidCallback onCapture;
  final VoidCallback onSwitchCamera;
  final ValueChanged<AddPostCameraMode>
  onModeChanged;

  AddPostCameraControls({
    super.key,
    required this.selectedMode,
    required this.recording,
    required this.busy,
    required this.canSwitchCamera,
    required this.onGallery,
    required this.onCapture,
    required this.onSwitchCamera,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        22,
        16,
        22,
        12,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.88,
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(
              alpha: 0.08,
            ),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                _SideControlButton(
                  icon:
                  Icons.photo_library_outlined,
                  enabled:
                  !busy && !recording,
                  onTap: onGallery,
                ),
                _CaptureButton(
                  mode: selectedMode,
                  recording: recording,
                  busy: busy,
                  onTap: onCapture,
                ),
                _SideControlButton(
                  icon:
                  Icons.cameraswitch_rounded,
                  enabled: canSwitchCamera &&
                      !busy &&
                      !recording,
                  onTap: onSwitchCamera,
                ),
              ],
            ),
            SizedBox(height: 14),
            _CameraModeNavigation(
              selectedMode: selectedMode,
              enabled: !busy && !recording,
              onChanged: onModeChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _SideControlButton
    extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  _SideControlButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(
        alpha: enabled ? 0.12 : 0.05,
      ),
      shape: CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: CircleBorder(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            color: Colors.white.withValues(
              alpha: enabled ? 1 : 0.32,
            ),
            size: 23,
          ),
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final AddPostCameraMode mode;
  final bool recording;
  final bool busy;
  final VoidCallback onTap;

  _CaptureButton({
    required this.mode,
    required this.recording,
    required this.busy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isVideo =
        mode == AddPostCameraMode.video;

    return Material(
      color: Colors.transparent,
      shape: CircleBorder(),
      child: InkWell(
        onTap: busy ? null : onTap,
        customBorder: CircleBorder(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          width: 78,
          height: 78,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(
                alpha: busy ? 0.40 : 1,
              ),
              width: 4,
            ),
          ),
          child: busy
              ? SizedBox(
            width: 28,
            height: 28,
            child:
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : AnimatedContainer(
            duration: Duration(
              milliseconds: 180,
            ),
            curve: Curves.easeOut,
            width: recording
                ? 30
                : isVideo
                ? 58
                : 62,
            height: recording
                ? 30
                : isVideo
                ? 58
                : 62,
            decoration: BoxDecoration(
              color: isVideo
                  ? Colors.red
                  : Colors.white,
              shape: recording
                  ? BoxShape.rectangle
                  : BoxShape.circle,
              borderRadius: recording
                  ? BorderRadius.circular(
                8,
              )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraModeNavigation
    extends StatelessWidget {
  final AddPostCameraMode selectedMode;
  final bool enabled;
  final ValueChanged<AddPostCameraMode>
  onChanged;

  _CameraModeNavigation({
    required this.selectedMode,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        _ModeButton(
          title: 'PHOTO',
          selected:
          selectedMode ==
              AddPostCameraMode.photo,
          enabled: enabled,
          onTap: () {
            onChanged(
              AddPostCameraMode.photo,
            );
          },
        ),
        SizedBox(width: 30),
        _ModeButton(
          title: 'VIDEO',
          selected:
          selectedMode ==
              AddPostCameraMode.video,
          enabled: enabled,
          onTap: () {
            onChanged(
              AddPostCameraMode.video,
            );
          },
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String title;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  _ModeButton({
    required this.title,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    Color activeColor =
        colorScheme.primary;

    Color textColor = selected
        ? activeColor
        : Colors.white.withValues(
      alpha: enabled ? 0.62 : 0.30,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(
          18,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: AnimatedContainer(
          duration: Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: selected
                ? activeColor.withValues(
              alpha: 0.16,
            )
                : Colors.transparent,
            borderRadius:
            BorderRadius.circular(18),
          ),
          child: AnimatedDefaultTextStyle(
            duration: Duration(
              milliseconds: 200,
            ),
            curve: Curves.easeOut,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: selected
                  ? FontWeight.w800
                  : FontWeight.w600,
              letterSpacing: 0.6,
            ),
            child: Text(
              title,
            ),
          ),
        ),
      ),
    );
  }
}