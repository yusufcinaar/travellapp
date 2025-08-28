import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Kullanıcı bilgilerini Firestore'a kaydet/güncelle
      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!);
      }

      print('Email sign-in successful');
      return userCredential;
    } catch (e) {
      print('Email sign-in failed: $e');
      return null;
    }
  }

  Future<UserCredential?> signUpWithEmail(String email, String password, String fullName) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Kullanıcı bilgilerini Firestore'a kaydet
      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!, fullName);
      }

      print('Email sign-up successful');
      return userCredential;
    } catch (e) {
      print('Email sign-up failed: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Starting Google sign-in...');
      
      // Clear any existing sign-in
      await _googleSignIn.signOut();
      
      // Google kullanıcısını al
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in cancelled by user');
        return null;
      }

      // Google kimlik doğrulamasını al
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Firebase kimlik bilgilerini oluştur
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase ile giriş yap
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Kullanıcı bilgilerini Firestore'a kaydet
      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      print('Google sign-in failed: $e');
      await _googleSignIn.signOut(); // Clean up on error
      return null;
    }
  }

  Future<void> _saveUserToFirestore(User user, [String? customFullName]) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      
      // Kullanıcı zaten varsa sadece lastLogin'i güncelle
      final docSnapshot = await userDoc.get();
      
      if (docSnapshot.exists) {
        await userDoc.update({
          'lastLogin': DateTime.now().toIso8601String(),
        });
        print('User login time updated in Firestore');
      } else {
        // Yeni kullanıcı oluştur
        final userModel = UserModel(
          uid: user.uid,
          fullName: customFullName ?? user.displayName ?? 'Kullanıcı',
          email: user.email ?? '',
          createdAt: DateTime.now(),
        );
        
        await userDoc.set(userModel.toJson());
        print('New user created in Firestore with name: ${userModel.fullName}');
      }
    } catch (e) {
      print('Error saving user to Firestore: $e');
      // Firestore izin hatası olsa bile giriş akışını devam ettiriyoruz
      // Hata fırlatma, yani uygulama akışı devam edecek
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      if (currentUser == null) return null;

      final doc = await _firestore.collection('users').doc(currentUser!.uid).get();
      if (doc.exists) {
        final userData = UserModel.fromJson(doc.data()!);
        return userData;
      } else {
        // Kullanıcı belgesinin oluşturulması gerekiyor
        print('User document does not exist, creating basic user profile');
        return _createBasicUserProfile();
      }
      
    } catch (e) {
      print('Get User Data Error: $e');
      if (e.toString().contains('permission-denied')) {
        // Firestore izin hatası olduğunda temel bir kullanıcı profili döndür
        print('Firestore permission error detected, creating memory-only profile');
        return _createBasicUserProfile();
      }
      return null;
    }
  }
  
  /// Firestore olmadan temel kullanıcı profili oluştur (izin hataları için)
  UserModel _createBasicUserProfile() {
    if (currentUser == null) {
      throw Exception('Cannot create basic profile without a logged in user');
    }
    
    return UserModel(
      uid: currentUser!.uid,
      email: currentUser!.email ?? '',
      fullName: currentUser!.displayName ?? 'Kullanıcı',
      createdAt: DateTime.now(),
    );
  }

  Future<void> updateUserData(UserModel userModel) async {
    try {
      if (currentUser == null) return;
      
      final userDoc = _firestore.collection('users').doc(currentUser!.uid);
      await userDoc.update(userModel.toJson());
      print('User data updated in Firestore');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print('User signed out');
    } catch (e) {
      print('Sign out error: $e');
    }
  }
}
