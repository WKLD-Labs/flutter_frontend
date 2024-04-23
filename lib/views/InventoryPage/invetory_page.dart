import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
    },
    {
      'id': '4',
      'name': 'Item 4',
      'description': 'Description 4',
      'unit': 4,
      'date': '5 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '5',
      'name': 'Item 5',
      'description': 'Description 5',
      'unit': 5,
      'date': '6 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '6',
      'name': 'Item 6',
      'description': 'Description 6',
      'unit': 6,
      'date': '7 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '7',
      'name': 'Item 7',
      'description': 'Description 7',
      'unit': 7,
      'date': '8 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '8',
      'name': 'Item 8',
      'description': 'Description 8',
      'unit': 8,
      'date': '9 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '9',
      'name': 'Item 9',
      'description': 'Description 9',
      'unit': 9,
      'date': '10 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '10',
      'name': 'Item 10',
      'description': 'Description 10',
      'unit': 10,
      'date': '11 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '11',
      'name': 'Item 11',
      'description': 'Description 11',
      'unit': 11,
      'date': '12 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '12',
      'name': 'Item 12',
      'description': 'Description 12',
      'unit': 12,
      'date': '13 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '13',
      'name': 'Item 13',
      'description': 'Description 13',
      'unit': 13,
      'date': '14 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '14',
      'name': 'Item 14',
      'description': 'Description 14',
      'unit': 14,
      'date': '15 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '15',
      'name': 'Item 15',
      'description': 'Description 15',
      'unit': 15,
      'date': '16 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '16',
      'name': 'Item 16',
      'description': 'Description 16',
      'unit': 16,
      'date': '17 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '17',
      'name': 'Item 17',
      'description': 'Description 17',
      'unit': 17,
      'date': '18 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '18',
      'name': 'Item 18',
      'description': 'Description 18',
      'unit': 18,
      'date': '19 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '19',
      'name': 'Item 19',
      'description': 'Description 19',
      'unit': 19,
      'date': '20 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '20',
      'name': 'Item 20',
      'description': 'Description 20',
      'unit': 20,
      'date': '21 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '21',
      'name': 'Item 21',
      'description': 'Description 21',
      'unit': 21,
      'date': '22 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '22',
      'name': 'Item 22',
      'description': 'Description 22',
      'unit': 22,
      'date': '23 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '23',
      'name': 'Item 23',
      'description': 'Description 23',
      'unit': 23,
      'date': '24 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '24',
      'name': 'Item 24',
      'description': 'Description 24',
      'unit': 24,
      'date': '25 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },
    {
      'id': '25',
      'name': 'Item 25',
      'description': 'Description 25',
      'unit': 25,
      'date': '26 April 2024',
      'image': 'https://source.unsplash.com/640x360?funny-animals',
    },

  ];

  static const _pageSize = 15;

  final PagingController<int, Map<String, dynamic>> _pagingController = PagingController(firstPageKey: 0);

  Future<void> _fetchData(int pageKey) async {
    try {
      final start = pageKey * _pageSize;
      final end = start + _pageSize;
      final isLastPage = end >= data.length;
      await Future.delayed(Duration(seconds: 2));
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





  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: PagedListView<int, Map<String, dynamic>>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
          itemBuilder: (context, item, index) {
            return ListTile(
              title: Text(item['name']),
              subtitle: Text(item['description']),
              leading: Image.network(item['image']),
              onTap: () {
                // View data dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 300,
                      child: AlertDialog(
                        title: const Text('View Data'),
                        content: Column(
                          children: <Widget>[
                            Text('Name: ${item['name']}'),
                            Text('Description: ${item['description']}'),
                            Text('Unit: ${item['unit']}'),
                            Text('Date: ${item['date']}'),
                            Image.network(item['image']),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
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