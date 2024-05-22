import 'package:cloud_firestore/cloud_firestore.dart';

class ServerTime {
  static final _firestore = FirebaseFirestore.instance;

  static Future<DateTime> getDateTime() async {
    DateTime dateTime;
    final document = await _firestore
        .collection('timestamps')
        .add({'createdAt': FieldValue.serverTimestamp()});

    final snapshot = await document.get();
    final docId = snapshot.reference.id;

    dateTime = (snapshot.data()!['createdAt'] as Timestamp).toDate().toUtc();
    await _firestore.collection('timestamps').doc(docId).delete();

    return dateTime;
  }
}
