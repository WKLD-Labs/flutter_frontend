import 'package:flutter/material.dart';
import 'dart:ui';

import '../../widgets/nav_drawer.dart';

class DaftarPertemuan extends StatefulWidget {
  const DaftarPertemuan({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DaftarPertemuan> createState() => _DaftarPertemuanState();
}

class _DaftarPertemuanState extends State<DaftarPertemuan> {
  bool isDialogVisible = false;
  List<Map<String, dynamic>> meetingData = [
    
    {
      'meetingname':'Konsultasi TA',
      'speaker':'dr. Rani Saprina',
      'date':'2024-04-16',
      'time':'10:50 AM',
      'meetinglink': 'https://york-ac-uk.zoom.us/j/96738689931',
      'description': '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    },

    {
      'meetingname':'Konsultasi TA',
      'speaker':'dr. Richard Lee',
      'date':'2024-5-20',
      'time':'11:00 AM',
      'meetinglink': 'https://york-ac-uk.zoom.us/j/96738689931',
      'description': '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    },

    {
      'meetingname':'Konsultasi TA',
      'speaker':'dr. Suzy Maria',
      'date':'2024-04-12',
      'time':'9:50 AM',
      'meetinglink': 'https://york-ac-uk.zoom.us/j/96738689931',
      'description': '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    }

  ];
  Map<String, dynamic>? selectedData;
  bool showView = false;
  int? selectedIndex;

  void updateMeetingData() {}

  void handleCreate(Map<String, dynamic> data) {}

  void deleteMeeting(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus "Data pertemuan"?'),
          content:
              Text('Apakah anda yakin ingin menghapus data pertemuan ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  meetingData.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  
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
        lastDate: DateTime(2100));

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: meetingData.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 8);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedData = meetingData[index];
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
                              meetingData[index]['meetingname'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String choice) {
                                if (choice == 'hapus') {
                                  deleteMeeting(index);
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
                        onTap: (){
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
          backgroundColor: Colors.white),
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
    if (selectedData?.length == 6) {
      handleCreate(selectedData!);
      setState(() {
        isDialogVisible = false;
        if (selectedData != null) {
          meetingData.add(Map<String, dynamic>.from(selectedData!));
        }
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
    });
  }
}
