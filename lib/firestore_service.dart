import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Ajoute un document dans la collection 'maCollection'
  Future<void> addData() async {
    await firestore.collection('maCollection').add({
      'nom': 'John Doe',
      'age': 30,
    });
  }

  /// Récupère un document spécifique via son ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
      String documentId) async {
    return await firestore.collection('maCollection').doc(documentId).get();
  }

  /// Retourne un flux (stream) des documents de 'maCollection'
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollection() {
    return firestore.collection('maCollection').snapshots();
  }

  /// Met à jour le champ 'age' du document identifié par [documentId]
  Future<void> updateData(String documentId) async {
    await firestore.collection('maCollection').doc(documentId).update({
      'age': 35,
    });
  }
}
