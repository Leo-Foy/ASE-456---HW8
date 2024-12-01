import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class QueryScreen extends StatefulWidget {
  @override
  _QueryScreenState createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final _dateController = TextEditingController();
  final _taskController = TextEditingController();
  final _tagController = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  void _queryEntries() async {
    String date = _dateController.text.toLowerCase();
    String task = _taskController.text;
    String tag = _tagController.text;

    List<Map<String, dynamic>> results = await FirestoreService().queryEntries(
      date: date.isNotEmpty ? date : null,
      task: task.isNotEmpty ? task : null,
      tag: tag.isNotEmpty ? tag : null,
    );

    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query Entries')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(controller: _dateController, decoration: InputDecoration(labelText: 'Date')),
            TextFormField(controller: _taskController, decoration: InputDecoration(labelText: 'Task')),
            TextFormField(controller: _tagController, decoration: InputDecoration(labelText: 'Tag')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _queryEntries, child: Text('Query')),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
                  return ListTile(
                    title: Text(result['task']),
                    subtitle: Text('${result['date']} | ${result['tag']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}