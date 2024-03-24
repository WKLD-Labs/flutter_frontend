import 'package:flutter/material.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:intl/intl.dart';


import '../../widgets/nav_drawer.dart';

class RoomSchedule extends StatefulWidget {
  const RoomSchedule({super.key});

  @override
  State<RoomSchedule> createState() => _RoomScheduleState();
}

class _RoomScheduleState extends State<RoomSchedule> {
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: _calendarController.swipeToPreviousPage, icon: const Icon(Icons.arrow_back)),
                          TextButton(onPressed: () => _calendarController.goToDate(_currentTime), child: Text(_calendarText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)),
                          IconButton(onPressed: _calendarController.swipeToNextMonth, icon: const Icon(Icons.arrow_forward)),
                        ],
                      ),
                      SizedBox(
                        width: 320,
                        height: 320,
                        child: CrCalendar(
                          controller: _calendarController,
                          initialDate: _currentTime
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Jadwal', style: TextStyle(fontSize: 24),),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: 2,
                  separatorBuilder: (context, index) => Divider(thickness: 1, color: Colors.grey.shade200,),
                  itemBuilder: (context, index) => ListTile(
                    title: Text("Kegiatan ${index + 1}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('11 Maret 2024 pukul 15.00'),
                        Text('12 Maret 2024 pukul 16.00'),
                      ],
                    ),
                    trailing: MenuAnchor(
                      builder: (context, controller, child) => IconButton(onPressed: () => controller.isOpen ? controller.close() : controller.open(), icon: const Icon(Icons.more_vert)),
                      menuChildren: [
                        MenuItemButton(onPressed: ()=>debugPrint("Edit!"), child: const Text('Edit')),
                        MenuItemButton(onPressed: ()=>debugPrint("Hapus!"), child: const Text('Hapus')),
                      ],
                    ),
                  ),
                ),
              )
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