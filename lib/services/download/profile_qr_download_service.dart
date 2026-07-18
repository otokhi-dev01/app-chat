import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileQrDownloadService {
  bool _isSaving = false;

  Future<void> saveQrCode({
    required String data,
    required String fileName,
  }) async {
    if (_isSaving) {
      return;
    }

    _isSaving = true;

    try {
      bool hasPermission =
      await Gal.hasAccess();

      if (!hasPermission) {
        bool permissionGranted =
        await Gal.requestAccess();

        if (!permissionGranted) {
          throw StateError(
            'Permission to save photos was denied.',
          );
        }
      }

      Uint8List imageBytes =
      await _createQrImage(
        data: data,
      );

      await Gal.putImageBytes(
        imageBytes,
        name: _cleanFileName(
          fileName,
        ),
      );
    } on GalException catch (error) {
      throw StateError(
        error.type.message,
      );
    } finally {
      _isSaving = false;
    }
  }

  Future<Uint8List> _createQrImage({
    required String data,
  }) async {
    double qrSize = 900;
    double outerPadding = 80;
    double totalSize =
        qrSize + (outerPadding * 2);

    ui.PictureRecorder recorder =
    ui.PictureRecorder();

    ui.Canvas canvas =
    ui.Canvas(recorder);

    ui.Paint backgroundPaint =
    ui.Paint()
      ..color = Colors.white;

    canvas.drawRect(
      ui.Rect.fromLTWH(
        0,
        0,
        totalSize,
        totalSize,
      ),
      backgroundPaint,
    );

    canvas.save();

    canvas.translate(
      outerPadding,
      outerPadding,
    );

    QrPainter painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle:
      QrDataModuleStyle(
        dataModuleShape:
        QrDataModuleShape.square,
        color: Colors.black,
      ),
    );

    painter.paint(
      canvas,
      ui.Size(
        qrSize,
        qrSize,
      ),
    );

    canvas.restore();

    ui.Picture picture =
    recorder.endRecording();

    ui.Image image =
    await picture.toImage(
      totalSize.round(),
      totalSize.round(),
    );

    try {
      ByteData? byteData =
      await image.toByteData(
        format:
        ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw StateError(
          'Unable to create QR code image.',
        );
      }

      return byteData.buffer
          .asUint8List();
    } finally {
      image.dispose();
      picture.dispose();
    }
  }

  String _cleanFileName(
      String fileName,
      ) {
    String result = fileName
        .trim()
        .toLowerCase()
        .replaceAll(
      RegExp(r'[^a-z0-9_-]'),
      '_',
    );

    if (result.isEmpty) {
      return 'appchat_profile_qr';
    }

    return result;
  }
}