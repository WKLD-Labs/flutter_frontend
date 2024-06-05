import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:wkldlabs_flutter_frontend/views/RoomSchedule/model/room_schedule_model.dart";
import "package:wkldlabs_flutter_frontend/views/RoomSchedule/api/room_schedule_api.dart";
import 'package:wkldlabs_flutter_frontend/global/login_context.dart';

class RoomScheduleToday extends StatefulWidget {
  const RoomScheduleToday({
    super.key,
  });

  @override
  State<RoomScheduleToday> createState() => _RoomScheduleTodayState();
}

class _RoomScheduleTodayState extends State<RoomScheduleToday> {
  Future<List<RoomScheduleModel>>? future;
  DateTime? today;

  void loadRoomSchedules() {
    debugPrint("fetch homepage");
    setState(() {
      today = DateTime.now();
      debugPrint(today.toString());
      future = RoomScheduleAPI().getList(today!.month, today!.year);
    });
  }

  @override
  void initState() {
    loadRoomSchedules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!LoginContext.getIsLogin()) return const SizedBox();
    return FutureBuilder<List<RoomScheduleModel>>(future: future, builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<RoomScheduleModel> data = snapshot.data!;
        List<RoomScheduleModel> todaySchedules = data.where((schedule) => (today!.isAfter(schedule.startDate) && today!.isBefore(schedule.endDate))).toList();
        RoomScheduleModel? currentSchedule;
        debugPrint(data.toString());
        if (todaySchedules.length > 0) {
          currentSchedule = todaySchedules[0];
          debugPrint(currentSchedule.toString());
        }
        return Card(
          margin: EdgeInsets.fromLTRB(24, 12, 24, 6),
          clipBehavior: Clip.hardEdge,
          child: Column(  
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Penggunaan Ruangan Hari Ini:'),
                subtitle: currentSchedule != null ? Text("${currentSchedule.name}\nMulai: ${DateFormat('dd MMMM yyyy \'pukul\' HH.mm').format(currentSchedule.startDate)}\nBerakhir: ${DateFormat('dd MMMM yyyy \'pukul\' HH.mm').format(currentSchedule.endDate)}") : const Text("Ruangan tidak sedang digunakan"),
              ),
            ],
          )
        );
      } else if (snapshot.hasError) {
        return Card(
          margin: EdgeInsets.fromLTRB(24, 12, 24, 6),
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(height: 40, child: Center(child: TextButton(child: const Text("Coba Lagi"), onPressed: ()=>loadRoomSchedules,)),),
        ));
      }
      return Card(
        margin: EdgeInsets.fromLTRB(24, 12, 24, 6),
        child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(),),),
      ));
    },);
  }
}