import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/habit.dart';
import '../tracker_controller.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/date_selector_bar.dart';
import '../widgets/habit_card.dart';

class TrackerScreen extends ConsumerWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final statusAsync = ref.watch(dailyHabitsStatusProvider);

    final habitsStatus = statusAsync.value ?? {};
    final habits = Habit.defaultHabits;

    int completedCount = 0;
    for (final habit in habits) {
      if (habitsStatus[habit.id] == true) {
        completedCount++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Good Habits'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completedCount/7',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            DateSelectorBar(
              selectedDate: selectedDate,
              onDateSelected: (newDate) {
                ref.read(selectedDateProvider.notifier).setDate(newDate);
              },
            ),
            const SizedBox(height: 6),
            DailyProgressCard(
              completedCount: completedCount,
              totalCount: habits.length,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: habits.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  final isCompleted = habitsStatus[habit.id] ?? false;

                  return HabitCard(
                    habit: habit,
                    isCompleted: isCompleted,
                    onToggle: () {
                      ref
                          .read(dailyHabitsStatusProvider.notifier)
                          .toggleHabit(habit.id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
