import 'package:flutter/material.dart';

import 'dart:ui';

import '../../widgets/nav_drawer.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  bool isDialogVisible = false;
  List<Map<String, dynamic>> memberData = [];
  Map<String, dynamic>? selectedData;
  bool showView = false;

  void updateMemberData() {
    // Implement your logic to fetch member data here
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
                  child: Text('New Member'),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: memberData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedData = memberData[index];
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
                              memberData[index]['data member'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Name: ${memberData[index]['Name']}',
                            ),
                            Text(
                              'NIM: ${memberData[index]['NIM']}',
                            ),
                            Text(
                              'Class: ${memberData[index]['Class']}',
                            ),
                            Text(
                              'Major: ${memberData[index]['Major']}',
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
                title: Text('New Member'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        onChanged: (value) => _handleChange('name', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'NIM'),
                        onChanged: (value) => _handleChange('nim', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Class'),
                        onChanged: (value) => _handleChange('class', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Major'),
                        onChanged: (value) => _handleChange('major', value),
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
              child: ViewMemberData(
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
        memberData.add(selectedData!); // Add the new member to the list
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

class ViewMemberData extends StatelessWidget {
  final bool showDialog;
  final Function(bool) setShowDialog;
  final Map<String, dynamic> data;

  const ViewMemberData({
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
              data['Member Name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(data['Name'] ?? ''), // Add null check for name
            Text(data['NIM'] ?? ''), // Add null check for nim
            Text(data['Class'] ?? ''), // Add null check for Class
            Text(data['Major'] ?? ''), // Add null check for Major
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