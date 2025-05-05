class Holiday {
  final String name;
  final DateTime Function() nextDate;

  Holiday({
    required this.name,
    required this.nextDate,
  });
}
