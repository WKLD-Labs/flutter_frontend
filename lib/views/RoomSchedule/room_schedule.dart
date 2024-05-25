import 'package:flutter/material.dart';
import 'package:wkldlabs_flutter_frontend/views/RoomSchedule/api/room_schedule_api.dart';
import '../../widgets/nav_drawer.dart';
import './tabs/schedule_calendar.dart';
import './tabs/schedule_list.dart';
import './model/room_schedule_model.dart';

class RoomSchedule extends StatefulWidget {
  const RoomSchedule({super.key});

  @override
  State<RoomSchedule> createState() => _RoomScheduleState();
}

class _RoomScheduleState extends State<RoomSchedule> {

  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  Future<List<RoomScheduleModel>>? futureRoomSchedules;

  void onCalendarChanged(int year, int month) {
    setState(() {
      currentMonth = month;
      currentYear = year;
    });
    fetchRoomSchedules();
  }

  Future<void> fetchRoomSchedules() async {
    Future<List<RoomScheduleModel>> future = RoomScheduleAPI().getList(currentMonth, currentYear);
    setState(() {
      futureRoomSchedules = future;
    });
    try {
      await future;
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    fetchRoomSchedules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Jadwal Ruangan'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.calendar_month),
                child: Text('Kalender'),
              ),
              Tab(
                icon: Icon(Icons.schedule),
                child: Text('Jadwal'),
              ),
            ],
          ),
        ),
        body: TabBarView(
            children: <Widget>[
              FutureBuilder<List<RoomScheduleModel>>(
                future: futureRoomSchedules,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ScheduleCalendar(
                      month: currentMonth,
                      year: currentYear,
                      onCalendarChanged: onCalendarChanged,
                      onRefresh: fetchRoomSchedules,
                      schedules: snapshot.data!,
                    );
                  } else if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return Center(child: TextButton(onPressed: fetchRoomSchedules, child: const Text('Error fetching data')));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder<List<RoomScheduleModel>>(
                future: futureRoomSchedules,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ScheduleList(
                      calendarData: snapshot.data!,
                      onRefresh: fetchRoomSchedules,
                    );
                  } else if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return Center(child: TextButton(onPressed: fetchRoomSchedules, child: const Text('Error fetching data')));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        endDrawer: NavDrawer(context),
      ),
    );
  }
}