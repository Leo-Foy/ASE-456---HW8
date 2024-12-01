import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _reportData = [];
  List<Map<String, dynamic>> _timeConsumingTasks = [];

  void _fetchReport() async {
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both start and end dates')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      String startDate = _startDateController.text;
      String endDate = _endDateController.text;

      // Fetch report between two dates
      List<Map<String, dynamic>> data = await FirestoreService().fetchReport(startDate, endDate);

      setState(() {
        _reportData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _fetchMostTimeConsumingTasks() async {
    try {
      setState(() => _isLoading = true);

      // Fetch most time-consuming tasks
      List<Map<String, dynamic>> data = await FirestoreService().fetchMostTimeConsumingTasks();

      setState(() {
        _timeConsumingTasks = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date (YYYY-MM-DD)'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchReport,
              child: Text('Fetch Report'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchMostTimeConsumingTasks,
              child: Text('Fetch Most Time Consuming Tasks'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: _timeConsumingTasks.isNotEmpty
                    ? _timeConsumingTasks.length
                    : _reportData.length,
                itemBuilder: (context, index) {
                  var item = _timeConsumingTasks.isNotEmpty
                      ? _timeConsumingTasks[index]
                      : _reportData[index];
                  return ListTile(
                    title: Text(item['task'] ?? 'No task'),
                    subtitle: Text('Total Time: ${item['totalTime']} minutes'),
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
