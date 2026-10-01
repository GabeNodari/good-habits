import 'package:flutter/material.dart';
import '../widgets/annual_chart_view.dart';
import '../widgets/monthly_chart_view.dart';
import '../widgets/streaks_view.dart';
import '../widgets/weekly_chart_view.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Relatórios'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Semanal'),
              Tab(text: 'Mensal'),
              Tab(text: 'Anual'),
              Tab(text: 'Sequências'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WeeklyChartView(),
            MonthlyChartView(),
            AnnualChartView(),
            StreaksView(),
          ],
        ),
      ),
    );
  }
}
