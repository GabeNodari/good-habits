import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  static const List<Habit> defaultHabits = [
    Habit(
      id: 'reading',
      title: 'Leitura',
      description: 'Dedique um tempo à leitura',
      icon: Icons.menu_book_rounded,
      color: Color(0xFF6366F1), // Indigo
    ),
    Habit(
      id: 'exercise',
      title: 'Atividade física',
      description: 'Movimente seu corpo',
      icon: Icons.fitness_center_rounded,
      color: Color(0xFFEF4444), // Vermelho vibrante
    ),
    Habit(
      id: 'meditation',
      title: 'Meditação',
      description: 'Faça uma pausa consciente',
      icon: Icons.self_improvement_rounded,
      color: Color(0xFF8B5CF6), // Roxo
    ),
    Habit(
      id: 'screen_time',
      title: 'Tempo de tela',
      description: 'Use telas com intenção',
      icon: Icons.screen_lock_portrait_rounded,
      color: Color(0xFFF59E0B), // Âmbar
    ),
    Habit(
      id: 'sleep',
      title: 'Dormir no horário',
      description: 'Siga seu horário planejado',
      icon: Icons.bedtime_rounded,
      color: Color(0xFF3B82F6), // Azul
    ),
    Habit(
      id: 'study',
      title: 'Estudo',
      description: 'Avance nos seus estudos',
      icon: Icons.school_rounded,
      color: Color(0xFF10B981), // Esmeralda
    ),
    Habit(
      id: 'water',
      title: 'Consumo de água',
      description: 'Mantenha uma boa hidratação',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF06B6D4), // Ciano
    ),
  ];

  static Habit? findById(String id) {
    for (final habit in defaultHabits) {
      if (habit.id == id) return habit;
    }
    return null;
  }
}

class HabitRecord {
  final String habitId;
  final String date;
  final bool isCompleted;

  const HabitRecord({
    required this.habitId,
    required this.date,
    required this.isCompleted,
  });

  factory HabitRecord.fromMap(Map<String, dynamic> map) {
    return HabitRecord(
      habitId: map['habit_id'] as String,
      date: map['date'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habit_id': habitId,
      'date': date,
      'is_completed': isCompleted ? 1 : 0,
    };
  }
}
