import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/date_utils.dart';
import '../data/tracker_repository.dart';

/// Notifier para gerenciar a data atualmente selecionada no tracker
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => AppDateUtils.today;

  void setDate(DateTime date) => state = date;
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

/// Controller que gerencia o mapa de status dos hábitos para a data selecionada
final dailyHabitsStatusProvider =
    AsyncNotifierProvider<DailyHabitsStatusNotifier, Map<String, bool>>(
      DailyHabitsStatusNotifier.new,
    );

class DailyHabitsStatusNotifier extends AsyncNotifier<Map<String, bool>> {
  @override
  Future<Map<String, bool>> build() async {
    final selectedDate = ref.watch(selectedDateProvider);
    final dateString = AppDateUtils.toDateString(selectedDate);
    final repository = ref.watch(trackerRepositoryProvider);
    return await repository.getDayStatus(dateString);
  }

  /// Toggle com atualização otimista (UI reage imediatamente com feedback tátil)
  Future<void> toggleHabit(String habitId) async {
    final currentState = state.value ?? {};
    final currentStatus = currentState[habitId] ?? false;
    final newStatus = !currentStatus;

    // Atualização otimista imediata na UI
    final updatedMap = Map<String, bool>.from(currentState);
    updatedMap[habitId] = newStatus;
    state = AsyncData(updatedMap);

    try {
      final selectedDate = ref.read(selectedDateProvider);
      final dateString = AppDateUtils.toDateString(selectedDate);
      final repository = ref.read(trackerRepositoryProvider);

      await repository.setHabitStatus(
        habitId: habitId,
        date: dateString,
        isCompleted: newStatus,
      );
    } catch (e, st) {
      // Reverte se houver erro
      state = AsyncData(currentState);
      state = AsyncError(e, st);
    }
  }
}
