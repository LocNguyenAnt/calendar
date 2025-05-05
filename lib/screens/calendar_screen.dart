import 'package:flutter/material.dart';
import 'package:flutter_calendar_project/utils/holidays.dart';
import 'package:flutter_calendar_project/widgets/countdown_widget.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vietnameseHolidays.length,
        itemBuilder: (context, index) {
          final holiday = vietnameseHolidays[index];

          return CountdownWidget(holiday: holiday);
        },
      ),
    );
  }
}
