import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener usuario actual logueado
  User? get currentUser => _auth.currentUser;

  // Stream de cambios de autenticación. notifica en tiempo real cuando cambia el estado del usuario: login, logout
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login con Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null; // El usuario canceló el login
      }

      // Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Crear una nueva credencial
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Hacer login en Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      // Verificar si el usuario tiene la subcolección books
      await _ensureUserBooksCollection(userCredential.user!.uid);

      return userCredential;
    } catch (e) {
      print('Error en signInWithGoogle: $e');
      rethrow;
    }
  }

  // Asegurar que el usuario tenga su colección de libros
  Future<void> _ensureUserBooksCollection(String userId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    
    // Verificar si el documento del usuario existe
    final docSnapshot = await userDoc.get();
    
    if (!docSnapshot.exists) {
      // Crear documento del usuario
      await userDoc.set({
        'createdAt': FieldValue.serverTimestamp(),
        'email': currentUser?.email,
        'displayName': currentUser?.displayName,
        'photoURL': currentUser?.photoURL,
      });
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}