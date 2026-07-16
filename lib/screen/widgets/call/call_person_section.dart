import 'package:flutter/material.dart';

class CallPersonSection extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String statusText;
  final bool isConnecting;
  final bool showAvatar;
  final bool showLocalPreview;

  CallPersonSection({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.statusText,
    required this.isConnecting,
    required this.showAvatar,
    required this.showLocalPreview,
  });

  String get initials {
    List<String> parts = name
        .trim()
        .split(' ')
        .where(
          (String item) {
        return item.isNotEmpty;
      },
    )
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: Duration(
            milliseconds: 240,
          ),
          child: showAvatar
              ? _CallAvatar(
            key: ValueKey<String>(
              'call-avatar',
            ),
            avatarUrl: avatarUrl,
            initials: initials,
          )
              : SizedBox(
            key: ValueKey<String>(
              'avatar-hidden',
            ),
            height: 100,
          ),
        ),

        SizedBox(height: 20),

        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style:
          theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),

        SizedBox(height: 10),

        _CallStatus(
          text: statusText,
          isConnecting: isConnecting,
        ),

        if (showLocalPreview) ...[
          SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: _LocalPreview(),
          ),
        ],
      ],
    );
  }
}

class _CallAvatar extends StatelessWidget {
  final String avatarUrl;
  final String initials;

  _CallAvatar({
    super.key,
    required this.avatarUrl,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 132,
      height: 132,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: 0.10,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: 0.20,
          ),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(
              alpha: 0.13,
            ),
            blurRadius: 28,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipOval(
        child: avatarUrl.trim().isEmpty
            ? _fallback(context)
            : Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
              ) {
            return _fallback(context);
          },
        ),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.primary.withValues(
        alpha: 0.14,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 34,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CallStatus extends StatelessWidget {
  final String text;
  final bool isConnecting;

  _CallStatus({
    required this.text,
    required this.isConnecting,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isConnecting)
            SizedBox(
              width: 13,
              height: 13,
              child: CircularProgressIndicator(
                strokeWidth: 1.8,
                color: colorScheme.primary,
              ),
            )
          else
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),

          SizedBox(width: 8),

          Text(
            text,
            style: theme.textTheme.bodyMedium
                ?.copyWith(
              color: colorScheme.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      width: 108,
      height: 144,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.12,
            ),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorScheme.primary
              .withValues(
            alpha: 0.11,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person_outline_rounded,
          color: colorScheme.primary,
          size: 27,
        ),
      ),
    );
  }
}