import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddEntryScreen extends StatefulWidget {
  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _taskController = TextEditingController();
  final _tagController = TextEditingController();

  void _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> entryData = {
        "date": _dateController.text,
        "from": _fromController.text,
        "to": _toController.text,
        "task": _taskController.text,
        "tag": _tagController.text,
      };
      await FirestoreService().addEntry(entryData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _dateController, decoration: InputDecoration(labelText: 'Date')),
              TextFormField(controller: _fromController, decoration: InputDecoration(labelText: 'From')),
              TextFormField(controller: _toController, decoration: InputDecoration(labelText: 'To')),
              TextFormField(controller: _taskController, decoration: InputDecoration(labelText: 'Task')),
              TextFormField(controller: _tagController, decoration: InputDecoration(labelText: 'Tag')),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveEntry, child: Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}