import 'package:flutter/material.dart';
import 'dart:ui';
import 'db_controller.dart';
import 'model.dart';
import '../../widgets/nav_drawer.dart';

class DaftarPertemuan extends StatefulWidget {
  const DaftarPertemuan({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DaftarPertemuan> createState() => _DaftarPertemuanState();
}

class _DaftarPertemuanState extends State<DaftarPertemuan> {
  final MeetingController _meetingController = MeetingController();
  List<Meeting> meetings = [];
  bool isLoading = true;
  bool isDialogVisible = false;
  Map<String, dynamic>? selectedData;
  bool showView = false;
  int? selectedIndex;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMeetings();
  }

  Future<void> _fetchMeetings() async {
    try {
      final fetchedMeetings = await _meetingController.fetchMeetings();
      setState(() {
        meetings = fetchedMeetings;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching meetings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleCreate() async {
    try {
      final newMeeting = await _meetingController.createMeeting();
      setState(() {
        meetings.add(newMeeting);
      });
    } catch (e) {
      debugPrint('Error creating meeting: $e');
    }
  }

  void _handleUpdate(Meeting meeting) async {
    try {
      final updatedMeeting = await _meetingController.updateMeeting(meeting);
      setState(() {
        int index = meetings.indexWhere((m) => m.id == updatedMeeting.id);
        if (index != -1) {
          meetings[index] = updatedMeeting;
        }
      });
    } catch (e) {
      debugPrint('Error updating meeting: $e');
    }
  }

  void _handleDelete(int id) async {
    try {
      await _meetingController.deleteMeeting(id);
      setState(() {
        meetings.removeWhere((meeting) => meeting.id == id);
      });
    } catch (e) {
      debugPrint('Error deleting meeting: $e');
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final String formattedTime = pickedTime.format(context);
      setState(() {
        _timeController.text = formattedTime;
      });
      _handleChange('time', formattedTime);
    }
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
        _handleChange('date', _dateController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: meetings.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 8);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedData = meetings[index].toJson();
                                showView = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    meetings[index].meetingname,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (String choice) {
                                      if (choice == 'hapus') {
                                        _handleDelete(meetings[index].id!);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return ['hapus'].map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (isDialogVisible)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: AlertDialog(
                      title: Text('New Meeting'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Meeting Name'),
                              onChanged: (value) =>
                                  _handleChange('meetingname', value),
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Speaker'),
                              onChanged: (value) => _handleChange('speaker', value),
                            ),
                            TextFormField(
                                controller: _dateController,
                                onTap: () {
                                  _selectDate();
                                },
                                readOnly: true,
                                decoration: InputDecoration(labelText: 'Date'),
                                onChanged: (value) {
                                  if (value != null) {
                                    _handleChange('date', _dateController.text);
                                  }
                                }),
                            TextFormField(
                              controller: _timeController,
                              decoration: InputDecoration(labelText: 'Time'),
                              onChanged: (value) => _handleChange('time', value),
                              onTap: () {
                                _selectTime(context);
                              },
                              readOnly: true,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Meeting Link'),
                              onChanged: (value) =>
                                  _handleChange('meetinglink', value),
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Description'),
                              onChanged: (value) =>
                                  _handleChange('description', value),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            _handleSubmit();
                          },
                          child: Text('Save'),
                        ),
                        TextButton(
                          onPressed: () {
                            _handleClose();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  ),
                if (showView)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: AlertDialog(
                      title: Text(selectedData!['meetingname']),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("Speaker: ${selectedData!['speaker']}"),
                            Text("Date: ${selectedData!['date']}"),
                            Text("Time: ${selectedData!['time']}"),
                            Text("Meeting Link: ${selectedData!['meetinglink']}"),
                            Text("Description: ${selectedData!['description']}"),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showView = false;
                            });
                          },
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isDialogVisible = true;
            selectedData = {};
          });
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: Colors.white,
      ),
      endDrawer: NavDrawer(context),
    );
  }

  void _handleChange(String field, String value) {
    setState(() {
      if (selectedData != null) {
        selectedData![field] = value;
      }
    });
  }

  void _handleSubmit() {
    if (selectedData != null && selectedData!.length == 6) {
      // final meeting = Meeting.fromJson(selectedData!); 
      _handleCreate();
      setState(() {
        isDialogVisible = false;
        selectedData = null;
        _dateController.clear();
        _timeController.clear();
      });
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please complete all fields before saving.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _handleClose() {
    setState(() {
      isDialogVisible = false;
      selectedData = null;
      _dateController.clear();
      _timeController.clear();
    });
  }
}
