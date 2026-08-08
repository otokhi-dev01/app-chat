import 'package:get/get.dart';

/// UPDATED: Formats chat group dates ('Today', 'Yesterday', 'MMM d', or 'MMM d, yyyy') with localization support
String chatDateLabel(DateTime date) {
  // UPDATED: Normalize timestamps to midnight (year, month, day) for precise day comparisons
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(const Duration(days: 1));
  DateTime day = DateTime(date.year, date.month, date.day);

  // UPDATED: Returns localized 'Today' / 'Yesterday' strings with safe fallback
  if (day == today) return 'today'.tr == 'today' ? 'Today' : 'today'.tr;
  if (day == yesterday) return 'yesterday'.tr == 'yesterday' ? 'Yesterday' : 'yesterday'.tr;

  // UPDATED: Short month name lookup list for date formatting
  const List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  bool sameYear = day.year == today.year;

  // UPDATED: Formats as "MMM d" (e.g. "Aug 8") if same year, or "MMM d, yyyy" (e.g. "Aug 8, 2025") for other years
  return sameYear
      ? '${months[day.month - 1]} ${day.day}'
      : '${months[day.month - 1]} ${day.day}, ${day.year}';
}