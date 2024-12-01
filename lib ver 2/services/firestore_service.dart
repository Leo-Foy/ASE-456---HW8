import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Ensure you import this package

class FirestoreService {
  final CollectionReference _entriesCollection =
  FirebaseFirestore.instance.collection('time_entries');

  Future<void> addEntry(Map<String, dynamic> entryData) async {
    await _entriesCollection.add(entryData);
  }

  Future<List<Map<String, dynamic>>> queryEntries({String? date, String? task, String? tag}) async {
    Query query = _entriesCollection;

    if (date != null && date.isNotEmpty) {
      query = query.where('date', isEqualTo: date);
    }
    if (task != null && task.isNotEmpty) {
      query = query.where('task', isEqualTo: task);
    }
    if (tag != null && tag.isNotEmpty) {
      query = query.where('tag', isEqualTo: tag);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> fetchReport(String startDate, String endDate) async {
    try {
      DateTime start = DateFormat('yyyy-MM-dd').parse(startDate); // Adjust date format
      DateTime end = DateFormat('yyyy-MM-dd').parse(endDate); // Adjust date format

      QuerySnapshot querySnapshot = await _entriesCollection
          .where('date', isGreaterThanOrEqualTo: start)
          .where('date', isLessThanOrEqualTo: end)
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching report: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMostTimeConsumingTasks() async {
    try {
      QuerySnapshot querySnapshot = await _entriesCollection.get();
      List<Map<String, dynamic>> entries = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      Map<String, int> taskDurations = {};

      for (var entry in entries) {
        String from = entry['from'];
        String to = entry['to'];
        String task = entry['task'];

        // Parse the time strings (assuming 12-hour format with AM/PM)
        int fromMinutes = _parseTimeToMinutes(from);
        int toMinutes = _parseTimeToMinutes(to);

        // Calculate the duration in minutes
        int duration = toMinutes - fromMinutes;

        // If duration is negative, it means the "to" time is on the next day
        if (duration < 0) {
          duration += 24 * 60; // Add 24 hours worth of minutes
        }

        if (taskDurations.containsKey(task)) {
          taskDurations[task] = taskDurations[task]! + duration;
        } else {
          taskDurations[task] = duration;
        }
      }

      // Convert taskDurations to a list of maps
      List<Map<String, dynamic>> sortedTasks = taskDurations.entries
          .map((entry) => {
        'task': entry.key,
        'totalTime': entry.value,
      })
          .toList();

      // Sort the list by 'totalTime' in descending order
      sortedTasks.sort((a, b) => b['totalTime'].compareTo(a['totalTime']));

      return sortedTasks;
    } catch (e) {
      throw Exception('Error fetching most time-consuming tasks: $e');
    }
  }

// Helper function to parse time string (hh:mm AM/PM) to total minutes
  int _parseTimeToMinutes(String time) {
    final timeParts = time.split(' '); // Split by space to separate time and AM/PM
    final timeSplit = timeParts[0].split(':'); // Split the time into hour and minute
    int hours = int.parse(timeSplit[0]);
    int minutes = int.parse(timeSplit[1]);

    // Handle AM/PM
    if (timeParts[1].toUpperCase() == 'PM' && hours != 12) {
      hours += 12; // Convert PM hours to 24-hour format
    } else if (timeParts[1].toUpperCase() == 'AM' && hours == 12) {
      hours = 0; // Convert 12 AM to 00:00 in 24-hour format
    }

    return hours * 60 + minutes; // Return total minutes
  }
}