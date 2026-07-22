import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrDesignController extends GetxController {
  static const String _keyModuleShape = 'qr_module_shape';
  static const String _keyEyeShape = 'qr_eye_shape';
  static const String _keyColor = 'qr_color';
  static const String _keyBackground = 'qr_background';

  SharedPreferences? _prefs;

  /// Preset colors the person can pick for the QR pattern itself.
  static const List<Color> colorPresets = [
    Colors.black,
    Color(0xFF2AABEE), // Telegram blue
    Color(0xFF6C63FF),
    Color(0xFF00A884), // WhatsApp green
    Color(0xFFE53E3E),
    Color(0xFFFF8A00),
  ];

  /// Preset backgrounds behind the QR pattern.
  static const List<Color> backgroundPresets = [
    Colors.white,
    Color(0xFFF5F5F0),
    Color(0xFFEFF6FF),
    Color(0xFFFFF7ED),
  ];

  final Rx<QrDataModuleShape> moduleShape =
      QrDataModuleShape.square.obs;

  final Rx<QrEyeShape> eyeShape =
      QrEyeShape.square.obs;

  final Rx<Color> qrColor = Colors.black.obs;

  final Rx<Color> qrBackground = Colors.white.obs;

  @override
  void onInit() {
    super.onInit();

    _load();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();

    SharedPreferences? prefs = _prefs;

    if (prefs == null) {
      return;
    }

    String? moduleShapeName =
    prefs.getString(_keyModuleShape);

    moduleShape.value = moduleShapeName == 'circle'
        ? QrDataModuleShape.circle
        : QrDataModuleShape.square;

    String? eyeShapeName =
    prefs.getString(_keyEyeShape);

    eyeShape.value = eyeShapeName == 'circle'
        ? QrEyeShape.circle
        : QrEyeShape.square;

    int? colorValue = prefs.getInt(_keyColor);

    if (colorValue != null) {
      qrColor.value = Color(colorValue);
    }

    int? backgroundValue =
    prefs.getInt(_keyBackground);

    if (backgroundValue != null) {
      qrBackground.value = Color(backgroundValue);
    }
  }

  void setModuleShape(QrDataModuleShape shape) {
    if (moduleShape.value == shape) {
      return;
    }

    moduleShape.value = shape;

    _prefs?.setString(
      _keyModuleShape,
      shape == QrDataModuleShape.circle
          ? 'circle'
          : 'square',
    );
  }

  void setEyeShape(QrEyeShape shape) {
    if (eyeShape.value == shape) {
      return;
    }

    eyeShape.value = shape;

    _prefs?.setString(
      _keyEyeShape,
      shape == QrEyeShape.circle
          ? 'circle'
          : 'square',
    );
  }

  void setColor(Color color) {
    if (qrColor.value.toARGB32() == color.toARGB32()) {
      return;
    }

    qrColor.value = color;
    _prefs?.setInt(_keyColor, color.toARGB32());
  }

  void setBackground(Color color) {
    if (qrBackground.value.toARGB32() ==
        color.toARGB32()) {
      return;
    }

    qrBackground.value = color;
    _prefs?.setInt(_keyBackground, color.toARGB32());
  }

  void reset() {
    setModuleShape(QrDataModuleShape.square);
    setEyeShape(QrEyeShape.square);
    setColor(Colors.black);
    setBackground(Colors.white);
  }
}