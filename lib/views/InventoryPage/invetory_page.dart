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
      body: Column(
        children: [
          const Text('Inventory Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'ID',
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Respond to button press
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          ),
          const Text('Inventory List',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          DataTable(
            columns: [
              DataColumn(label: const Text('Name')),
              DataColumn(label: const Text('Date')),
              DataColumn(label: const Text('Action')),
            ],
            rows: data.asMap().entries.map((entry) {
              int index = entry.key;
              return DataRow(
                cells: [
                  DataCell(Text(entry.value['name'].toString())),
                  DataCell(Text(entry.value['date'].toString())),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Respond to button press
                    },
                  )),
                ],
                onSelectChanged: (bool? selected) {
                  if (selected != null && selected) {
                    // Respond to row selection
                  }
                },
                color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                  }
                  if (index % 2 == 0) {
                    return Color(0xf000000); // Grey color for even rows
                  }
                  return Colors.white; // White color for odd rows
                }
                ),
              );
            }).toList()
          ),
        ],
      )
    );
  }


}