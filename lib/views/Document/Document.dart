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
  List<Document> filteredDocuments = [];
  final DocumentsAPI api = DocumentsAPI();
  final TextEditingController searchController = TextEditingController();

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
        filteredDocuments = fetchedDocuments;
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
        filteredDocuments.removeWhere((document) => document.id == documentId);
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
        filteredDocuments.add(newDocument);
      });
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
          filteredDocuments[index] = updatedDocument;
        }
      });
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  void _filterDocuments(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDocuments = documents;
      } else {
        filteredDocuments = documents
            .where((document) =>
                document.title.toLowerCase().contains(query.toLowerCase()) ||
                (document.writer?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          SearchBar(
            controller: searchController,
            onSearch: _filterDocuments,
          ),
          Expanded(
            child: DocumentBody(
              documents: filteredDocuments,
              onDelete: _deleteDocument,
              onUpdate: _updateDocument,
              onRefresh: _fetchDocuments,
            ),
          ),
        ],
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
  final Function(Document) onUpdate;
  final Function() onRefresh;

  const DocumentBody({
    required this.documents,
    required this.onDelete,
    required this.onUpdate,
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
            onUpdate: onUpdate,
          );
        },
      ),
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _writerController = TextEditingController();

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
          onPressed: () {
            String name = _nameController.text;
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

class DocumentDetailsDialog extends StatefulWidget {
  final Document document;
  final Function(Document) onUpdate;

  DocumentDetailsDialog({
    required this.document,
    required this.onUpdate,
  });

  @override
  _DocumentDetailsDialogState createState() => _DocumentDetailsDialogState();
}

class _DocumentDetailsDialogState extends State<DocumentDetailsDialog> {
  late TextEditingController _titleController;
  late TextEditingController _writerController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document.title);
    _writerController = TextEditingController(text: widget.document.writer);
    _descriptionController = TextEditingController(text: widget.document.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _writerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Document Details'),
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
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Document updatedDocument = Document(
              id: widget.document.id,
              title: _titleController.text,
              writer: _writerController.text,
              description: _descriptionController.text,
              status: widget.document.status,
              borrower: widget.document.borrower,
              createdAt: widget.document.createdAt,
              updatedAt: DateTime.now(), // Update the timestamp
            );
            widget.onUpdate(updatedDocument);
            Navigator.of(context).pop();
          },
          child: Text('Edit'),
        ),
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final Document document;
  final Function(int) onDelete;
  final Function(Document) onUpdate;

  const CardItem({
    required this.document,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: document.status ? const Color.fromARGB(255, 187, 249, 189) : const Color.fromARGB(255, 181, 181, 181),
      child: ListTile(
        title: Text(document.title),
        subtitle: Text(document.writer ?? ''),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            if (document.id != null) {
              _showDeleteConfirmationDialog(context, document.id!);
            } else {
              print('Document id is null');
            }
          },
        ),
        onTap: () {
          _showDocumentDetailsDialog(context, document);
        },
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

  void _showDocumentDetailsDialog(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DocumentDetailsDialog(
          document: document,
          onUpdate: onUpdate,
        );
      },
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchBar({
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onChanged: onSearch,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Call onSearch with current search query
            onSearch(controller.text);
          },
        ),
      ],
    );
  }
}
