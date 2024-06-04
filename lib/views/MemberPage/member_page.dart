import 'package:flutter/material.dart';
import 'dart:ui';
import 'member_controller.dart';
import 'member_model.dart';
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
  Map<String, dynamic> selectedData = {};
  bool showView = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchMemberData;
  }

  void handleCreate(Map<String, dynamic> data) {
    setState(() {
      memberData.add(data);
    });
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
                DataTable(
                  columns: [
                    DataColumn(label: Text('Nama')),
                    DataColumn(label: Text('NIM')),
                    DataColumn(label: Text('Kelas')),
                    DataColumn(label: Text('Jurusan')),
                  ],
                  rows: memberData
                      .map(
                        (data) => DataRow(
                          cells: [
                            DataCell(
                              Text(data['name'] ?? ''),
                              onTap: () {
                                setState(() {
                                  selectedData = data;
                                  showView = true;
                                });
                              },
                            ),
                            DataCell(Text(data['nim'] ?? '')),
                            DataCell(Text(data['class'] ?? '')),
                            DataCell(Text(data['major'] ?? '')),
                          ],
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isDialogVisible = true;
                      selectedData = {};
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
                      child: Container(),
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
                        decoration: InputDecoration(labelText: 'Nama'),
                        onChanged: (value) => _handleChange('name', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'NIM'),
                        onChanged: (value) => _handleChange('nim', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Kelas'),
                        onChanged: (value) => _handleChange('class', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Jurusan'),
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
                data: selectedData,
              ),
            ),
        ],
      ),
      endDrawer: NavDrawer(context),
    );
  }

  void _handleChange(String field, String value) {
    setState(() {
      selectedData[field] = value;
    });
  }

  void _handleSubmit() {
    if (isSubmitting) return;

    if (selectedData['name'] != null &&
        selectedData['nim'] != null &&
        selectedData['class'] != null &&
        selectedData['major'] != null) {
      setState(() {
        isSubmitting = true;
        addMember(selectedData).then((_) {
          handleCreate(selectedData);
          isDialogVisible = false;
          isSubmitting = false;
          selectedData = {};
        }).catchError((error) {
          isSubmitting = false;
          print(error);
        });
      });
    } else {
      print('Some fields are still Blanks');
    }
  }

  void _handleClose() {
    setState(() {
      isDialogVisible = false;
      selectedData = {};
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
              data['name'] ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Nama: ${data['name']?.toString() ?? ''}'),
            Text('NIM: ${data['nim']?.toString() ?? ''}'),
            Text('Kelas: ${data['class']?.toString() ?? ''}'),
            Text('Jurusan: ${data['major']?.toString() ?? ''}'),
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