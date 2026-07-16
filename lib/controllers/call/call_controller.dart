import 'dart:async';
import 'package:get/get.dart';

enum CallType { audio, video }

class CallController extends GetxController {
  final String name;
  final String avatarUrl;
  final CallType callType;

  CallController({
    required this.name,
    required this.avatarUrl,
    required this.callType,
  });

  Timer? _timer;

  final RxBool isConnecting = true.obs;
  final Rx<Duration> elapsed = Duration.zero.obs;
  final RxBool isMuted = false.obs;
  final RxBool isSpeakerOn = false.obs;
  final RxBool isVideoOn = true.obs;
  final RxBool isFrontCamera = true.obs;

  bool get isVideoCall => callType == CallType.video;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 2), () {
      isConnecting.value = false;

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsed.value += const Duration(seconds: 1);
      });
    });
  }

  String get formattedDuration {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(elapsed.value.inMinutes.remainder(60));
    String seconds = twoDigits(elapsed.value.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void toggleMute() => isMuted.value = !isMuted.value;

  void toggleSpeaker() => isSpeakerOn.value = !isSpeakerOn.value;

  void toggleVideo() => isVideoOn.value = !isVideoOn.value;

  void flipCamera() => isFrontCamera.value = !isFrontCamera.value;

  void endCall() {
    _timer?.cancel();
    Get.back();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}