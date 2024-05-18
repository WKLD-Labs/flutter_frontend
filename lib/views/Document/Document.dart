import 'package:flutter/material.dart';
import '../../widgets/nav_drawer.dart';
import 'db_controller.dart';
import 'model.dart';

class DocumentPage extends StatefulWidget {
  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  List<Document> documents = [];
  final DocumentsAPI api = DocumentsAPI();

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  void _fetchDocuments() async {
    try {
      List<Document> fetchedDocuments = await api.getList();
      setState(() {
        documents = fetchedDocuments;
      });
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  void _deleteDocument(int documentId) async {
    try {
      await api.delete(documentId);
      setState(() {
        documents.removeWhere((document) => document.id == documentId);
      });
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  void _addDocument(String name, String writer) async {
    try {
      Document newDocument = await api.create(Document(
        title: name,
        writer: writer,
        status: true, // Assuming default status is true
      ));
      setState(() {
        documents.add(newDocument);
      });
      _fetchDocuments();
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  void _updateDocument(Document updatedDocument) async {
    try {
      await api.update(updatedDocument);
      setState(() {
        int index = documents.indexWhere((doc) => doc.id == updatedDocument.id);
        if (index != -1) {
          documents[index] = updatedDocument;
        }
      });
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: DocumentBody(
        documents: documents,
        onDelete: _deleteDocument,
        onRefresh: _fetchDocuments,
      ),
      endDrawer: NavDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDocumentDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDocumentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDocumentDialog(
          onDocumentAdded: _addDocument,
        );
      },
    );
  }
}

class DocumentBody extends StatelessWidget {
  final List<Document> documents;
  final Function(int) onDelete;
  final Function() onRefresh;

  const DocumentBody({
    required this.documents,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return CardItem(
            document: documents[index],
            onDelete: onDelete,
          );
        },
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final Document document;
  final Function(int) onDelete;

  const CardItem({
    required this.document,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(document.title),
        subtitle: Text(document.writer ?? ''),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            if (document.id != null) {
              _showDeleteConfirmationDialog(context, document.id!);
            } else {
              // Handle the case where id is null
              // For example, show an error message or log a warning
              print('Document id is null');
            }
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int documentId) {
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
                onDelete(documentId);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class AddDocumentDialog extends StatefulWidget {
  final Function(String, String) onDocumentAdded;

  AddDocumentDialog({required this.onDocumentAdded});

  @override
  _AddDocumentDialogState createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<AddDocumentDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _writerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Document'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
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
            _titleController.clear();
            _writerController.clear();
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String name = _titleController.text;
            String writer = _writerController.text;
            if (name.isNotEmpty && writer.isNotEmpty) {
              widget.onDocumentAdded(name, writer);
              Navigator.of(context).pop();
            } else {
              // Show an error message or handle empty fields
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
