import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../model/room_schedule_model.dart';

class CalendarList extends StatelessWidget {
  const CalendarList({super.key, required this.calendarData});

  final List<RoomScheduleModel> calendarData;
  static final DateFormat formatter = DateFormat('dd MMMM yyyy \'pukul\' HH.mm');
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: calendarData.length,
        separatorBuilder: (context, index) => Divider(
          thickness: 1,
          color: Colors.grey.shade200,
        ),
        itemBuilder: (context, index) => ListTile(
          title: Text(calendarData[index].name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formatter.format(calendarData[index].startDate)),
              Text(formatter.format(calendarData[index].endDate)),
            ],
          ),
          onTap: () => showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(calendarData[index].name),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Mulai: ${formatter.format(calendarData[index].startDate)}"),
                      Text("Akhir: ${formatter.format(calendarData[index].endDate)}"),
                      const SizedBox(height: 8,),
                      const Text('Deskripsi:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                      Text(calendarData[index].description),

                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Tutup'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
          trailing: MenuAnchor(
            builder: (context, controller, child) => IconButton(
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                icon: const Icon(Icons.more_vert)),
            menuChildren: [
              MenuItemButton(
                  onPressed: () => debugPrint("Edit!"),
                  child: const Text('Edit')),
              MenuItemButton(
                  onPressed: () => debugPrint("Hapus!"),
                  child: const Text('Hapus')),
            ],
          ),
        ),
      ),
    );
  }
}
