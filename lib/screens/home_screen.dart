import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/time_entry.dart';
import 'add_entry_screen.dart';
import 'query_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TimeEntry> _timeEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  void _fetchEntries() async {
    List<Map<String, dynamic>> data = await FirestoreService().queryEntries();
    setState(() {
      _timeEntries = data.map((entry) => TimeEntry.fromMap(entry)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchEntries,
          ),
        ],
      ),
      body: _timeEntries.isEmpty
          ? const Center(child: Text('No time entries found.'))
          : ListView.builder(
        itemCount: _timeEntries.length,
        itemBuilder: (context, index) {
          final entry = _timeEntries[index];
          return ListTile(
            title: Text(entry.task),
            subtitle: Text('${entry.date} | ${entry.from} - ${entry.to}'),
            trailing: Text(entry.tag),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'addEntry',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEntryScreen()),
              ).then((_) => _fetchEntries()); 
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'queryEntries',
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QueryScreen()),
              );
            },
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}