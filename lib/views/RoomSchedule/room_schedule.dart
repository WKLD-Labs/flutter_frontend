import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        RoomScheduleModel(id: 1, name: 'Meeting with Clients', description: 'Discuss project requirements and deliverables with clients. Provide updates on project progress and address any concerns or questions they may have.', startDate: DateTime.now().subtract(Duration(days: 5)), endDate: DateTime.now()),
        RoomScheduleModel(id: 2, name: 'Team Stand-up Meeting', description: 'Brief team members on current tasks, share updates, and discuss any blockers or challenges. Collaborate on problem-solving and ensure everyone is aligned with project goals.', startDate: DateTime.now().add(Duration(days: 1)), endDate: DateTime.now().add(Duration(days:4))),
        RoomScheduleModel(id: 3, name: 'Product Demo', description: 'Present the latest product features and enhancements to stakeholders. Gather feedback and address any questions or concerns. Showcase the value and benefits of the product.', startDate: DateTime.now().add(Duration(days: 7)), endDate: DateTime.now().add(Duration(days:8))),
        RoomScheduleModel(id: 4, name: 'Training Session', description: 'Conduct a training session for new team members. Cover essential topics and provide hands-on exercises to enhance their skills and knowledge. Offer guidance and support throughout the session.', startDate: DateTime.now().add(Duration(days: 11)), endDate: DateTime.now().add(Duration(days:12))),
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
        onPressed: ()=>showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return const NewScheduleDialog();
    },
  ),
        tooltip: 'Jadwal Baru',
        child: const Icon(Icons.add),
      ),
      endDrawer: NavDrawer(context),
    );
  }
}


class NewScheduleDialog extends StatefulWidget {
  const NewScheduleDialog({super.key});

  @override
  State<NewScheduleDialog> createState() => _NewScheduleDialogState();
}

class _NewScheduleDialogState extends State<NewScheduleDialog> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  static final DateFormat dateFormatter = DateFormat('dd MMMM yyyy');
  static final DateFormat timeFormatter = DateFormat('HH.mm');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Jadwal Ruangan Baru'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
            const Text('Pilih Tanggal:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            TextButton(
              onPressed: () async {
                DateTimeRange? dateRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)));
                if (dateRange != null) {
                  setState(() {
                    startDate = DateTime(
                      dateRange.start.year,
                      dateRange.start.month,
                      dateRange.start.day,
                      startDate.hour,
                      startDate.minute,
                      startDate.second,
                    );
                    endDate = DateTime(
                      dateRange.end.year,
                      dateRange.end.month,
                      dateRange.end.day,
                      endDate.hour,
                      endDate.minute,
                      endDate.second,
                    );
                  });
                }
              },
              child: Column(
                children: [
                  Text("Mulai: ${dateFormatter.format(startDate)}"),
                  Text("Akhir: ${dateFormatter.format(endDate)}"),
                ],
              ),
            ),
             const Text('Jam Mulai:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            TextButton(
                onPressed: () async {
                  TimeOfDay? newTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (newTime != null) {
                    setState(() {
                      startDate = DateTime(
                        startDate.year,
                        startDate.month,
                        startDate.day,
                        newTime.hour,
                        newTime.minute,
                      );
                    });
                  }
                },
                child: Text(timeFormatter.format(startDate), style: const TextStyle(fontSize: 24),)),
            const Text('Jam Akhir:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            TextButton(
                onPressed: () async {
                  TimeOfDay? newTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (newTime != null) {
                    setState(() {
                      endDate = DateTime(
                        endDate.year,
                        endDate.month,
                        endDate.day,
                        newTime.hour,
                        newTime.minute,
                      );
                    });
                  }
                },
                child: Text(timeFormatter.format(endDate), style: const TextStyle(fontSize: 24),),)
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Simpan'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
  }
}