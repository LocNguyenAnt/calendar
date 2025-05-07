import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_project/utils/gan_zhi_utils.dart';
import 'package:flutter_calendar_project/utils/holidays.dart';
import 'package:intl/intl.dart';
import 'package:lunar/calendar/Lunar.dart';

class CountdownWidget extends StatefulWidget {
  final Holiday holiday;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CountdownWidget({
    super.key,
    required this.holiday,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  late DateTime _targetDate;
  late Duration _remainingTime;
  late bool _isEdit;
  String _formattedDate = '';
  String _countdownTime = '';

  @override
  void initState() {
    super.initState();
    _targetDate = widget.holiday.nextDate();
    _formattedDate = DateFormat('dd/MM/yyyy').format(_targetDate);
    _remainingTime = _targetDate.difference(DateTime.now());
    _isEdit = widget.holiday.isEdit;
    _startCountdown();
  }

  @override
  void didUpdateWidget(covariant CountdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.holiday != widget.holiday) {
      _timer.cancel();

      _targetDate = widget.holiday.nextDate();
      _formattedDate = DateFormat('dd/MM/yyyy').format(_targetDate);
      _remainingTime = _targetDate.difference(DateTime.now());

      _startCountdown();
    }
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
    final lunarInfo = getFullLunarInfo(_targetDate);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.holiday.name,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Ngày: $_formattedDate'),
            const SizedBox(height: 4),
            Text(lunarInfo),
            const SizedBox(height: 8),
            Text('Còn lại: $_countdownTime',
                style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 16),
            if (_isEdit)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: widget.onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
