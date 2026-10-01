import 'package:flutter_test/flutter_test.dart';
import 'package:good_habits/core/utils/date_utils.dart';
import 'package:good_habits/features/tracker/domain/habit.dart';

void main() {
  group('Habit Model Tests', () {
    test(
      'Verifica se exatamente os 7 hábitos exigidos no AGENTS.md estão configurados',
      () {
        expect(Habit.defaultHabits.length, 7);

        final habitIds = Habit.defaultHabits.map((h) => h.id).toList();
        expect(
          habitIds,
          containsAll([
            'reading',
            'exercise',
            'meditation',
            'screen_time',
            'sleep',
            'study',
            'water',
          ]),
        );

        final habitTitles = Habit.defaultHabits.map((h) => h.title).toList();
        expect(
          habitTitles,
          containsAll([
            'Leitura',
            'Atividade física',
            'Meditação',
            'Tempo de tela controlado',
            'Dormir no horário',
            'Estudo',
            'Consumo de água adequado',
          ]),
        );
      },
    );

    test('HabitRecord toMap e fromMap', () {
      const record = HabitRecord(
        habitId: 'reading',
        date: '2026-10-01',
        isCompleted: true,
      );

      final map = record.toMap();
      expect(map['habit_id'], 'reading');
      expect(map['date'], '2026-10-01');
      expect(map['is_completed'], 1);

      final fromMap = HabitRecord.fromMap(map);
      expect(fromMap.habitId, 'reading');
      expect(fromMap.date, '2026-10-01');
      expect(fromMap.isCompleted, true);
    });
  });

  group('DateUtils Tests', () {
    test('Normalização de datas para formato YYYY-MM-DD local', () {
      final date = DateTime(2026, 10, 1, 14, 30, 45);
      final formatted = AppDateUtils.toDateString(date);
      expect(formatted, '2026-10-01');

      final parsed = AppDateUtils.parseDateString(formatted);
      expect(parsed.year, 2026);
      expect(parsed.month, 10);
      expect(parsed.day, 1);
    });

    test('Geração correta dos 7 dias da semana', () {
      final date = DateTime(2026, 10, 1); // Quinta-feira
      final weekDays = AppDateUtils.getWeekDays(date);

      expect(weekDays.length, 7);
      expect(weekDays.first.weekday, DateTime.monday);
      expect(weekDays.last.weekday, DateTime.sunday);
    });

    test('Geração correta dos dias do mês', () {
      final octDays = AppDateUtils.getMonthDays(2026, 10);
      expect(octDays.length, 31);
      expect(octDays.first.day, 1);
      expect(octDays.last.day, 31);

      final febDays = AppDateUtils.getMonthDays(2026, 2);
      expect(febDays.length, 28);
    });

    test('Formatação compacta de intervalo de semana', () {
      final start = DateTime(2026, 9, 28);
      final end = DateTime(2026, 10, 4);
      final range = AppDateUtils.formatWeekRange(start, end);
      expect(range, '28/09 a 04/10');
    });
  });
}
