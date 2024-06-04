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
  final MemberController _memberController = MemberController();
  List<MemberData> members = [];
  bool isLoading = true;
  bool isDialogVisible = false;
  Map<String, dynamic>? selectedData;
  bool showView = false;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchMemberData();
  }

  Future<void> _fetchMemberData() async {
    try {
      final fetchedMembers = await _memberController.fetchMembers();
      setState(() {
        members = fetchedMembers;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching members: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleCreate(Map<String, dynamic> data) async {
    try {
      final newMember = await _memberController.createMember();
      setState(() {
        members.add(newMember);
      });
    } catch (e) {
      debugPrint('Error creating member: $e');
    }
  }

  void handleUpdate(MemberData member) async {
    try {
      final updatedMember = await _memberController.updateMember(member);
      setState(() {
        int index = members.indexWhere((e) => e.id == updatedMember.id);
        if (index != -1) {
          members[index] = updatedMember;
        }
      });
    } catch (e) {
      debugPrint('Error updating member: $e');
    }
  }

  void handleDelete(int id) async {
    try {
      await _memberController.deleteMember(id);
      setState(() {
        members.removeWhere((members) => members.id == id);
      });
    } catch (e) {
      debugPrint('Error deleting member: $e');
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
                        itemCount: members.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 8);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedData = members[index].toJson();
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
                                    members[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (String choice) {
                                      if (choice == 'hapus') {
                                        handleDelete(members[index].id!);
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
                      title: Text('New Member'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Nama'),
                              onChanged: (value) => handleChange('name', value),
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'NIM'),
                              onChanged: (value) => handleChange('studentId', value),
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Kelas'),
                              onChanged: (value) => handleChange('className', value),
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Jurusan'),
                              onChanged: (value) => handleChange('department', value),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            handleSubmit();
                          },
                          child: Text('Save'),
                        ),
                        TextButton(
                          onPressed: () {
                            handleClose();
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
                      title: Text(selectedData!['name']),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("NIM: ${selectedData!['studentId']}"),
                            Text("Kelas: ${selectedData!['className']}"),
                            Text("Jurusan: ${selectedData!['department']}"),
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

  void handleChange(String field, String value) {
    setState(() {
      if (selectedData != null) {
        selectedData![field] = value;
      }
    });
  }

  void handleSubmit() {
    if (selectedData != null && selectedData!.length == 6) {
      final members = MemberData.fromJson(selectedData!);
      handleCreate();
      setState(() {
        isDialogVisible = false;
        selectedData = null;
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

  void handleClose() {
    setState(() {
      isDialogVisible = false;
      selectedData = null;
    });
  }
}