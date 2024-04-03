import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../model/room_schedule_model.dart';

class CalendarList extends StatelessWidget {
  const CalendarList({super.key, required this.calendarData});

  final List<RoomScheduleModel> calendarData;

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
          title: Text("Kegiatan ${index + 1}"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('11 Maret 2024 pukul 15.00'),
              Text('12 Maret 2024 pukul 16.00'),
            ],
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
