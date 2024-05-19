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
  List<Map<String, dynamic>> memberData = [
    {
      'Nama': 'Habli Zulvana Ath-Thaariq',
      'NIM': '1302210024',
      'Kelas': 'SE-45-03',
      'Jurusan': 'Software Engineering',
    },
    {
      'Nama': 'Pricilla Ramadhanri Anggista Putri',
      'NIM': '1302210023',
      'Kelas': 'SE-45-03',
      'Jurusan': 'Software Engineering',
    },
  ];
  Map<String, dynamic> selectedData = {};
  bool showView = false;
  bool isSubmitting = false;

  void updateMemberData() async {
    // Contoh simulasi fetching data dari API
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      memberData = [
        {
          'Nama': 'Habli Zulvana Ath-Thaariq',
          'NIM': '1302210024',
          'Kelas': 'SE-45-03',
          'Jurusan': 'Software Engineering',
        },
        {
          'Nama': 'Pricilla Ramadhanri Anggista Putri',
          'NIM': '1302210023',
          'Kelas': 'SE-45-03',
          'Jurusan': 'Software Engineering',
        },
        // Tambahkan data anggota lainnya jika diperlukan
      ];
    });
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
                              Text(data['Nama'] ?? ''),
                              onTap: () {
                                setState(() {
                                  selectedData = data;
                                  showView = true;
                                });
                              },
                            ),
                            DataCell(Text(data['NIM'] ?? '')),
                            DataCell(Text(data['Kelas'] ?? '')),
                            DataCell(Text(data['Jurusan'] ?? '')),
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
                        decoration: InputDecoration(labelText: 'Nama'),
                        onChanged: (value) => _handleChange('Nama', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'NIM'),
                        onChanged: (value) => _handleChange('NIM', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Kelas'),
                        onChanged: (value) => _handleChange('Kelas', value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Jurusan'),
                        onChanged: (value) => _handleChange('Jurusan', value),
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
    if (isSubmitting) return; // Prevent multiple submissions

    if (selectedData['Nama'] != null &&
        selectedData['NIM'] != null &&
        selectedData['Kelas'] != null &&
        selectedData['Jurusan'] != null) {
      setState(() {
        isSubmitting = true; // Set submitting to true
        handleCreate(selectedData);
        isDialogVisible = false;
        isSubmitting = false; // Reset submitting state
        selectedData = {}; // Reset selectedData after adding the member
      });
    } else {
      // Handle case where some fields are still null (optional)
      print('Some fields are still null');
    }
  }

  void _handleClose() {
    setState(() {
      isDialogVisible = false;
      selectedData = {}; // Reset selectedData when closing the dialog
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
              data['Nama'] ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Nama: ${data['Nama']?.toString() ?? ''}'), // Add null check for Nama
            Text('NIM: ${data['NIM']?.toString() ?? ''}'), // Add null check for NIM
            Text('Kelas: ${data['Kelas']?.toString() ?? ''}'), // Add null check for Kelas
            Text('Jurusan: ${data['Jurusan']?.toString() ?? ''}'), // Add null check for Jurusan
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
