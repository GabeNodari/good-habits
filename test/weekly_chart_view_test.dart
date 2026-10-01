import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_habits/features/reports/domain/consistency_metrics.dart';
import 'package:good_habits/features/reports/presentation/reports_controller.dart';
import 'package:good_habits/features/reports/presentation/widgets/weekly_chart_view.dart';

void main() {
  testWidgets('weekly report header fits a 360px viewport', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weeklyReportProvider.overrideWith(
            (ref) async => WeeklyReportData(
              weekStart: DateTime(2026, 9, 28),
              weekEnd: DateTime(2026, 10, 4),
              days: List.generate(
                7,
                (index) => DaySummary(
                  date: DateTime(2026, 9, 28 + index),
                  completedCount: 0,
                ),
              ),
              totalCompleted: 0,
              completionRate: 0,
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: WeeklyChartView())),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
