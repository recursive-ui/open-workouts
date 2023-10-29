import 'package:flutter/material.dart';

class WeekdayPicker extends StatefulWidget {
  const WeekdayPicker({
    super.key,
    required this.selectedWeekdays,
    required this.changeWeekday,
  });
  final List<bool> selectedWeekdays;
  final void Function(int) changeWeekday;

  @override
  State<WeekdayPicker> createState() => _WeekdayPickerState();
}

class _WeekdayPickerState extends State<WeekdayPicker> {
  double fontSize = 12;
  final List<String> daysOfWeek = [
    'Sun',
    'Mon',
    'Tues',
    'Wed',
    'Thurs',
    'Fri',
    'Sat'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(7, (index) {
          return Column(
            children: [
              Checkbox(
                  visualDensity: VisualDensity.compact,
                  value: widget.selectedWeekdays[index],
                  onChanged: (value) => widget.changeWeekday(index)),
              Text(daysOfWeek[index], style: TextStyle(fontSize: fontSize))
            ],
          );
        }),
      ),
    );
  }
}
