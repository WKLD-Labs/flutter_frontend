// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../widgets/nav_drawer.dart';

class DocumentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Perform search action
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Search Results (${10})',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // You can adjust the number of items
              itemBuilder: (context, index) {
                return CardItem(
                  title: 'Item $index',
                  subtitle: 'Subtitle $index',
                  status: index.isEven,
                  borrower: 'Borrower $index',
                );
              },
            ),
          ),
        ],
      ),
      endDrawer: NavDrawer(context),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool status;
  final String borrower;

  const CardItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.borrower,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Color.fromARGB(255, 146, 146, 146),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: 120,
                      alignment: Alignment.center,
                      color: status ? Colors.green : Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        status ? 'Available' : 'Borrowed',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (!status)
                    Expanded(
                      child: Text(
                        borrower,
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: status
                        ? IconButton(
                            onPressed: () {
                              // Handle borrow button action
                            },
                            icon: Icon(Icons.bookmark),
                            color: Colors.black,
                          )
                        : const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.bookmark),
                            color: Colors.grey,
                          ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Handle delete action
                      },
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}