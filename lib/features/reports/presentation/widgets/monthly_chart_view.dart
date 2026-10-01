import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../tracker/domain/habit.dart';
import '../reports_controller.dart';

class MonthlyChartView extends ConsumerWidget {
  const MonthlyChartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(monthlyReportProvider);
    final refDate = ref.watch(reportReferenceDateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navegação de mês
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () {
                  ref
                      .read(reportReferenceDateProvider.notifier)
                      .setDate(DateTime(refDate.year, refDate.month - 1, 1));
                },
              ),
              Text(
                AppDateUtils.formatMonthYear(refDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () {
                  ref
                      .read(reportReferenceDateProvider.notifier)
                      .setDate(DateTime(refDate.year, refDate.month + 1, 1));
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          reportAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Center(child: Text('Erro: $err')),
            data: (data) {
              return Column(
                children: [
                  // Card do Heatmap / Calendário de Consistência
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Consistência no Mês',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Média: ${data.averageRate.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Cabeçalho dos dias da semana
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const ['D', 'S', 'T', 'Q', 'Q', 'S', 'S']
                              .map(
                                (d) => SizedBox(
                                  width: 32,
                                  child: Center(
                                    child: Text(
                                      d,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 8),

                        // Grid dos dias
                        _buildHeatmapGrid(context, data, isDark),
                        const SizedBox(height: 14),

                        // Legenda de calor
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Menos',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            ...[0, 2, 4, 6, 7].map((count) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getHeatmapColor(count, isDark),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                            const SizedBox(width: 4),
                            const Text(
                              'Mais',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Percentual de dias em que cada hábito foi cumprido
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cumprimento por Hábito',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...Habit.defaultHabits.map((habit) {
                          final daysCompleted =
                              data.habitCompletedDays[habit.id] ?? 0;
                          final rate = data.habitRates[habit.id] ?? 0.0;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          habit.icon,
                                          size: 16,
                                          color: habit.color,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          habit.title,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$daysCompleted/${data.totalDaysInMonth} dias (${rate.toStringAsFixed(0)}%)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: habit.color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: rate / 100,
                                    minHeight: 6,
                                    backgroundColor: isDark
                                        ? Colors.white10
                                        : Colors.black.withValues(alpha: 0.06),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      habit.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapGrid(BuildContext context, dynamic data, bool isDark) {
    final firstDayOfWeek = DateTime(data.year, data.month, 1).weekday % 7;
    final totalCells = firstDayOfWeek + data.totalDaysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rowCount, (rowIdx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIdx) {
              final cellIdx = rowIdx * 7 + colIdx;
              final dayNum = cellIdx - firstDayOfWeek + 1;

              if (dayNum < 1 || dayNum > data.totalDaysInMonth) {
                return const SizedBox(width: 32, height: 32);
              }

              final summary = data.days[dayNum - 1];
              final count = summary.completedCount;

              return Tooltip(
                message: 'Dia $dayNum: $count/7 hábitos',
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getHeatmapColor(count, isDark),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$dayNum',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: count >= 4
                            ? Colors.white
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Color _getHeatmapColor(int count, bool isDark) {
    if (count == 0) {
      return isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    }
    if (count <= 2) {
      return const Color(0xFF86EFAC);
    }
    if (count <= 4) {
      return const Color(0xFF34D399);
    }
    if (count <= 6) {
      return const Color(0xFF10B981);
    }
    return const Color(0xFF047857);
  }
}
