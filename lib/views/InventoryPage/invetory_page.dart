import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget{
  const InventoryPage({super.key, required this.title});
  final String title;

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Map<String, dynamic>> data = [
    {
      'id': '1',
      'name': 'Item 1',
      'description': 'Description 1',
      'unit': 1,
      'date': '2 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '2',
      'name': 'Item 2',
      'description': 'Description 2',
      'unit': 2,
      'date': '3 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '3',
      'name': 'Item 3',
      'description': 'Description 3',
      'unit': 3,
      'date': '4 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Image.network(data[index]['image']),
              title: Text(data[index]['name']),
              subtitle: Text(data[index]['description']),
              trailing: Text(data[index]['unit'].toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add data dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 300,
                child: AlertDialog(
                  title: const Text('Add Data'),
                  content: Column(
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Description'),
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Unit'),
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Date'),
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Image URL'),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      )
    );
  }


}