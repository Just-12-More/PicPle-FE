import 'package:intl/intl.dart';

String formatPostedTimeFromString(String dateTimeString) {
  try {
    final postedTime = DateTime.parse(dateTimeString); // ISO 8601 형식 (e.g. 2023-01-01T12:30:00)
    final now = DateTime.now();
    final difference = now.difference(postedTime);

    final diffMinutes = difference.inMinutes;
    final diffHours = difference.inHours;

    if (diffMinutes <= 1) {
      return '방금 전';
    } else if (diffMinutes < 60) {
      return '$diffMinutes분 전';
    } else if (diffMinutes < 1440) {
      return '$diffHours시간 전';
    } else {
      final formatter = DateFormat('M월 d일 HH:mm');
      return formatter.format(postedTime);
    }
  } catch (e) {
    return '알 수 없음';
  }
}