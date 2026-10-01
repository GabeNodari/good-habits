import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/date_utils.dart';
import '../../tracker/presentation/tracker_controller.dart';
import '../data/reports_repository.dart';
import '../domain/consistency_metrics.dart';

class ReportReferenceDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => AppDateUtils.today;

  void setDate(DateTime date) => state = date;
}

final reportReferenceDateProvider =
    NotifierProvider<ReportReferenceDateNotifier, DateTime>(
      ReportReferenceDateNotifier.new,
    );

final weeklyReportProvider = FutureProvider<WeeklyReportData>((ref) async {
  ref.watch(dailyHabitsStatusProvider);
  final refDate = ref.watch(reportReferenceDateProvider);
  final repo = ref.watch(reportsRepositoryProvider);
  return await repo.getWeeklyReport(refDate);
});

final monthlyReportProvider = FutureProvider<MonthlyReportData>((ref) async {
  ref.watch(dailyHabitsStatusProvider);
  final refDate = ref.watch(reportReferenceDateProvider);
  final repo = ref.watch(reportsRepositoryProvider);
  return await repo.getMonthlyReport(refDate.year, refDate.month);
});

final annualReportProvider = FutureProvider<AnnualReportData>((ref) async {
  ref.watch(dailyHabitsStatusProvider);
  final refDate = ref.watch(reportReferenceDateProvider);
  final repo = ref.watch(reportsRepositoryProvider);
  return await repo.getAnnualReport(refDate.year);
});

final streaksProvider = FutureProvider<List<HabitStreak>>((ref) async {
  ref.watch(dailyHabitsStatusProvider);
  final repo = ref.watch(reportsRepositoryProvider);
  return await repo.getStreaks();
});
