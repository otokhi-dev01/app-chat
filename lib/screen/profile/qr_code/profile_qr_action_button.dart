import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CopyProfileButton extends StatelessWidget
{
  final bool hasUsername;
  final VoidCallback onPressed;

  const CopyProfileButton({
    super.key,
    required this.hasUsername,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size(
          double.infinity,
          52,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.doc_on_doc,
            size: 18,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              hasUsername ? 'copy_username'.tr : 'copy_link'.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SaveQrButton extends StatefulWidget {
  final Future<void> Function() onDownload;

  const SaveQrButton({
    super.key,
    required this.onDownload,
  });

  @override
  State<SaveQrButton> createState() {
    return _SaveQrButtonState();
  }
}

class _SaveQrButtonState extends State<SaveQrButton> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onDownload();
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color buttonColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.12 : 0.08,
    );

    Color borderColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.22 : 0.15,
    );

    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _isSaving ? null : _handleSave,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 52,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSaving)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                )
              else
                Icon(
                  CupertinoIcons.arrow_down_to_line,
                  color: colorScheme.primary,
                  size: 18,
                ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  _isSaving ? 'saving'.tr : 'save_qr'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}