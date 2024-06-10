import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wkldlabs_flutter_frontend/views/InventoryPage/API/inventory_api.dart';
import 'API/inventory_api.dart';
import 'Model/inventory_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InventoryPage extends StatefulWidget{
  const InventoryPage({super.key, required this.title});
  final String title;

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Inventory> data = [];
  DateTime selectedDate = DateTime.now();
  File? _image;
  String? _uploadedFileURL;
  final picker = ImagePicker();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();
  final TextEditingController _unitEditingController = TextEditingController();


  Map<String, dynamic> newData = {
    'name': '',
    'description': '',
    'unit': 0,
    'date': DateTime.now(),
    'image': '',
  };

  Map<String, dynamic> selectedData = {
    'id': '',
    'name': '',
    'description': '',
    'unit': 0,
    'date': DateTime.now(),
    'image': '',
  };

  static const _pageSize = 15;

  final PagingController<int, Inventory> _pagingController = PagingController(firstPageKey: 0);

  Future<void> _fetchData(int pageKey) async {
    try {
      data = await InventoryAPI().readAll();
      final start = pageKey * _pageSize;
      final end = start + _pageSize;
      final isLastPage = end >= data.length;
      await Future.delayed(const Duration(seconds: 1));
      final response = data.skip(start).take(_pageSize).toList();
      if (isLastPage) {
        _pagingController.appendLastPage(response);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(response, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _addInventory() async {
    try {
      if (_image == null) return;

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('uploads/${DateTime.now().toString()}');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      _uploadedFileURL = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        newData['image'] = _uploadedFileURL;
        print('Uploaded Image URL: $_uploadedFileURL');
      });
      await InventoryAPI().create(Inventory(
        name: newData['name'],
        description: newData['description'],
        unit: newData['unit'],
        date: newData['date'],
        image: newData['image'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      _pagingController.refresh();
    } catch (error) {
      print(error);
    }
  }

  void _updateInventory() async {
    try {
      await InventoryAPI().update(Inventory(
        id: selectedData['id'],
        name: selectedData['name'],
        description: selectedData['description'],
        unit: selectedData['unit'],
        date: selectedData['date'],
        image: selectedData['image'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      _pagingController.refresh();
    } catch (error) {
      print(error);
    }
  }

  void _deleteInventory(int id) async {
    try {
      await InventoryAPI().delete(id);
      _pagingController.refresh();
    } catch (error) {
      print(error);
    }
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadFile() async {
    if (_image == null) throw Exception('No file selected');
    String? _fileUri;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('uploads/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(_image!);

    uploadTask.then((res) async {
      _uploadedFileURL = await res.ref.getDownloadURL();
      setState(() {
        print('Uploaded Image URL: $_uploadedFileURL');
      });
      _fileUri = _uploadedFileURL;
      return _fileUri;
    });
    return _fileUri!;
  }




  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey);
    });
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        newData['date'] = picked;
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
        body: PagedListView<int, Inventory>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Inventory>(
            itemBuilder: (context, item, index) {
              return ListTile(
                title: Text(item.name),
                subtitle: Text('Jumlah Item: '+item.unit.toString()),
                leading: Container(
                  width: 50.0, // Set the width of the container
                  height: 50.0, // Set the height of the container
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(item.image),
                      fit: BoxFit.cover, // Ensures the image covers the container
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            _nameEditingController.text = item.name;
                            _descriptionEditingController.text = item.description;
                            _unitEditingController.text = item.unit.toString();

                            // Set the selected data map with the item's data
                            selectedData = {
                              'id': item.id,
                              'name': item.name,
                              'description': item.description,
                              'unit': item.unit,
                              'date': item.date,
                              'image': item.image,
                            };

                            return AlertDialog(
                              title: Center(
                                child: Text('Edit ${item.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(
                                            item.image,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          selectedData['name'] = value;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: _nameEditingController,
                                      ),
                                      SizedBox(height: 10),
                                      TextField(
                                        onChanged: (value) {
                                          selectedData['description'] = value;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Description',
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: _descriptionEditingController,
                                      ),
                                      SizedBox(height: 10),
                                      TextField(
                                        onChanged: (value) {
                                          selectedData['unit'] = int.tryParse(value) ?? 0;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Unit',
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: _unitEditingController,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    _updateInventory();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Update',
                                  ),
                                ),
                              ],
                            );
                          }
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteInventory(item.id!);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // View data dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Description: ${item.description}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Unit: ${item.unit}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Date: ${item.date.day}/${item.date.month}/${item.date.year}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    item.image,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add data dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Add Data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextField(
                            onChanged: (value) {
                              newData['name'] = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              newData['description'] = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              newData['unit'] = int.tryParse(value) ?? 0;
                            },
                            decoration: InputDecoration(
                              labelText: 'Unit',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                'Date: ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                child: Text('Select Date'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => pickImage(ImageSource.gallery),
                            child: Text('Pick Image from Gallery'),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => pickImage(ImageSource.camera),
                            child: Text('Pick Image from Camera'),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red), // Customize color as needed
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        //newData['image'] = await uploadFile();
                        _addInventory();
                        Navigator.of(context).pop();
                        // Add functionality here
                      },
                      child: Text(
                        'Add',
                      ),
                    ),
                  ],
                );
              },
            );

          },
          child: const Icon(Icons.add),
        )
    );
  }


}