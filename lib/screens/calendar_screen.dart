import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar_project/stores/holidays_store.dart';
import 'package:flutter_calendar_project/utils/holidays.dart';
import 'package:flutter_calendar_project/widgets/add_holiday_modal.dart';
import 'package:flutter_calendar_project/widgets/countdown_widget.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<Holiday> _holidays = [];
  final HolidayStorage _storage = HolidayStorage();
  late ScrollController _scrollController;
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
    _loadHolidays();
    _checkScroll();
  }

  Future<void> _loadHolidays() async {
    final saved = await _storage.loadHolidays();
    if (saved.isEmpty) {
      _holidays.addAll(vietnameseHolidays);
    } else {
      _holidays.addAll(saved);
    }
    setState(() {});
  }

  void _checkScroll() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_fabVisible) setState(() => _fabVisible = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_fabVisible) setState(() => _fabVisible = true);
      }
    });
  }

  void _showAddHolidayModal({Holiday? holiday}) async {
    final Holiday? newHoliday = await showModalBottomSheet<Holiday>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddHolidayModal(existing: holiday),
    );

    if (newHoliday != null) {
      setState(() {
        if (holiday != null) {
          int index = _holidays.indexOf(holiday);
          _holidays[index] = newHoliday;
        } else {
          _holidays.add(newHoliday);
        }
      });
      await _storage.saveHolidays(_holidays);
    }
  }

  void _deleteHoliday(int index) async {
    setState(() {
      _holidays.removeAt(index);
    });
    await _storage.saveHolidays(_holidays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _holidays.length,
        itemBuilder: (context, index) {
          return CountdownWidget(
            holiday: _holidays[index],
            onDelete: () => _deleteHoliday(index),
            onEdit: () => _showAddHolidayModal(holiday: _holidays[index]),
          );
        },
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _fabVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _fabVisible ? 1 : 0,
          child: FloatingActionButton(
            onPressed: _showAddHolidayModal,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
