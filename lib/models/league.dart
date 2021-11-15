import 'package:cloud_firestore/cloud_firestore.dart';

class League {
  final String winnerPlayerId, id, name;
  final DateTime date;
  final List<String> playersIds;

  League(this.winnerPlayerId, this.date, this.id, this.playersIds, this.name);

  static League fromFirebase(DocumentSnapshot doc) => League(
      doc.get('winnerPlayerId'),
      DateTime.parse(doc.get('date')),
      doc.id,
      (doc.get('playersIds') as List).map((p) => p.toString()).toList(),
      doc.get('name'));
}
