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
      return 'AppChat User';
    }

    return value;
  }

  String get cleanUsername {
    return username
        .trim()
        .replaceFirst(
      '@',
      '',
    );
  }

  String get displayUsername {
    if (cleanUsername.isEmpty) {
      return 'No username';
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
        context: context,
        message:
        '${result.name} was added to your contacts.',
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
        context: context,
        message:
        'QR code saved to Photos.',
        icon:
        Icons.download_done_rounded,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      String message = error
          .toString()
          .replaceFirst(
        'Bad state: ',
        '',
      )
          .replaceFirst(
        'Exception: ',
        '',
      );

      _showMessage(
        context: context,
        message: message,
        icon:
        Icons.error_outline_rounded,
        isError: true,
      );
    }
  }

  void _copyProfileValue(
      BuildContext context,
      ) {
    String value =
    cleanUsername.isNotEmpty
        ? '@$cleanUsername'
        : profileQrData;

    Clipboard.setData(
      ClipboardData(
        text: value,
      ),
    );

    _showMessage(
      context: context,
      message:
      cleanUsername.isNotEmpty
          ? 'Username copied.'
          : 'Profile link copied.',
      icon: Icons.copy_rounded,
    );
  }

  void _showMessage({
    required BuildContext context,
    required String message,
    required IconData icon,
    bool isError = false,
  }) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: isError
              ? colorScheme.error
              : null,
          content: Row(
            children: [
              Icon(
                icon,
                color: isError
                    ? colorScheme.onError
                    : Colors.white,
                size: 21,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          behavior:
          SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: ProfileQrAppBar(
        onBack: _closeScreen,
        onScan: () {
          _openScanner(context);
        },
      ),
      body: ProfileQrContent(
        name: cleanName,
        username: displayUsername,
        qrData: profileQrData,
        firstLetter: firstLetter,
        hasUsername:
        cleanUsername.isNotEmpty,
        onCopy: () {
          _copyProfileValue(context);
        },
        onDownload: () {
          return _downloadQrCode(
            context,
          );
        },
      ),
    );
  }
}