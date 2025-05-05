import 'package:flutter/material.dart';
import 'package:flutter_calendar_project/utils/holidays.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class CountdownWidget extends StatefulWidget {
  final Holiday holiday;

  const CountdownWidget({
    Key? key,
    required this.holiday,
  }) : super(key: key);

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  late DateTime _targetDate;
  late Duration _remainingTime;
  String _formattedDate = '';
  String _countdownTime = '';

  @override
  void initState() {
    super.initState();
    _targetDate = widget.holiday.nextDate();
    _formattedDate = DateFormat('dd/MM/yyyy').format(_targetDate);
    _remainingTime = _targetDate.difference(DateTime.now());
    _startCountdown();
  }

  void _startCountdown() {
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (_targetDate.isAfter(now)) {
        setState(() {
          _remainingTime = _targetDate.difference(now);
          _updateCountdown();
        });
      } else {
        timer.cancel();
        setState(() {
          _countdownTime = 'Đã đến hạn!';
        });
      }
    });
  }

  void _updateCountdown() {
    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    _countdownTime = '$days ngày, $hours giờ, $minutes phút, $seconds giây';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.cardColor,
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.holiday.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _formattedDate,
              style: TextStyle(
                fontSize: 20,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _countdownTime,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.orangeAccent : Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
