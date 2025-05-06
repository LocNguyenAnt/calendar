import 'package:flutter_calendar_project/utils/holidays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HolidayStorage {
  static const String _key = 'holidays';

  Future<void> saveHolidays(List<Holiday> holidays) async {
    final prefs = await SharedPreferences.getInstance();
    final holidayJson =
        holidays.map((holiday) => jsonEncode(holiday.toJson())).toList();
    await prefs.setStringList(_key, holidayJson);
  }

  Future<List<Holiday>> loadHolidays() async {
    final prefs = await SharedPreferences.getInstance();
    final holidayJson = prefs.getStringList(_key) ?? [];
    return holidayJson
        .map((jsonStr) => Holiday.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  Future<void> clearHolidays() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
