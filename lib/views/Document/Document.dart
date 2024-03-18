// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../widgets/nav_drawer.dart';
import 'Docs.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key, required this.title});

  final String title;

  @override
  State<DocumentPage> createState() => DocumentsList();
}

Widget getStatusDocs(bool status) {
  if (status) {
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.green,
    );
  } else {
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.red,
    );
  }
}

class DocumentsList extends State<DocumentPage> {
  final List<Docs> docs=[
    Docs(title: 'A', writer: 'b', status: true, borrower: '-'),
    Docs(title: 'B', writer: 'c', status: false, borrower: 'Rusdi'),
    Docs(title: 'C', writer: 'd', status: true, borrower: '-'),
  ];

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: ListView(
          children: docs.map((e) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Text(e.title),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Text(e.writer),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: getStatusDocs(e.status)
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Text(e.borrower),
                  ),
                ],
              ),
            );
          }).toList()
        ),
      endDrawer: NavDrawer(context),
      ),
    );
  }
  
}
