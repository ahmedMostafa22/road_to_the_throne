import 'package:cloud_firestore/cloud_firestore.dart';

class SimplePlayer {
  final String image, name, id;

  SimplePlayer(this.image, this.name, this.id);

  static SimplePlayer fromFirestore(DocumentSnapshot doc) =>
      SimplePlayer(doc.get('image'), doc.get('name'), doc.id);
}
