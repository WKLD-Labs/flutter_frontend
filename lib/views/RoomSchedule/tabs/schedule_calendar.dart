import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:intl/intl.dart';

import '../model/room_schedule_model.dart';

class ScheduleCalendar extends StatefulWidget {
  const ScheduleCalendar({
    super.key,
    required this.month,
    required this.year,
    required this.onCalendarChanged,
    required this.onRefresh,
  });

  final int month;
  final int year;
  final Function(int, int) onCalendarChanged;
  final Future<void> Function() onRefresh;

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  late CrCalendarController _calendarController = CrCalendarController(
    onSwipe: _onCalendarSwipe,
  );

  void _onCalendarSwipe(int year, int month) {
    widget.onCalendarChanged(year, month);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _calendarController.swipeToPreviousPage,
                  icon: const Icon(Icons.arrow_back),
                ),
                TextButton(
                  onPressed: () => _calendarController.goToDate(DateTime.now()),
                  child: Text(
                    DateFormat(DateFormat.YEAR_MONTH).format(DateTime(widget.year, widget.month)),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: _calendarController.swipeToNextMonth,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            Expanded(child: CrCalendar(controller: _calendarController, initialDate: DateTime.now(), )),
          ],
        ),
      ),
    );
  }
}
