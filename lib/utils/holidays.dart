import 'package:lunar/lunar.dart';

class Holiday {
  final String name;
  final int day;
  final int month;
  final bool isLunar;
  final bool isEdit;

  Holiday(
      {required this.name,
      required this.day,
      required this.month,
      this.isLunar = false,
      this.isEdit = true});

  DateTime nextDate({DateTime? from}) {
    final now = from ?? DateTime.now();

    if (isLunar) {
      Lunar lunar = Lunar.fromYmd(now.year, month, day);

      Solar solarDate = lunar.getSolar();

      if (solarDate.isBefore(Solar.fromDate(now))) {
        lunar = Lunar.fromYmd(now.year + 1, month, day);
        solarDate = lunar.getSolar();
      }

      return DateTime(
          solarDate.getYear(), solarDate.getMonth(), solarDate.getDay());
    } else {
      DateTime thisYear = DateTime(now.year, month, day);
      if (thisYear.isBefore(now)) {
        return DateTime(now.year + 1, month, day);
      }
      return thisYear;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'day': day,
        'month': month,
        'isLunar': isLunar,
        'isEdit': isEdit,
      };

  factory Holiday.fromJson(Map<String, dynamic> json) => Holiday(
        name: json['name'],
        day: json['day'],
        month: json['month'],
        isLunar: json['isLunar'] ?? false,
        isEdit: json['isEdit'] ?? false,
      );
}

final List<Holiday> vietnameseHolidays = [
  Holiday(name: 'Tết Dương lịch', day: 1, month: 1, isEdit: false),
  Holiday(
      name: 'Giỗ tổ Hùng Vương',
      day: 10,
      month: 3,
      isLunar: true,
      isEdit: false),
  Holiday(name: 'Ngày Giải phóng miền Nam', day: 30, month: 4, isEdit: false),
  Holiday(name: 'Ngày Quốc tế Lao động', day: 1, month: 5, isEdit: false),
  Holiday(name: 'Ngày Quốc khánh', day: 2, month: 9, isEdit: false),
  Holiday(
      name: 'Tết Nguyên Đán', day: 1, month: 1, isLunar: true, isEdit: false),
  Holiday(
      name: 'Tết Trung Thu', day: 15, month: 8, isLunar: true, isEdit: false),
];
