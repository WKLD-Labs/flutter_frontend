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
  List<Map<String, dynamic>> meetingData = [];
  Map<String, dynamic>? selectedData;
  bool showView = false;

  void updateMeetingData() {
    // Implement your logic to fetch meeting data here
  }

  void handleCreate(Map<String, dynamic> data) {
    // Implement your logic to handle create operation here
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
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isDialogVisible = true;
                      selectedData = {}; // Initialize selectedData
                    });
                  },
                  child: Text('New Meeting'),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: meetingData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedData = meetingData[index];
                          showView = true;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meetingData[index]['meetingname'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Speaker: ${meetingData[index]['speaker']}',
                            ),
                            Text(
                              'Date & Time: ${meetingData[index]['datetime']}',
                            ),
                            Text(
                              'Meeting Link: ${meetingData[index]['meetinglink']}',
                            ),
                            Text(
                              'Description: ${meetingData[index]['description']}',
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
                        onChanged: (value) => _handleChange('meetingname', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Speaker'),
                        onChanged: (value) => _handleChange('speaker', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Date & Time'),
                        onChanged: (value) => _handleChange('Date & Time', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Meeting Link'),
                        onChanged: (value) => _handleChange('Meeting Link', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        onChanged: (value) => _handleChange('Description', value),
                      ),
                      // Add more form fields for other meeting details
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
              child: ViewPertemuanData(
                showDialog: showView,
                setShowDialog: (value) => setState(() => showView = value),
                data: selectedData!,
              ),
            ),
        ],
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
    handleCreate(selectedData!);
    setState(() {
      isDialogVisible = false;
      if (selectedData != null) {
        meetingData.add(selectedData!); // Add the new meeting to the list
      }
    });
  }

  void _handleClose() {
    setState(() {
      isDialogVisible = false;
      selectedData = null; // Reset selectedData when closing the dialog
    });
  }
}

class ViewPertemuanData extends StatelessWidget {
  final bool showDialog;
  final Function(bool) setShowDialog;
  final Map<String, dynamic> data;

  const ViewPertemuanData({
    Key? key,
    required this.showDialog,
    required this.setShowDialog,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['meetingname'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(data['speaker'] ?? ''), // Add null check for speaker
            Text(data['datetime'] != null ? data['datetime'] : ''), // Check if datetime is not null
            Text(data['meetinglink'] ?? ''), // Add null check for meetinglink
            Text(data['description'] ?? ''), // Add null check for description
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => setShowDialog(false),
                  child: Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
