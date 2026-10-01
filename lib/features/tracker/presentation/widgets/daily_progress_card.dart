import 'package:flutter/material.dart';

class DailyProgressCard extends StatelessWidget {
  final int completedCount;
  final int totalCount;

  const DailyProgressCard({
    super.key,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;
    final percentage = (progress * 100).toInt();
    final isAllCompleted = completedCount == totalCount && totalCount > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isAllCompleted
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : (isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [Colors.white, const Color(0xFFF1F5F9)]),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAllCompleted
              ? const Color(0xFF34D399)
              : (isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05)),
        ),
        boxShadow: [
          if (!isDark || isAllCompleted)
            BoxShadow(
              color: isAllCompleted
                  ? const Color(0xFF10B981).withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAllCompleted
                        ? '🎉 Metas concluídas hoje!'
                        : 'Progresso diário',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isAllCompleted
                          ? Colors.white
                          : (isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$completedCount de $totalCount hábitos feitos',
                    style: TextStyle(
                      fontSize: 13,
                      color: isAllCompleted
                          ? Colors.white.withValues(alpha: 0.9)
                          : (isDark ? Colors.white60 : Colors.black54),
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isAllCompleted
                      ? Colors.white
                      : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: isAllCompleted
                      ? Colors.white24
                      : (isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.08)),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isAllCompleted ? Colors.white : theme.colorScheme.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
