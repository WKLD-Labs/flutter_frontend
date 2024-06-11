import 'package:flutter/material.dart';
import 'package:wkldlabs_flutter_frontend/views/DaftarPertemuan/api/pertemuan_api.dart';
import 'dart:ui';
import 'model/pertemuan_model.dart';
import '../../widgets/nav_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class DaftarPertemuan extends StatefulWidget {
  const DaftarPertemuan({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DaftarPertemuan> createState() => _DaftarPertemuanState();
}

class _DaftarPertemuanState extends State<DaftarPertemuan> {
  final MeetingAPI _meetingController = MeetingAPI();
  final _formKey = GlobalKey<FormState>();
  List<Meeting> meetings = [];
  bool isLoading = true;
  bool isDialogVisible = false;
  Map<String, dynamic>? selectedData;
  bool showView = false;
  int? selectedIndex;
  final _meetingNameController = TextEditingController();
  final _speakerController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  final _descriptionController = TextEditingController();

  Map<String, dynamic> newData = {
    'meetingname': '',
    'speaker': '',
    'datetime': DateTime.now(),
    'meetinglink': '',
    'description': '',
  };

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMeetings();
  }

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}


  Future<void> _fetchMeetings() async {
    try {
      final fetchedMeetings = await _meetingController.getList();
      setState(() {
        meetings = fetchedMeetings;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error fetching meetings: $e');
      debugPrintStack(stackTrace: stackTrace);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleCreate() async {
    try {
      print(newData);
      print(_speakerController.text);
      final newMeeting = await _meetingController.createMeeting(Meeting(
        meetingname: _meetingNameController.text,
        speaker: _speakerController.text,
        datetime: newData['datetime'],
        meetinglink: _meetingLinkController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      setState(() {
        meetings.add(newMeeting);
      });
    } catch (error) {
      print(error);
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
      await MeetingAPI().deleteMeeting(id);
      await _fetchMeetings();
    } catch (error) {
      print(error);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    meetings[index].meetingname!,
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Meeting Name'),
                                controller: _meetingNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Meeting Name tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Speaker'),
                                controller: _speakerController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Speaker Name tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _dateController,
                                onTap: () {
                                  _selectDate();
                                },
                                readOnly: true,
                                decoration:
                                    InputDecoration(labelText: 'Datetime'),
                                onChanged: (value) {
                                  setState(() {
                                    newData['datetime'] = value;
                                  });
                                },
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Meeting Link'),
                                controller: _meetingLinkController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'MeetingLink tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Description'),
                                controller: _descriptionController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Description tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            child: Text('Save'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _handleCreate();
                                _handleClose();
                              }
                            }),
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
                            Text("Datetime: ${selectedData!['datetime']}"),
                            Text(
                                "Meeting Link: "),
                            GestureDetector(
                              onTap: () async {
                                final url = selectedData?['meetinglink'];
                                if (url != null) {
                                  await _launchUrl(url);
                                }
                              },
                              child: Text(
                                "Meeting Link: ${selectedData?['meetinglink'] ?? 'Not Available'}",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                                "Description: ${selectedData!['description']}"),
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
            _meetingNameController.text = "";
            _speakerController.text = "";
            _dateController.text = "";
            _meetingLinkController.text = "";
            _descriptionController.text = "";
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
    if (selectedData != null) {
      if (selectedData!['time'] != null) {
        final meeting = Meeting(
          id: selectedData!['id'],
          meetingname: selectedData!['meetingname'],
          speaker: selectedData!['speaker'],
          datetime: DateTime.parse(selectedData!['datetime']),
          meetinglink: selectedData!['meetinglink'],
          description: selectedData!['description'],
          createdAt: DateTime.parse(selectedData!['createdAt']),
          updatedAt: DateTime.parse(selectedData!['updatedAt']),
        );

        print('Meeting Data:');
        print('ID: ${meeting.id}');
        print('Meeting Name: ${meeting.meetingname}');
        print('Speaker: ${meeting.speaker}');
        print('Date: ${meeting.datetime}');
        print('Meeting Link: ${meeting.meetinglink}');
        print('Description: ${meeting.description}');
        print('Created At: ${meeting.createdAt}');
        print('Updated At: ${meeting.updatedAt}');

        if (selectedIndex == null) {
          _handleCreate();
        } else {
          _handleUpdate(meeting);
        }
        setState(() {
          isDialogVisible = false;
          selectedIndex = null;
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
              content: Text('Please select a time before saving.'),
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
    });
  }
}
