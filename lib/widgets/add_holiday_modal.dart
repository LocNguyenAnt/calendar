import 'package:flutter/material.dart';
import 'package:flutter_calendar_project/utils/holidays.dart';
import 'package:lunar/calendar/Lunar.dart';

class AddHolidayModal extends StatefulWidget {
  final Holiday? existing;

  const AddHolidayModal({super.key, this.existing});

  @override
  State<AddHolidayModal> createState() => _AddHolidayModalState();
}

class _AddHolidayModalState extends State<AddHolidayModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isLunar = false;
  bool _isEdit = true;
  int? _selectedDay;
  int? _selectedMonth;
  DateTime? _solarDate;

  @override
  void initState() {
    super.initState();

    if (widget.existing != null) {
      _nameController.text = widget.existing!.name;
      _isLunar = widget.existing!.isLunar;
      _selectedDay = widget.existing!.day;
      _selectedMonth = widget.existing!.month;

      if (!_isLunar) {
        _solarDate = DateTime(
          DateTime.now().year,
          _selectedMonth!,
          _selectedDay!,
        );
      } else {
        _convertLunarToSolar(_selectedMonth!, _selectedDay!);
      }
    }
  }

  void _convertLunarToSolar(int month, int day) {
    final lunar = Lunar.fromYmd(DateTime.now().year, month, day);
    setState(() {
      _solarDate = DateTime(lunar.getYear(), lunar.getMonth(), lunar.getDay());
      _selectedDay = lunar.getDay();
      _selectedMonth = lunar.getMonth();
    });
  }

  void _pickSolarDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _solarDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _solarDate = date;
        _selectedDay = date.day;
        _selectedMonth = date.month;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedDay != null &&
        _selectedMonth != null) {
      final holiday = Holiday(
          name: _nameController.text.trim(),
          day: _selectedDay!,
          month: _selectedMonth!,
          isLunar: _isLunar,
          isEdit: _isEdit);
      Navigator.pop(context, holiday);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.existing == null ? 'Thêm ngày lễ' : 'Sửa ngày lễ',
                  style: const TextStyle(fontSize: 18)),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên ngày lễ'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Bắt buộc nhập'
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Loại lịch:'),
                  const SizedBox(width: 8),
                  DropdownButton<bool>(
                    value: _isLunar,
                    items: const [
                      DropdownMenuItem(value: false, child: Text('Dương lịch')),
                      DropdownMenuItem(value: true, child: Text('Âm lịch')),
                    ],
                    onChanged: (val) => setState(() => _isLunar = val!),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _isLunar
                  ? Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            decoration:
                                const InputDecoration(labelText: 'Tháng'),
                            value: _selectedMonth,
                            items: List.generate(12, (i) {
                              final month = i + 1;
                              return DropdownMenuItem(
                                  value: month, child: Text('Tháng $month'));
                            }),
                            onChanged: (val) =>
                                setState(() => _selectedMonth = val),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            decoration:
                                const InputDecoration(labelText: 'Ngày'),
                            value: _selectedDay,
                            items: List.generate(30, (i) {
                              final day = i + 1;
                              return DropdownMenuItem(
                                  value: day, child: Text('Ngày $day'));
                            }),
                            onChanged: (val) =>
                                setState(() => _selectedDay = val),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            _solarDate == null
                                ? 'Chưa chọn ngày'
                                : 'Ngày đã chọn: ${_solarDate!.day}/${_solarDate!.month}',
                          ),
                        ),
                        TextButton(
                          onPressed: _pickSolarDate,
                          child: const Text('Chọn ngày dương'),
                        ),
                      ],
                    ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.existing == null ? 'Thêm' : 'Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
