import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_habits/features/tracker/presentation/widgets/date_selector_bar.dart';

void main() {
  testWidgets('DateSelectorBar fits in a narrow viewport', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 348,
              child: DateSelectorBar(
                selectedDate: DateTime(2026, 10, 1),
                onDateSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
