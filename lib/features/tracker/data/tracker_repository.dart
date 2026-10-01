import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

final trackerRepositoryProvider = Provider<TrackerRepository>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return TrackerRepository(dbService);
});

class TrackerRepository {
  final DatabaseService _dbService;

  TrackerRepository(this._dbService);

  /// Retorna o mapa de hábitos completados para uma data YYYY-MM-DD
  Future<Map<String, bool>> getDayStatus(String date) async {
    return await _dbService.getDayRecords(date);
  }

  /// Alterna o status do hábito na data especificada e retorna o novo valor
  Future<bool> toggleHabit({
    required String habitId,
    required String date,
  }) async {
    return await _dbService.toggleHabitRecord(habitId, date);
  }

  /// Força o status do hábito
  Future<void> setHabitStatus({
    required String habitId,
    required String date,
    required bool isCompleted,
  }) async {
    await _dbService.setHabitRecord(habitId, date, isCompleted);
  }
}
