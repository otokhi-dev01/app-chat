import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountrySearchTile extends StatelessWidget {
  final Country country;
  final String phoneCode;
  final String query;
  final bool isSelected;
  final VoidCallback onTap;

  const CountrySearchTile({
    super.key,
    required this.country,
    required this.phoneCode,
    required this.query,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Row(
            children: [
              // Flag Container Box
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  country.flagEmoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),

              const SizedBox(width: 12),

              // Country Name & Phone Code Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CountryHighlightedText(
                      text: country.name,
                      query: query,
                      normalStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w700,
                      ),
                      highlightedStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$phoneCode • ${country.countryCode}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              if (isSelected)
                Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: colorScheme.primary,
                  size: 20,
                )
              else
                Text(
                  phoneCode,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryHighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? normalStyle;
  final TextStyle? highlightedStyle;

  const _CountryHighlightedText({
    required this.text,
    required this.query,
    required this.normalStyle,
    required this.highlightedStyle,
  });

  @override
  Widget build(BuildContext context) {
    String cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: normalStyle,
      );
    }

    String lowerText = text.toLowerCase();
    int startIndex = lowerText.indexOf(cleanQuery);

    if (startIndex < 0) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: normalStyle,
      );
    }

    int endIndex = startIndex + cleanQuery.length;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, startIndex),
            style: normalStyle,
          ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: highlightedStyle,
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: normalStyle,
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}