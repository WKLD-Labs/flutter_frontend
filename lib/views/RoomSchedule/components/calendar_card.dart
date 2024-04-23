import 'package:flutter/material.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:intl/intl.dart';

import '../model/room_schedule_model.dart';

class CalendarCard extends StatefulWidget {
  const CalendarCard({
    super.key,
    required this.calendarData,
  });

  final List<RoomScheduleModel> calendarData;

  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  final DateTime _currentTime = DateTime.now();
  String _calendarText = '';

  late CrCalendarController _calendarController = CrCalendarController(
    onSwipe: _onCalendarSwipe,
  );

  void _onCalendarSwipe(int year, int month) {
    final date = DateTime(year, month);
    debugPrint(date.toString());
    setState(() {
      _calendarText = DateFormat(DateFormat.YEAR_MONTH).format(date);
    });
  }

  @override
  void initState() {
    _onCalendarSwipe(_currentTime.year, _currentTime.month);
    widget.calendarData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: _calendarController.swipeToPreviousPage,
                    icon: const Icon(Icons.arrow_back)),
                TextButton(
                    onPressed: () => _calendarController.goToDate(_currentTime),
                    child: Text(
                      _calendarText,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                IconButton(
                    onPressed: _calendarController.swipeToNextMonth,
                    icon: const Icon(Icons.arrow_forward)),
              ],
            ),
            SizedBox(
              width: 320,
              height: 320,
              child: CrCalendar(
                  controller: _calendarController, initialDate: _currentTime),
            ),
          ],
        ),
      ),
    );
  }
}
