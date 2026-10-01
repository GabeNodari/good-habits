import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_service.dart';
import '../../../core/utils/date_utils.dart';
import '../../tracker/data/tracker_repository.dart';
import '../../tracker/domain/habit.dart';
import '../domain/consistency_metrics.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return ReportsRepository(dbService);
});

class ReportsRepository {
  final DatabaseService _dbService;

  ReportsRepository(this._dbService);

  /// Relatório Semanal
  Future<WeeklyReportData> getWeeklyReport(DateTime referenceDate) async {
    final weekDays = AppDateUtils.getWeekDays(referenceDate);
    final startDateStr = AppDateUtils.toDateString(weekDays.first);
    final endDateStr = AppDateUtils.toDateString(weekDays.last);

    final rawRecords = await _dbService.getRecordsInRange(
      startDateStr,
      endDateStr,
    );

    // Mapear { "YYYY-MM-DD": { "habit_id": isCompleted } }
    final dayMap = <String, Map<String, bool>>{};
    for (final row in rawRecords) {
      final date = row['date'] as String;
      final habitId = row['habit_id'] as String;
      final isCompleted = (row['is_completed'] as int) == 1;

      dayMap.putIfAbsent(date, () => {})[habitId] = isCompleted;
    }

    final days = <DaySummary>[];
    int totalCompleted = 0;

    for (final day in weekDays) {
      final dateStr = AppDateUtils.toDateString(day);
      final habitRecords = dayMap[dateStr] ?? {};

      int count = 0;
      for (final habit in Habit.defaultHabits) {
        if (habitRecords[habit.id] == true) {
          count++;
        }
      }

      totalCompleted += count;
      days.add(DaySummary(date: day, completedCount: count));
    }

    const possibleMax = 7 * 7; // 7 hábitos * 7 dias
    final completionRate = (totalCompleted / possibleMax) * 100;

    return WeeklyReportData(
      weekStart: weekDays.first,
      weekEnd: weekDays.last,
      days: days,
      totalCompleted: totalCompleted,
      completionRate: completionRate,
    );
  }

  /// Relatório Mensal
  Future<MonthlyReportData> getMonthlyReport(int year, int month) async {
    final monthDays = AppDateUtils.getMonthDays(year, month);
    final startDateStr = AppDateUtils.toDateString(monthDays.first);
    final endDateStr = AppDateUtils.toDateString(monthDays.last);

    final rawRecords = await _dbService.getRecordsInRange(
      startDateStr,
      endDateStr,
    );

    final dayMap = <String, Map<String, bool>>{};
    final habitDaysCount = <String, int>{};

    for (final habit in Habit.defaultHabits) {
      habitDaysCount[habit.id] = 0;
    }

    for (final row in rawRecords) {
      final date = row['date'] as String;
      final habitId = row['habit_id'] as String;
      final isCompleted = (row['is_completed'] as int) == 1;

      dayMap.putIfAbsent(date, () => {})[habitId] = isCompleted;

      if (isCompleted && habitDaysCount.containsKey(habitId)) {
        habitDaysCount[habitId] = (habitDaysCount[habitId] ?? 0) + 1;
      }
    }

    final days = <DaySummary>[];
    int totalChecks = 0;

    for (final day in monthDays) {
      final dateStr = AppDateUtils.toDateString(day);
      final habitRecords = dayMap[dateStr] ?? {};

      int count = 0;
      for (final habit in Habit.defaultHabits) {
        if (habitRecords[habit.id] == true) {
          count++;
        }
      }

      totalChecks += count;
      days.add(DaySummary(date: day, completedCount: count));
    }

    final totalDays = monthDays.length;
    final habitRates = <String, double>{};

    for (final habit in Habit.defaultHabits) {
      final completedDays = habitDaysCount[habit.id] ?? 0;
      habitRates[habit.id] = (completedDays / totalDays) * 100;
    }

    final totalPossibleChecks = totalDays * Habit.defaultHabits.length;
    final averageRate = totalPossibleChecks > 0
        ? (totalChecks / totalPossibleChecks) * 100
        : 0.0;

    return MonthlyReportData(
      year: year,
      month: month,
      totalDaysInMonth: totalDays,
      days: days,
      habitCompletedDays: habitDaysCount,
      habitRates: habitRates,
      averageRate: averageRate,
    );
  }

