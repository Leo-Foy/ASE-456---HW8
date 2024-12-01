class TimeEntry {
  final String date;
  final String from;
  final String to;
  final String task;
  final String tag;

  TimeEntry({
    required this.date,
    required this.from,
    required this.to,
    required this.task,
    required this.tag,
  });

  // Convert TimeEntry to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'from': from,
      'to': to,
      'task': task,
      'tag': tag,
    };
  }

  // Create TimeEntry from Firestore document
  factory TimeEntry.fromMap(Map<String, dynamic> map) {
    return TimeEntry(
      date: map['date'] ?? '',
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      task: map['task'] ?? '',
      tag: map['tag'] ?? '',
    );
  }
}