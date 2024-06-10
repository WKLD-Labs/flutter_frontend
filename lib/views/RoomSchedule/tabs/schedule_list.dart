import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';
import 'package:wkldlabs_flutter_frontend/views/RoomSchedule/api/room_schedule_api.dart';
import 'package:wkldlabs_flutter_frontend/views/RoomSchedule/model/room_schedule_model.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({
    super.key,
    required this.calendarData,
    required this.onRefresh, 
  });

  final Future<void> Function() onRefresh;
  final List<RoomScheduleModel> calendarData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: onRefresh,
          child: calendarData.isEmpty ? ListView(padding: const EdgeInsets.all(16), children: const [Center(child: Text('Tidak ada jadwal untuk bulan ini'))],) : ListView.separated(
            itemCount: calendarData.length,
            separatorBuilder: (context, index) => const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            itemBuilder: (context, index) => ListTile(
              title: Text(calendarData[index].name, style: (DateTime.now().isAfter(calendarData[index].startDate) && DateTime.now().isBefore(calendarData[index].endDate)) ? const TextStyle(fontWeight: FontWeight.bold) : null),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('dd MMMM yyyy \'pukul\' HH.mm').format(calendarData[index].startDate)),
                  Text(DateFormat('dd MMMM yyyy \'pukul\' HH.mm').format(calendarData[index].endDate)),
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
                          Text("Mulai: ${DateFormat('dd MMMM yyyy \'pukul\' HH.mm').format(calendarData[index].startDate)}"),
                          Text("Akhir: ${DateFormat('dd MMMM yyyy \'pukul\' HH.mm').format(calendarData[index].endDate)}"),
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
                    onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                    icon: const Icon(Icons.more_vert),
                ),
                menuChildren: [
                  MenuItemButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return ModifyScheduleDialog(onSubmit: onRefresh, schedule: calendarData[index],);
                        },
                      ),
                      child: const Text('Edit')),
                  MenuItemButton(
                      onPressed: () async {
                        try {
                          await RoomScheduleAPI().delete(calendarData[index].id!);
                          onRefresh();
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        }
                      
                      },
                      child: const Text('Hapus')),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () => showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return NewScheduleDialog(onSubmit: onRefresh,);
              },
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}



class NewScheduleDialog extends StatefulWidget {
  const NewScheduleDialog({
    super.key,
    required this.onSubmit,
    });

  final Function() onSubmit;
  @override
  State<NewScheduleDialog> createState() => _NewScheduleDialogState();
}

class _NewScheduleDialogState extends State<NewScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  static final DateFormat dateFormatter = DateFormat('dd MMMM yyyy');
  static final DateFormat timeFormatter = DateFormat('HH.mm');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Jadwal Ruangan Baru'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Kegiatan',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Kegiatan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                RoomScheduleModel newSchedule = RoomScheduleModel(
                  name: nameController.text,
                  description: descriptionController.text,
                  startDate: startDate,
                  endDate: endDate,
                );
                try {
                  await RoomScheduleAPI().create(newSchedule);
                  widget.onSubmit();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                }
                
                
              }
            },
          ),
        ],
      );
  }
}





class ModifyScheduleDialog extends StatefulWidget {
  const ModifyScheduleDialog({
    super.key,
    required this.schedule,
    required this.onSubmit,
    });

  final Function() onSubmit;
  final RoomScheduleModel schedule;
  @override
  State<ModifyScheduleDialog> createState() => _ModifyScheduleDialogState();
}

class _ModifyScheduleDialogState extends State<ModifyScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  static final DateFormat dateFormatter = DateFormat('dd MMMM yyyy');
  static final DateFormat timeFormatter = DateFormat('HH.mm');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startDate = widget.schedule.startDate;
    endDate = widget.schedule.endDate;
    nameController.text = widget.schedule.name;
    descriptionController.text = widget.schedule.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Edit Jadwal Ruangan'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Kegiatan',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Kegiatan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                RoomScheduleModel newSchedule = RoomScheduleModel(
                  id: widget.schedule.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  startDate: startDate,
                  endDate: endDate,
                );
                try {
                  await RoomScheduleAPI().update(newSchedule);
                  widget.onSubmit();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                }
                
                
              }
            },
          ),
        ],
      );
  }
}



