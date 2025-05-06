import 'package:flutter_calendar_project/stores/holidays_store.dart';
import 'package:flutter_calendar_project/utils/holidays.dart';

class HolidayManager {
  final List<Holiday> _holidays = [];
  final HolidayStorage storage = HolidayStorage();

  Future<void> init() async {
    _holidays.clear();
    _holidays.addAll(await storage.loadHolidays());
  }

  List<Holiday> getAll() => _holidays;

  Future<void> add(Holiday holiday) async {
    _holidays.add(holiday);
    await storage.saveHolidays(_holidays);
  }

  Future<void> update(int index, Holiday holiday) async {
    if (index >= 0 && index < _holidays.length) {
      _holidays[index] = holiday;
      await storage.saveHolidays(_holidays);
    }
  }

  Future<void> delete(int index) async {
    if (index >= 0 && index < _holidays.length) {
      _holidays.removeAt(index);
      await storage.saveHolidays(_holidays);
    }
  }
}
