import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Obtener referencia a la colección de libros del usuario
  CollectionReference _getUserBooksCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('books');
  }

  // Stream de libros del usuario
  Stream<QuerySnapshot> getBooksStream(String userId) {
    return _getUserBooksCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Contar libros del usuario
  Future<int> getBooksCount(String userId) async {
    final snapshot = await _getUserBooksCollection(userId).get();
    return snapshot.docs.length;
  }

  // Agregar libro
  Future<void> addBook({
    required String userId,
    required String title,
    required String author,
    required int pagesTotal,
    String? coverUrl,
  }) async {
    if (await getBooksCount(userId) >= 12) {
      throw Exception('Ya has alcanzado el límite de 12 libros');
    }

    await _getUserBooksCollection(userId).add({
      'title': title,
      'author': author,
      'coverUrl': coverUrl ?? '',
      'status': 'Pendiente',
      'pagesTotal': pagesTotal,
      'pagesRead': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'readingTimeMinutes': 0,
    });
  }

  // Actualizar libro
  Future<void> updateBook({
    required String userId,
    required String bookId,
    String? title,
    String? author,
    int? pagesTotal,
    int? pagesRead,
    String? status,
    String? coverUrl,
    int? readingTimeMinutes,
  }) async {
    Map<String, dynamic> updates = {};
    
    if (title != null) updates['title'] = title;
    if (author != null) updates['author'] = author;
    if (pagesTotal != null) updates['pagesTotal'] = pagesTotal;
    if (pagesRead != null) updates['pagesRead'] = pagesRead;
    if (status != null) updates['status'] = status;
    if (coverUrl != null) updates['coverUrl'] = coverUrl;
    if (readingTimeMinutes != null) updates['readingTimeMinutes'] = readingTimeMinutes;

    await _getUserBooksCollection(userId).doc(bookId).update(updates);
  }

  // Eliminar libro
  Future<void> deleteBook({
    required String userId,
    required String bookId,
    String? coverUrl,
  }) async {
    // Eliminar imagen si existe
    if (coverUrl != null && coverUrl.isNotEmpty) {
      try {
        await _storage.refFromURL(coverUrl).delete();
      } catch (e) {
        print('Error al eliminar imagen: $e');
      }
    }

    await _getUserBooksCollection(userId).doc(bookId).delete();
  }

  // Subir imagen de portada
  Future<String> uploadCoverImage(File imageFile, String userId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('covers/$userId/$fileName');
    
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Obtener estadísticas
  Future<Map<String, dynamic>> getStatistics(String userId) async {
    final snapshot = await _getUserBooksCollection(userId).get();
    
    int totalBooks = snapshot.docs.length;
    int completedBooks = 0;
    int totalPages = 0;
    int readPages = 0;
    int totalMinutes = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['status'] == 'Finalizado') completedBooks++;
      totalPages += (data['pagesTotal'] as int?) ?? 0;
      readPages += (data['pagesRead'] as int?) ?? 0;
      totalMinutes += (data['readingTimeMinutes'] as int?) ?? 0;
    }

    return {
      'totalBooks': totalBooks,
      'completedBooks': completedBooks,
      'progressPercentage': totalBooks > 0 
          ? (completedBooks / 12 * 100).toStringAsFixed(1) 
          : '0.0',
      'totalPages': totalPages,
      'readPages': readPages,
      'totalMinutes': totalMinutes,
    };
  }
}