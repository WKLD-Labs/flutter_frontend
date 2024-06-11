import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cr_calendar/cr_calendar.dart';

import './models/agenda_model.dart';
import './api/agenda_api.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  Future<List<AgendaModel>>? futureAgenda;

  void onCalendarChanged(int year, int month) {
    setState(() {
      currentMonth = month;
      currentYear = year;
    });
    loadAgenda();
  }

  void loadAgenda() {
    setState(() {
      futureAgenda = AgendaAPI().getList();
    });
  }

  @override
  void initState() {
    loadAgenda();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<AgendaModel>>(
          future: futureAgenda,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AgendaCalendar(
                month: currentMonth,
                year: currentYear,
                onCalendarChanged: onCalendarChanged,
                onRefresh: loadAgenda,
                agenda: snapshot.data!,
              );
            } else if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return Center(
                  child: TextButton(
                      onPressed: loadAgenda,
                      child: const Text('Error fetching data')));
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return NewAgendaDialog(
              onSubmit: loadAgenda,
            );
          },
        ),
        tooltip: 'Jadwal Baru',
        child: const Icon(Icons.add),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddKegiatanPage(),
            ),
          );
          if (result != null) {
            setState(() {
              kegiatanList.add(result);
            });
          }
        },
        child: Icon(Icons.add),
      ),*/
    );
  }
}

class AgendaCalendar extends StatefulWidget {
  const AgendaCalendar({
    super.key,
    required this.month,
    required this.year,
    required this.onCalendarChanged,
    required this.onRefresh,
    required this.agenda,
  });

  final int month;
  final int year;
  final Function(int, int) onCalendarChanged;
  final Function() onRefresh;
  final List<AgendaModel> agenda;

  @override
  State<AgendaCalendar> createState() => _AgendaCalendarState();
}

class _AgendaCalendarState extends State<AgendaCalendar> {
  late CrCalendarController _calendarController;
  CrCalendarController _updateCalendar(List<AgendaModel> agenda) {
    List<CalendarEventModel> scheduleCalendarList = agenda
        .map(
          (e) => CalendarEventModel(
              name: e.name, begin: e.startDate, end: e.endDate),
        )
        .toList();
    _calendarController.events?.clear();
    _calendarController.events?.addAll(scheduleCalendarList);
    _calendarController.clearSelected();
    return _calendarController;
  }

  void _onCalendarSwipe(int year, int month) {
    widget.onCalendarChanged(year, month);
  }

  @override
  void initState() {
    List<CalendarEventModel> agendaCalendarList = widget.agenda
        .map(
          (e) => CalendarEventModel(
              name: e.name, begin: e.startDate, end: e.endDate),
        )
        .toList();
    setState(() {
      _calendarController = CrCalendarController(
        onSwipe: _onCalendarSwipe,
        events: agendaCalendarList,
      );
    });
    super.initState();
  }

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
                    DateFormat(DateFormat.YEAR_MONTH)
                        .format(DateTime(widget.year, widget.month)),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: _calendarController.swipeToNextMonth,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            Expanded(
                child: CrCalendar(
                    controller: _updateCalendar(widget.agenda),
                    initialDate: DateTime.now(),
                    onDayClicked: (events, day) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(DateFormat('dd MMMM yyyy').format(day)),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: events
                                        .map((e) => ListTile(
                                              title: Text(e.name),
                                              subtitle: Text(
                                                  "Start : " + DateFormat('dd MMMM yyyy \'pukul\' HH.mm').format(e.begin) +
                                                      "\n" + 
                                                      "End   : " + DateFormat('dd MMMM yyyy \'pukul\' HH.mm').format(e.end)),
                                            ))
                                        .toList()),
                              ));
                    })),
          ],
        ),
      ),
    );
  }
}

class NewAgendaDialog extends StatefulWidget {
  const NewAgendaDialog({
    super.key,
    required this.onSubmit,
  });
  final Function() onSubmit;
  @override
  State<NewAgendaDialog> createState() => _NewAgendaDialogState();
}

class _NewAgendaDialogState extends State<NewAgendaDialog> {
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
      title: const Text('Agenda Baru'),
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
                      labelText: 'Nama Agenda',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Agenda tidak boleh kosong';
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
            const Text(
              'Pilih Tanggal:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () async {
                DateTimeRange? dateRange = await showDateRangePicker(
                    context: context,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
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
            const Text(
              'Jam Mulai:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            TextButton(
                onPressed: () async {
                  TimeOfDay? newTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
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
                child: Text(
                  timeFormatter.format(startDate),
                  style: const TextStyle(fontSize: 24),
                )),
            const Text(
              'Jam Akhir:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () async {
                TimeOfDay? newTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
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
              child: Text(
                timeFormatter.format(endDate),
                style: const TextStyle(fontSize: 24),
              ),
            )
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
              AgendaModel newSchedule = AgendaModel(
                name: nameController.text,
                description: descriptionController.text,
                startDate: startDate,
                endDate: endDate,
              );
              try {
                await AgendaAPI().create(newSchedule);
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
/*
class AddKegiatanPage extends StatefulWidget {
  @override
  _AddKegiatanPageState createState() => _AddKegiatanPageState();
}

class _AddKegiatanPageState extends State<AddKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _waktuMulai;
  TimeOfDay? _waktuAkhir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Kegiatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _judulController,
                  decoration: InputDecoration(labelText: 'Judul'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _deskripsiController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                ListTile(
                  title: Text(_selectedDate == null
                      ? 'Pilih Tanggal'
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text(_waktuMulai == null
                      ? 'Pilih Waktu Mulai'
                      : _waktuMulai!.format(context)),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _waktuMulai = time;
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text(_waktuAkhir == null
                      ? 'Pilih Waktu Akhir'
                      : _waktuAkhir!.format(context)),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _waktuAkhir = time;
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedDate != null &&
                          _waktuMulai != null &&
                          _waktuAkhir != null) {
                        final newKegiatan = Kegiatan(
                          judul: _judulController.text,
                          deskripsi: _deskripsiController.text,
                          tanggal: _selectedDate!,
                          waktuMulai: _waktuMulai!,
                          waktuAkhir: _waktuAkhir!,
                        );
                        Navigator.of(context).pop(newKegiatan);
                      }
                    },
                    child: Text('Tambah'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/