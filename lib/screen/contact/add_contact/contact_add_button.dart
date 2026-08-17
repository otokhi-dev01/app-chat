import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/contact_controller.dart';
import '../../../models/contact_model.dart';
import '../qr_scan/qr_contact_scanner_binding.dart';
import '../../widgets/app_feedback.dart';

class ContactAddButton extends StatelessWidget {
  final ContactController controller;

  const ContactAddButton({
    super.key,
    required this.controller,
  });

  void _openSearchAndAddSheet(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SearchAddContactSheet(
        controller: controller,
        onAddViaQrCode: () => _openQrScanner(context),
      ),
    );
  }

  Future<void> _openQrScanner(
    BuildContext context,
  ) async {
    final dynamic scannedValueResult = await QrContactScannerBinding.open();

    if (scannedValueResult == null || !context.mounted) {
      return;
    }

    if (scannedValueResult is String) {
      final String scannedValue = scannedValueResult;

      if (scannedValue.trim().isEmpty) {
        return;
      }

      String phoneNumber = _extractPhoneNumber(
        scannedValue,
      );

      if (phoneNumber.isEmpty) {
        _showInvalidQrMessage(
          context,
        );
        return;
      }

      // Pre-fill QR phone in search sheet
      if (context.mounted) {
        controller.onUserSearchChanged(phoneNumber);
        _openSearchAndAddSheet(context);
      }
    }
  }

  String _extractPhoneNumber(
    String scannedValue,
  ) {
    String value = scannedValue.trim();

    Uri? uri = Uri.tryParse(value);

    if (uri != null && uri.scheme.toLowerCase() == 'tel') {
      return uri.path.trim();
    }

    RegExpMatch? phoneMatch = RegExp(
      r'\+?[0-9][0-9\s\-()]{6,}',
    ).firstMatch(value);

    if (phoneMatch == null) {
      return '';
    }

    return phoneMatch.group(0)?.trim() ?? '';
  }

  void _showInvalidQrMessage(
    BuildContext context,
  ) {
    AppFeedback.showMessage(
      title: 'invalid_qr_code'.tr,
      message: 'qr_no_phone_number'.tr,
      icon: CupertinoIcons.exclamationmark_circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color shadowColor = isDark
        ? Colors.black.withValues(
            alpha: 0.32,
          )
        : colorScheme.primary.withValues(
            alpha: 0.24,
          );

    return Positioned(
      right: 16,
      bottom: 110,
      child: Obx(
        () {
          bool isVisible = controller.showAddButton.value;

          return IgnorePointer(
            ignoring: !isVisible,
            child: AnimatedSlide(
              duration: Duration(
                milliseconds: 220,
              ),
              curve: Curves.easeOutCubic,
              offset: isVisible ? Offset.zero : Offset(0, 2),
              child: AnimatedOpacity(
                duration: Duration(
                  milliseconds: 180,
                ),
                curve: Curves.easeOutCubic,
                opacity: isVisible ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Tooltip(
                    message: 'add_contact'.tr,
                    child: FloatingActionButton(
                      heroTag: 'add_contact_fab',
                      elevation: 0,
                      highlightElevation: 0,
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      onPressed: () {
                        _openSearchAndAddSheet(context);
                      },
                      shape: CircleBorder(),
                      child: Icon(
                        CupertinoIcons.person_badge_plus,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Bottom sheet: search users by username/phone and add them as contacts.
class _SearchAddContactSheet extends StatefulWidget {
  final ContactController controller;
  final VoidCallback? onAddViaQrCode;

  const _SearchAddContactSheet({
    required this.controller,
    this.onAddViaQrCode,
  });

  @override
  State<_SearchAddContactSheet> createState() => _SearchAddContactSheetState();
}

class _SearchAddContactSheetState extends State<_SearchAddContactSheet> {
  late TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(
      text: widget.controller.userSearch.value,
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    widget.controller.clearUserSearch();
    super.dispose();
  }

  Future<void> _addContact(ContactModel user) async {
    final bool success = await widget.controller.addContact(user: user);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
      AppFeedback.showMessage(
        title: 'contact_added'.tr,
        message: '${user.name} has been added to your contacts.',
        icon: CupertinoIcons.checkmark_circle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    Color fieldColor = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.025);

    double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    double topSafeArea = MediaQuery.paddingOf(context).top;
    double maxHeight =
        MediaQuery.sizeOf(context).height - topSafeArea - kToolbarHeight - 12;

    return Material(
      color: cardColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'add_contact'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (widget.onAddViaQrCode != null)
                      IconButton(
                        icon: const Icon(CupertinoIcons.qrcode_viewfinder),
                        tooltip: 'Scan QR Code',
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onAddViaQrCode?.call();
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'search_by_username_or_phone'.tr,
                    prefixIcon: const Icon(CupertinoIcons.search, size: 18),
                    suffixIcon: Obx(() {
                      if (widget.controller.userSearch.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        icon: const Icon(CupertinoIcons.clear_circled_solid,
                            size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          widget.controller.onUserSearchChanged('');
                        },
                      );
                    }),
                    filled: true,
                    fillColor: fieldColor,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 1.4),
                    ),
                  ),
                  onChanged: (v) => widget.controller.onUserSearchChanged(v),
                ),
              ),
              const SizedBox(height: 8),

              // Results
              Flexible(
                child: Obx(() {
                  if (widget.controller.isSearchingUsers.value) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final users = widget.controller.userOptions;

                  if (widget.controller.userSearch.value.length >= 2 &&
                      users.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.person_crop_circle_badge_xmark,
                              size: 40,
                              color: colorScheme.onSurface.withValues(
                                  alpha: 0.3)),
                          const SizedBox(height: 12),
                          Text(
                            'no_users_found'.tr,
                            style: TextStyle(
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (users.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'Type a username or phone number to search',
                        style: TextStyle(
                          color:
                              colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    itemCount: users.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: borderColor),
                    itemBuilder: (ctx, i) {
                      final ContactModel user = users[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundImage: user.avatarUrl.isNotEmpty
                              ? NetworkImage(user.avatarUrl)
                              : null,
                          child: user.avatarUrl.isEmpty
                              ? Text(
                                  (user.name.isNotEmpty
                                          ? user.name[0]
                                          : '?')
                                      .toUpperCase(),
                                )
                              : null,
                        ),
                        title: Text(user.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          user.username.isNotEmpty
                              ? '@${user.username}'
                              : user.phoneNumber,
                          style: TextStyle(
                            color: colorScheme.onSurface
                                .withValues(alpha: 0.55),
                            fontSize: 13,
                          ),
                        ),
                        trailing: Obx(() {
                          if (widget.controller.isSaving.value) {
                            return const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            );
                          }
                          return FilledButton(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => _addContact(user),
                            child: Text('add'.tr),
                          );
                        }),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}