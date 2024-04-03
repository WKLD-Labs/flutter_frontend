import 'package:flutter/material.dart';

import './model/room_schedule_model.dart';

import './components/calendar_list.dart';
import './components/calendar_card.dart';

import '../../widgets/nav_drawer.dart';

class RoomSchedule extends StatefulWidget {
  const RoomSchedule({super.key});

  @override
  State<RoomSchedule> createState() => _RoomScheduleState();
}

class _RoomScheduleState extends State<RoomSchedule> {
  

  List<RoomScheduleModel> roomSchedules = [];

  @override
  void initState() {
    setState(() {
      roomSchedules = [
        RoomScheduleModel(id: 1, name: 'Kegiatan 1', description: 'Deskripsi Kegiatan 1', startDate: DateTime.now().subtract(Duration(days: 5)), endDate: DateTime.now()),
        RoomScheduleModel(id: 2, name: 'Kegiatan 2', description: 'Deskripsi Kegiatan 2', startDate: DateTime.now().add(Duration(days: 1)), endDate: DateTime.now().add(Duration(days:4))),
        RoomScheduleModel(id: 3, name: 'Kegiatan 3', description: 'Deskripsi Kegiatan 3', startDate: DateTime.now().add(Duration(days: 7)), endDate: DateTime.now().add(Duration(days:8))),
        RoomScheduleModel(id: 4, name: 'Kegiatan 4', description: 'Deskripsi Kegiatan 4', startDate: DateTime.now().add(Duration(days: 11)), endDate: DateTime.now().add(Duration(days:12))),
      ];
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Jadwal Ruangan'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.vertical,
            children: [
              CalendarCard(calendarData: roomSchedules,),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Jadwal', style: TextStyle(fontSize: 24),),
              ),
              CalendarList(calendarData: roomSchedules,)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>{},
        tooltip: 'Jadwal Baru',
        child: const Icon(Icons.add),
      ),
      endDrawer: NavDrawer(context),
    );
  }
}


