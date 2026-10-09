class AttendanceCalculator {
  static const double targetPercentage = 75.0;

  static double calculatePercentage(int present, int total) {
    if (total <= 0) return 0.0;
    return (present / total) * 100.0;
  }

  /// Calculates how many consecutive classes need to be attended to reach target % (75%).
  /// Formula: (present + x) / (total + x) >= target/100
  /// x * (1 - target/100) >= target/100 * total - present
  /// x >= (target/100 * total - present) / (1 - target/100)
  static int calculateClassesNeeded(int present, int total, {double target = targetPercentage}) {
    final current = calculatePercentage(present, total);
    if (current >= target || total == 0) return 0;

    final targetDecimal = target / 100.0;
    final numerator = (targetDecimal * total) - present;
    final denominator = 1.0 - targetDecimal;
    final needed = (numerator / denominator).ceil();
    return needed > 0 ? needed : 0;
  }

  /// Calculates how many classes can be safely missed without dropping below target % (75%).
  /// Formula: present / (total + y) >= target/100
  /// y <= (present - target/100 * total) / (target/100)
  static int calculateClassesCanMiss(int present, int total, {double target = targetPercentage}) {
    final current = calculatePercentage(present, total);
    if (current < target || total == 0) return 0;

    final targetDecimal = target / 100.0;
    final maxTotal = present / targetDecimal;
    final canMiss = (maxTotal - total).floor();
    return canMiss > 0 ? canMiss : 0;
  }

  static String getStatusMessage(int present, int total, {double target = targetPercentage}) {
    if (total == 0) return 'No attendance records logged yet.';
    final current = calculatePercentage(present, total);

    if (current < target) {
      final needed = calculateClassesNeeded(present, total, target: target);
      return 'You need to attend the next $needed class${needed == 1 ? '' : 'es'} to reach ${target.toInt()}%.';
    } else {
      final canMiss = calculateClassesCanMiss(present, total, target: target);
      if (canMiss == 0) {
        return 'On the line! You cannot afford to miss the next class.';
      }
      return 'You can safely miss $canMiss class${canMiss == 1 ? '' : 'es'} while staying above ${target.toInt()}%.';
    }
  }
}
