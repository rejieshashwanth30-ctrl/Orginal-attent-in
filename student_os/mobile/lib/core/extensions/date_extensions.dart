import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toFormattedDate() {
    return DateFormat('EEE, MMM d, yyyy').format(this);
  }

  String toShortDate() {
    return DateFormat('MMM d').format(this);
  }

  String toTimeString() {
    return DateFormat('hh:mm a').format(this);
  }

  String toRelativeTimeString() {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inDays == 0 && day == now.day) {
      return 'Today';
    } else if (difference.inDays == 1 || (difference.inDays == 0 && day == now.day + 1)) {
      return 'Tomorrow';
    } else if (difference.inDays == -1 || (difference.inDays == 0 && day == now.day - 1)) {
      return 'Yesterday';
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days left';
    } else {
      return '${difference.inDays.abs()} days ago';
    }
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