  /// Relatório Anual (12 meses)
  Future<AnnualReportData> getAnnualReport(int year) async {
    final startDateStr = '$year-01-01';
    final endDateStr = '$year-12-31';

    final rawRecords = await _dbService.getRecordsInRange(
      startDateStr,
      endDateStr,
    );

    // Mês (1..12) -> total de checks concluídos
    final monthlyChecks = List<int>.filled(12, 0);

    for (final row in rawRecords) {
      final isCompleted = (row['is_completed'] as int) == 1;
      if (!isCompleted) continue;

      final dateStr = row['date'] as String;
      final parts = dateStr.split('-');
      if (parts.length >= 2) {
        final monthIdx = int.tryParse(parts[1]);
        if (monthIdx != null && monthIdx >= 1 && monthIdx <= 12) {
          monthlyChecks[monthIdx - 1]++;
        }
      }
    }

    final monthlyRates = <double>[];
    double totalRateSum = 0;

    for (int m = 1; m <= 12; m++) {
      final daysInMonth = AppDateUtils.getMonthDays(year, m).length;
      final totalPossible = daysInMonth * Habit.defaultHabits.length;
      final rate = totalPossible > 0
          ? (monthlyChecks[m - 1] / totalPossible) * 100
          : 0.0;
      monthlyRates.add(rate);
      totalRateSum += rate;
    }

    final annualAverageRate = totalRateSum / 12;

    return AnnualReportData(
      year: year,
      monthlyRates: monthlyRates,
      annualAverageRate: annualAverageRate,
    );
  }

  /// Cálculo de Streaks (Sequências)
  Future<List<HabitStreak>> getStreaks() async {
    final allRecords = await _dbService.getAllRecords();

    // Map de habitId -> Set de datas concluídas 'YYYY-MM-DD'
    final habitCompletedDates = <String, Set<String>>{};
    for (final habit in Habit.defaultHabits) {
      habitCompletedDates[habit.id] = <String>{};
    }

    for (final row in allRecords) {
      final habitId = row['habit_id'] as String;
      final isCompleted = (row['is_completed'] as int) == 1;
      final date = row['date'] as String;

      if (isCompleted && habitCompletedDates.containsKey(habitId)) {
        habitCompletedDates[habitId]!.add(date);
      }
    }

    final streaks = <HabitStreak>[];
    final today = AppDateUtils.today;
    final todayStr = AppDateUtils.toDateString(today);
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = AppDateUtils.toDateString(yesterday);

    for (final habit in Habit.defaultHabits) {
      final completedSet = habitCompletedDates[habit.id] ?? {};

      // 1. Calcular Streak Atual
      int currentStreak = 0;
      DateTime checkDate = today;

      // Se não marcou hoje, começa a checar de ontem para dar chance de marcar hoje
      if (!completedSet.contains(todayStr)) {
        if (completedSet.contains(yesterdayStr)) {
          checkDate = yesterday;
        } else {
          checkDate = today; // Streak é 0
        }
      }

      while (completedSet.contains(AppDateUtils.toDateString(checkDate))) {
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }

      // 2. Calcular Maior Streak Histórico (Longest Streak)
      int longestStreak = 0;
      if (completedSet.isNotEmpty) {
        final sortedDates =
            completedSet.map(AppDateUtils.parseDateString).toList()
              ..sort((a, b) => a.compareTo(b));

        int tempStreak = 0;
        DateTime? previousDate;

        for (final date in sortedDates) {
          if (previousDate == null) {
            tempStreak = 1;
          } else {
            final difference = date.difference(previousDate).inDays;
            if (difference == 1) {
              tempStreak++;
            } else if (difference > 1) {
              tempStreak = 1;
            }
          }
          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
          }
          previousDate = date;
        }
      }

      streaks.add(
        HabitStreak(
          habitId: habit.id,
          currentStreak: currentStreak,
          longestStreak: longestStreak,
          totalCompletedDays: completedSet.length,
        ),
      );
    }

    return streaks;
  }
}
