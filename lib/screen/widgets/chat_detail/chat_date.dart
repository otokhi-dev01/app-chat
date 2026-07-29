String chatDateLabel(DateTime date) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(const Duration(days: 1));
  DateTime day = DateTime(date.year, date.month, date.day);

  if (day == today) return 'Today';
  if (day == yesterday) return 'Yesterday';

  const List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  bool sameYear = day.year == today.year;
  return sameYear
      ? '${months[day.month - 1]} ${day.day}'
      : '${months[day.month - 1]} ${day.day}, ${day.year}';
}