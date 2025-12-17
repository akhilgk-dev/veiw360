import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerSearch extends StatelessWidget {
  const DatePickerSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            final selectedDates = await showCalendarDatePicker2Dialog(
              context,
              initialDates: [DateTime.now()],
            );

            if (selectedDates != null && selectedDates.isNotEmpty) {
              print('Selected date: ${selectedDates.first}');
            }
          },
          child: const Text('Pick Date'),
        ),
      ],
    );
  }

  Future<List<DateTime?>?> showCalendarDatePicker2Dialog(
    BuildContext context, {
    List<DateTime?>? initialDates,
  }) {
    return showDialog<List<DateTime?>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select date'),
          content: SizedBox(
            width: 300,
            height: 350,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.single,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                selectedDayHighlightColor: Colors.blue,
              ),
              value: initialDates ?? [],
              onValueChanged: (dates) {
                Navigator.pop(context, dates);
              },
            ),
          ),
        );
      },
    );
  }
}
