// lib/utils/gan_zhi_utils.dart

import 'package:lunar/calendar/Lunar.dart';

final Map<String, String> ganMap = {
  '甲': 'Giáp',
  '乙': 'Ất',
  '丙': 'Bính',
  '丁': 'Đinh',
  '戊': 'Mậu',
  '己': 'Kỷ',
  '庚': 'Canh',
  '辛': 'Tân',
  '壬': 'Nhâm',
  '癸': 'Quý',
};

final Map<String, String> zhiMap = {
  '子': 'Tý',
  '丑': 'Sửu',
  '寅': 'Dần',
  '卯': 'Mão',
  '辰': 'Thìn',
  '巳': 'Tỵ',
  '午': 'Ngọ',
  '未': 'Mùi',
  '申': 'Thân',
  '酉': 'Dậu',
  '戌': 'Tuất',
  '亥': 'Hợi',
};

String translateGanZhi(String ganZhi) {
  final parts = RegExp(r'([A-Za-z]+)([A-Za-z]+)').firstMatch(ganZhi);
  if (parts != null) {
    final gan = ganMap[parts.group(1)!] ?? parts.group(1)!;
    final zhi = zhiMap[parts.group(2)!] ?? parts.group(2)!;
    return '$gan $zhi';
  }
  return ganZhi;
}

String translateFromChinese(String gz) {
  final gan = gz.substring(0, 1);
  final zhi = gz.substring(1);

  final ganVietnamese = ganMap[gan] ?? 'Không xác định';
  final zhiVietnamese = zhiMap[zhi] ?? 'Không xác định';

  return '$ganVietnamese $zhiVietnamese';
}

String getFullLunarInfo(DateTime date) {
  final lunar = Lunar.fromDate(date);
  final lunarDay = lunar.getDay();
  final lunarMonth = lunar.getMonth();
  final ganZhiYear = translateFromChinese(lunar.getYearInGanZhi());

  return 'Âm lịch: $lunarDay/$lunarMonth • Năm: $ganZhiYear';
}
