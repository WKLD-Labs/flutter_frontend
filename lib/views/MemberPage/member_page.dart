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
  final MemberAPI _memberController = MemberAPI();
  List<MemberData> members = [];
  bool isLoading = true;
  bool isDialogVisible = false;
  MemberData? selectedData;
  bool showView = false;

  @override
  void initState() {
    super.initState();
    _fetchMemberData();
  }

  Future<void> _fetchMemberData() async {
    try {
      members = await _memberController.getList();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching members: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handleCreate() async {
    try {
      if (selectedData != null) {
        final newMember = await _memberController.createMember(selectedData!);
        setState(() {
          members.add(newMember);
        });
      }
    } catch (e) {
      debugPrint('Error creating member: $e');
    }
  }

  Future<void> handleUpdate(MemberData member) async {
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

  Future<void> handleDelete(int id) async {
    try {
      await _memberController.deleteMember(id);
      setState(() {
        members.removeWhere((member) => member.id == id);
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
                                selectedData = members[index];
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        members[index].name!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                          '${members[index].faculty}'),
                                      Text(
                                          '${members[index].major}'),
                                      Text(
                                          'Tahun Masuk: ${members[index].entryYear}'),
                                    ],
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
                              initialValue: selectedData?.name ?? '',
                              decoration: InputDecoration(labelText: 'Nama'),
                              onChanged: (value) => handleNameChange(value),
                            ),
                            TextFormField(
                              initialValue: selectedData?.nim ?? '',
                              decoration: InputDecoration(labelText: 'NIM'),
                              onChanged: (value) =>
                                  handleNimChange(value),
                            ),
                            TextFormField(
                              initialValue: selectedData?.faculty ?? '',
                              decoration:
                                  InputDecoration(labelText: 'Fakultas'),
                              onChanged: (value) => handleFacultyChange(value),
                            ),
                            TextFormField(
                              initialValue: selectedData?.major ?? '',
                              decoration: InputDecoration(labelText: 'Jurusan'),
                              onChanged: (value) => handleMajorChange(value),
                            ),
                            TextFormField(
                              initialValue:
                                  selectedData?.entryYear?.toString() ?? '',
                              decoration:
                                  InputDecoration(labelText: 'Tahun Masuk'),
                              onChanged: (value) =>
                                  handleEntryYearChange(value),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: handleSubmit,
                          child: Text('Save'),
                        ),
                        TextButton(
                          onPressed: handleClose,
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  ),
                if (showView)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: AlertDialog(
                      title: Text(selectedData!.name!),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("NIM: ${selectedData!.nim}"),
                            Text("Fakultas: ${selectedData!.faculty}"),
                            Text("Jurusan: ${selectedData!.major}"),
                            Text("Tahun Masuk: ${selectedData!.entryYear}"),
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
            selectedData = MemberData(
              name: '',
              nim: '',
              faculty: '',
              major: '',
              entryYear: 0,
            );
          });
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: Colors.white,
      ),
      endDrawer: NavDrawer(context),
    );
  }

  void handleNameChange(String value) {
    setState(() {
      selectedData = MemberData(
        id: selectedData?.id,
        name: value,
        nim: selectedData?.nim,
        faculty: selectedData?.faculty,
        major: selectedData?.major,
        entryYear: selectedData?.entryYear,
      );
    });
  }

  void handleNimChange(String value) {
    setState(() {
      selectedData = MemberData(
        id: selectedData?.id,
        name: selectedData?.name,
        nim: value,
        faculty: selectedData?.faculty,
        major: selectedData?.major,
        entryYear: selectedData?.entryYear,
      );
    });
  }

  void handleClassNameChange(String value) {
    setState(() {
      selectedData = MemberData(
        id: selectedData?.id,
        name: selectedData?.name,
        nim: selectedData?.nim,
        faculty: selectedData?.faculty,
        major: selectedData?.major,
        entryYear: selectedData?.entryYear,
      );
    });
  }

  void handleDepartmentChange(String value) {
    setState(() {
      selectedData = MemberData(
        id: selectedData?.id,
        name: selectedData?.name,
        nim: selectedData?.nim,
        faculty: selectedData?.faculty,
        major: selectedData?.major,
        entryYear: selectedData?.entryYear,
      );
    });
  }

  void handleFacultyChange(String value) {
    setState(() {
      selectedData = MemberData(
        id: selectedData?.id,
        name: selectedData?.name,
        nim: selectedData?.nim,
        faculty: value,
        major: selectedData?.major,
        entryYear: selectedData?.entryYear,
      );
    });
  }

  void handleMajorChange(String value) {
    setState(() {
      selectedData = MemberData(
        id: selectedData?.id,
        name: selectedData?.name,
        nim: selectedData?.nim,
        faculty: selectedData?.faculty,
        major: value,
        entryYear: selectedData?.entryYear,
      );
    });
  }

  void handleEntryYearChange(String value) {
    setState(() {
      selectedData = MemberData(
        id: selectedData?.id,
        name: selectedData?.name,
        nim: selectedData?.nim,
        faculty: selectedData?.faculty,
        major: selectedData?.major,
        entryYear:
            value.isNotEmpty ? int.parse(value) : null, // Handle empty input
      );
    });
  }

  void handleAgeChange(int value) {
    setState(() {
      selectedData = MemberData(
        id: selectedData?.id,
        name: selectedData?.name,
        nim: selectedData?.nim,
        faculty: selectedData?.faculty,
        major: selectedData?.major,
        entryYear: selectedData?.entryYear,
      );
    });
  }

  void handleSubmit() {
    if (selectedData != null) {
      if (selectedData!.id == null) {
        handleCreate();
      } else {
        handleUpdate(selectedData!);
      }
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
