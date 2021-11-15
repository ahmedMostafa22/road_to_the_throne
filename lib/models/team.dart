import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  final String id, name, image;

  Team(this.id, this.name, this.image);

  static Team fromFirestore(DocumentSnapshot doc) =>
      Team(doc.id, doc.get('name'), doc.get('image'));
}
