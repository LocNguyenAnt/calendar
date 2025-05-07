import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_project/utils/gan_zhi_utils.dart';
import 'package:flutter_calendar_project/utils/holidays.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lunarInfo = getFullLunarInfo(_targetDate);

    if (!_isEdit) {
      return _buildCard(theme, lunarInfo);
    }

    return Dismissible(
      key: ValueKey(widget.holiday.name + _formattedDate),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.edit, color: Colors.white, size: 30),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onEdit();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Xoá ngày lễ'),
              content: const Text('Bạn có chắc chắn muốn xoá không?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Huỷ'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Xoá'),
                ),
              ],
            ),
          );
          return confirm == true;
        }
        return false;
      },
      onDismissed: (_) => widget.onDelete(),
      child: _buildCard(theme, lunarInfo),
    );
  }

  Widget _buildCard(ThemeData theme, String lunarInfo) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.holiday.name,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  if (_isEdit)
                    Icon(Icons.edit, color: theme.iconTheme.color, size: 16),
                ],
              ),
              const SizedBox(height: 8),
              Text('Ngày: $_formattedDate'),
              const SizedBox(height: 4),
              Text(lunarInfo),
              const SizedBox(height: 8),
              Text('Còn lại: $_countdownTime',
                  style: const TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ),
    );
  }
}
