import 'package:flutter/material.dart';
import '../../domain/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback onToggle;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final completedBgColor = habit.color.withValues(
      alpha: isDark ? 0.22 : 0.12,
    );
    final uncompletedBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final borderColor = isCompleted
        ? habit.color.withValues(alpha: 0.6)
        : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isCompleted ? completedBgColor : uncompletedBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isCompleted ? 1.8 : 1.0),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: isCompleted
                  ? habit.color.withValues(alpha: 0.14)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(20),
          splashColor: habit.color.withValues(alpha: 0.2),
          highlightColor: habit.color.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Ícone com avatar colorido
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? habit.color
                        : habit.color.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      habit.icon,
                      color: isCompleted ? Colors.white : habit.color,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Título e Descrição
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        habit.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? (isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A))
                              : (isDark
                                    ? const Color(0xFFE2E8F0)
                                    : const Color(0xFF1E293B)),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        habit.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Botão de Toggle binário circular
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? habit.color : Colors.transparent,
                    border: Border.all(
                      color: isCompleted
                          ? habit.color
                          : (isDark ? Colors.white38 : Colors.black26),
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
