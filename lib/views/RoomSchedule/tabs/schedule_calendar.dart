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
    required this.schedules,
  });

  final int month;
  final int year;
  final Function(int, int) onCalendarChanged;
  final Future<void> Function() onRefresh;
  final List<RoomScheduleModel> schedules;

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  late CrCalendarController _calendarController;

  void _onCalendarSwipe(int year, int month) {
    debugPrint("Currently ${widget.year}, ${widget.month}");
    widget.onCalendarChanged(year, month);
  }

  CrCalendarController _updateCalendar(List<RoomScheduleModel> schedules) {
    List<CalendarEventModel> scheduleCalendarList = widget.schedules.map(
      (e) => CalendarEventModel(name: e.name, begin: e.startDate, end: e.endDate),
    ).toList();
    _calendarController.events?.clear();
    _calendarController.events?.addAll(scheduleCalendarList);
    _calendarController.clearSelected();
    return _calendarController;
  }

  @override
  void initState() {
    
    List<CalendarEventModel> scheduleCalendarList = widget.schedules.map(
      (e) => CalendarEventModel(name: e.name, begin: e.startDate, end: e.endDate),
    ).toList();
    setState(() {
      _calendarController = CrCalendarController(
        onSwipe: _onCalendarSwipe,
        events: scheduleCalendarList,
      );
    });
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _onCalendarSwipe(DateTime.now().year, DateTime.now().month));
  }

  // @override
  // void didChangeDependencies() {
  //   debugPrint("changedep")
  //   _updateCalendar();
  //   super.didChangeDependencies();
  // }

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
            Expanded(child: CrCalendar(controller: _updateCalendar(widget.schedules), initialDate: DateTime.now()), ),
          ],
        ),
      ),
    );
  }
}
