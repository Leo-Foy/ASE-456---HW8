import 'package:cloud_firestore/cloud_firestore.dart';

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
}