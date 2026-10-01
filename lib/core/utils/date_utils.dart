import 'package:intl/intl.dart';

class AppDateUtils {
  static final DateFormat _ymdFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayFormat = DateFormat("d 'de' MMMM", 'pt_BR');
  static final DateFormat _dayOfWeekFormat = DateFormat('EEE', 'pt_BR');
  static final DateFormat _dayMonthFormat = DateFormat('dd/MM');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'pt_BR');

  /// Converte DateTime para String YYYY-MM-DD no fuso horário local
  static String toDateString(DateTime date) {
    final local = date.toLocal();
    return _ymdFormat.format(DateTime(local.year, local.month, local.day));
  }

  /// Converte String YYYY-MM-DD para DateTime local zerado
  static DateTime parseDateString(String dateStr) {
    return _ymdFormat.parseStrict(dateStr);
  }

  /// Retorna a data de hoje normalizada (sem horas/minutos)
  static DateTime get today {
    final now = DateTime.now().toLocal();
    return DateTime(now.year, now.month, now.day);
  }

  /// String de hoje YYYY-MM-DD
  static String get todayString => toDateString(today);

  /// Formata para exibição amigável (Ex: "1 de Outubro" ou "Hoje", "Ontem")
  static String formatDisplay(DateTime date) {
    final target = DateTime(date.year, date.month, date.day);
    final now = today;
    final diff = target.difference(now).inDays;

    if (diff == 0) return 'Hoje';
    if (diff == -1) return 'Ontem';
    if (diff == 1) return 'Amanhã';

    try {
      return _displayFormat.format(target);
    } catch (_) {
      return '${target.day}/${target.month}/${target.year}';
    }
  }

  /// Dia da semana abreviado (Ex: Seg, Ter)
  static String formatDayOfWeek(DateTime date) {
    try {
      return _dayOfWeekFormat.format(date);
    } catch (_) {
      const weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
      return weekdays[date.weekday - 1];
    }
  }

  /// Mês e Ano formatados (Ex: "Outubro 2026")
  static String formatMonthYear(DateTime date) {
    try {
      final formatted = _monthYearFormat.format(date);
      return formatted[0].toUpperCase() + formatted.substring(1);
    } catch (_) {
      return '${date.month}/${date.year}';
    }
  }

  /// Formata o início e o fim de uma semana (Ex: "28/09 a 04/10")
  static String formatWeekRange(DateTime start, DateTime end) {
    return '${_dayMonthFormat.format(start.toLocal())} a '
        '${_dayMonthFormat.format(end.toLocal())}';
  }

  /// Retorna a lista de 7 dias da semana contendo a data (Segunda a Domingo)
  static List<DateTime> getWeekDays(DateTime referenceDate) {
    final local = referenceDate.toLocal();
    final normalized = DateTime(local.year, local.month, local.day);
    final monday = normalized.subtract(Duration(days: normalized.weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  /// Retorna todos os dias de um mês
  static List<DateTime> getMonthDays(int year, int month) {
    final lastDay = DateTime(year, month + 1, 0);
    return List.generate(
      lastDay.day,
      (index) => DateTime(year, month, index + 1),
    );
  }
}
