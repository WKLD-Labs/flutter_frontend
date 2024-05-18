import 'package:flutter/material.dart';
import '../../widgets/nav_drawer.dart';
import 'model.dart';

class DocumentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: DocumentBody(),
      endDrawer: NavDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddDocumentDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class DocumentBody extends StatelessWidget {
  final List<Document> documents = [];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(),
        SearchResultsCount(count: documents.length),
        Expanded(
          child: ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return CardItem(document: documents[index]);
            },
          ),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class SearchResultsCount extends StatelessWidget {
  final int count;

  const SearchResultsCount({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Search Results ($count)',
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final Document document;

  const CardItem({required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Color.fromARGB(255, 146, 146, 146),
      child: ListTile(
        title: Row(
          children: [
            DocumentInfo(title: document.title, writer: document.writer),
            DocumentStatus(
                status: document.status, borrower: document.borrower),
            DocumentActions(status: document.status),
          ],
        ),
      ),
    );
  }
}

class DocumentInfo extends StatelessWidget {
  final String title;
  final String writer;

  const DocumentInfo({required this.title, required this.writer});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Text(
            writer,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class DocumentStatus extends StatelessWidget {
  final bool status;
  final String borrower;

  const DocumentStatus({required this.status, required this.borrower});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: 120,
              alignment: Alignment.center,
              color: status ? Colors.green : null,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                status ? 'Available' : borrower,
                style: TextStyle(
                  color: status ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}

class DocumentActions extends StatelessWidget {
  final bool status;

  const DocumentActions({required this.status});

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                _showDeleteConfirmationDialog(context);
              },
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this document?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteAlert(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _deleteDocument(BuildContext context) {
    // Perform delete action

    // Pop all routes until the confirmation dialog route
    Navigator.of(context)
        .popUntil(ModalRoute.withName(Navigator.defaultRouteName));

    // Show delete alert
    _showDeleteAlert(context);
  }

  void _showDeleteAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Document is deleted.'),
          actions: [
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

class AddDocumentDialog extends StatefulWidget {
  @override
  _AddDocumentDialogState createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<AddDocumentDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _writerController = TextEditingController();

  Map<String, String> documentData = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Document'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _writerController,
            decoration: InputDecoration(labelText: 'Writer'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _nameController.clear();
            _writerController.clear();
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveDocument,
          child: Text('Save'),
        ),
      ],
    );
  }

  void _saveDocument() {
    setState(() {
      documentData['name'] = _nameController.text;
      documentData['writer'] = _writerController.text;
    });
    _nameController.clear();
    _writerController.clear();
    Navigator.of(context).pop(documentData);
  }
}
