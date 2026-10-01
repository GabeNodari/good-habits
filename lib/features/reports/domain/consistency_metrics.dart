class DaySummary {
  final DateTime date;
  final int completedCount;
  final int totalHabits;

  const DaySummary({
    required this.date,
    required this.completedCount,
    this.totalHabits = 7,
  });

  double get rate => totalHabits > 0 ? (completedCount / totalHabits) : 0.0;
  int get percentage => (rate * 100).round();
}

class WeeklyReportData {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<DaySummary> days;
  final int totalCompleted;
  final double completionRate;

  const WeeklyReportData({
    required this.weekStart,
    required this.weekEnd,
    required this.days,
    required this.totalCompleted,
    required this.completionRate,
  });
}

class MonthlyReportData {
  final int year;
  final int month;
  final int totalDaysInMonth;
  final List<DaySummary> days;
  final Map<String, int> habitCompletedDays;
  final Map<String, double> habitRates;
  final double averageRate;

  const MonthlyReportData({
    required this.year,
    required this.month,
    required this.totalDaysInMonth,
    required this.days,
    required this.habitCompletedDays,
    required this.habitRates,
    required this.averageRate,
  });
}

class AnnualReportData {
  final int year;
  final List<double> monthlyRates; // 12 meses (0..100%)
  final double annualAverageRate;

  const AnnualReportData({
    required this.year,
    required this.monthlyRates,
    required this.annualAverageRate,
  });
}

class HabitStreak {
  final String habitId;
  final int currentStreak;
  final int longestStreak;
  final int totalCompletedDays;

  const HabitStreak({
    required this.habitId,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompletedDays,
  });
}
