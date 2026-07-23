import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/contact_model.dart';
import '../../../route/app_route.dart';
import '../../../services/download/profile_qr_download_service.dart';
import '../../widgets/qr_code/profile_qr_content.dart';
import 'profile_qr_app_bar.dart';

class ProfileQrCodeScreen
    extends StatelessWidget {
  final String name;
  final String username;

  final ProfileQrDownloadService
  downloadService;

  ProfileQrCodeScreen({
    super.key,
    required this.name,
    required this.username,
    ProfileQrDownloadService?
    downloadService,
  }) : downloadService =
      downloadService ??
          ProfileQrDownloadService();

  String get cleanName {
    String value = name.trim();

    if (value.isEmpty) {
      return 'appchat_user'.tr;
    }

    return value;
  }

  String get cleanUsername {
    return username.trim().replaceFirst(
      '@',
      '',
    );
  }

  String get displayUsername {
    if (cleanUsername.isEmpty) {
      return 'no_username'.tr;
    }

    return '@$cleanUsername';
  }

  String get profileQrData {
    String profileKey =
    cleanUsername.isNotEmpty
        ? cleanUsername
        : cleanName;

    return 'appchat://profile/'
        '${Uri.encodeComponent(profileKey)}';
  }

  String get firstLetter {
    return cleanName
        .substring(
      0,
      1,
    )
        .toUpperCase();
  }

  String get qrFileName {
    if (cleanUsername.isNotEmpty) {
      return 'appchat_qr_$cleanUsername';
    }

    return 'appchat_profile_qr';
  }

  void _closeScreen() {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    Get.back();
  }

  Future<void> _openScanner(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    if (Get.currentRoute ==
        AppRoutes.qrScanner) {
      return;
    }

    dynamic result = await Get.toNamed(
      AppRoutes.qrScanner,
      preventDuplicates: true,
    );

    if (!context.mounted) {
      return;
    }

    if (result is ContactModel) {
      _showMessage(
        title: 'contact_added'.tr,
        message: 'contact_added_message'
            .trParams({
          'name': result.name,
        }),
        icon:
        Icons.person_add_alt_1_rounded,
      );
    }
  }

  Future<void> _downloadQrCode(
      BuildContext context,
      ) async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    try {
      await downloadService.saveQrCode(
        data: profileQrData,
        fileName: qrFileName,
      );

      if (!context.mounted) {
        return;
      }

      _showMessage(
        title: 'qr_code_saved'.tr,
        message:
        'qr_code_saved_to_photos'.tr,
        icon:
        Icons.download_done_rounded,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        title:
        'unable_to_save_qr_code'.tr,
        message: _cleanErrorMessage(
          error,
        ),
        icon:
        Icons.error_outline_rounded,
      );
    }
  }

  void _copyProfileValue() {
    String value =
    cleanUsername.isNotEmpty
        ? '@$cleanUsername'
        : profileQrData;

    Clipboard.setData(
      ClipboardData(
        text: value,
      ),
    );

    if (cleanUsername.isNotEmpty) {
      _showMessage(
        title: 'username_copied'.tr,
        message:
        'username_copied_to_clipboard'
            .tr,
        icon: Icons.copy_rounded,
      );

      return;
    }

    _showMessage(
      title: 'profile_link_copied'.tr,
      message:
      'profile_link_copied_to_clipboard'
          .tr,
      icon: Icons.copy_rounded,
    );
  }

  void _showMessage({
    required String title,
    required String message,
    required IconData icon,
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition:
      SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 16,
      icon: Icon(
        icon,
      ),
      duration: Duration(
        seconds: 3,
      ),
      isDismissible: true,
      dismissDirection:
      DismissDirection.horizontal,
    );
  }

  String _cleanErrorMessage(
      Object error,
      ) {
    return error
        .toString()
        .replaceFirst(
      'Bad state: ',
      '',
    )
        .replaceFirst(
      'Exception: ',
      '',
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: ProfileQrAppBar(
        onBack: _closeScreen,
        onScan: () {
          _openScanner(
            context,
          );
        },
      ),
      body: ProfileQrContent(
        name: cleanName,
        username: displayUsername,
        qrData: profileQrData,
        firstLetter: firstLetter,
        hasUsername:
        cleanUsername.isNotEmpty,
        onCopy: _copyProfileValue,
        onDownload: () {
          return _downloadQrCode(
            context,
          );
        },
      ),
    );
  }
}