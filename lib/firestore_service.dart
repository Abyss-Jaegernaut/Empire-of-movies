import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 **Ajoute un document à une collection spécifique**
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
      debugPrint("✅ Document ajouté avec succès à '$collection'");
    } catch (e) {
      debugPrint("❌ Erreur lors de l'ajout du document : $e");
    }
  }

  /// 🔥 **Récupère un document spécifique par son ID**
  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocument(
      String collection, String documentId) async {
    try {
      final doc = await _firestore.collection(collection).doc(documentId).get();
      if (doc.exists) {
        return doc;
      } else {
        debugPrint("⚠ Document non trouvé dans '$collection'");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Erreur lors de la récupération du document : $e");
      return null;
    }
  }

  /// 🔥 **Retourne un flux de données pour suivre en temps réel une collection**
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  /// 🔥 **Met à jour un document spécifique**
  Future<void> updateData(String collection, String documentId,
      Map<String, dynamic> newData) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(newData);
      debugPrint("✅ Document '$documentId' mis à jour dans '$collection'");
    } catch (e) {
      debugPrint("❌ Erreur lors de la mise à jour du document : $e");
    }
  }

  /// 🔥 **Supprime un document spécifique**
  Future<void> deleteData(String collection, String documentId) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
      debugPrint("✅ Document '$documentId' supprimé de '$collection'");
    } catch (e) {
      debugPrint("❌ Erreur lors de la suppression du document : $e");
    }
  }
}
