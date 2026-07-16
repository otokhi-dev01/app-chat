import 'package:flutter/material.dart';

import 'add_contact_sheet.dart';

export 'add_contact_sheet.dart'
    show AddContactData;

Future<void> showAddContactSheet({
  required BuildContext context,
  required ValueChanged<AddContactData> onAdd,
  required VoidCallback onAddViaQrCode,
  String initialPhoneNumber = '',
}) async {
  FocusManager.instance.primaryFocus?.unfocus();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(
      alpha: 0.42,
    ),
    builder: (BuildContext sheetContext) {
      return AddContactSheet(
        initialPhoneNumber:
        initialPhoneNumber,
        onAdd: onAdd,
        onAddViaQrCode:
        onAddViaQrCode,
      );
    },
  );
}