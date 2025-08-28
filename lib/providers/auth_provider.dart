import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/favorites_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FavoritesService _favoritesService = FavoritesService();
  
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  // Kullanıcının kimlik doğrulandığını kontrol et
  // _user null değilse ve _userModel yüklenmişse kullanıcı giriş yapmış demektir
  bool get isAuthenticated => _user != null && _userModel != null && _authService.currentUser != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    // Yükleme durumunu başlat
    _isLoading = true;
    notifyListeners();
    
    // Önce SharedPreferences'dan oturum bilgisini kontrol et
    final isLoggedIn = await _checkLoginStatusFromPrefs();
    
    // Eğer SharedPreferences'da oturum bilgisi varsa ve Firebase oturumu aktifse
    _user = _authService.currentUser;
    if (isLoggedIn && _user != null) {
      print('User already logged in from prefs: ${_user?.email}');
      // Kullanıcı bilgilerini yükle
      await _loadUserData();
    } else if (_user != null) {
      // Sadece Firebase oturumu varsa, yerel oturum bilgisini kaydet
      print('Firebase session exists but no prefs: ${_user?.email}');
      await _loadUserData();
      await _saveLoginStatus(true);
    } else {
      // Kullanıcı giriş yapmamışsa yüklemeyi durdur
      _isLoading = false;
      notifyListeners();
    }
    
    // İlk kontrol tamamlandı
    
    // Auth durumu değişikliklerini dinle
    _authService.authStateChanges.listen((User? user) {
      print('Auth state changed: ${user?.email}'); // Debug log
      _user = user;
      if (user != null) {
        // Yeni giriş yapıldı, kullanıcı bilgilerini yükle
        _loadUserData();
      } else {
        // Çıkış yapıldı
        _userModel = null;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData() async {
    try {
      _isLoading = true; // Yükleme durumunu ayarla
      notifyListeners();
      
      // Firestore'dan kullanıcı verilerini almayı dene
      final userData = await _authService.getUserData();
      
      // Kullanıcı verisi bulunduysa kullan, bulunamadıysa yeni oluştur
      if (userData != null) {
        _userModel = userData;
      } else if (_user != null) {
        // Firestore'dan veri alınamadıysa Firebase Auth'tan doğrudan al
        _userModel = UserModel(
          uid: _user!.uid,
          email: _user!.email ?? '',
          fullName: _user!.displayName ?? 'Kullanıcı',
          photoUrl: _user!.photoURL,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          favoriteTrips: await _getFavoriteTripsFromJson(),
        );
      }
      
      // İşlem tamamlandı, yükleme durumunu sonlandır
      _isLoading = false;
      notifyListeners();
      print('User data loaded successfully: ${_userModel?.fullName}');
    } catch (e) {
      print('Error loading user data: $e');
      _error = e.toString();
      _isLoading = false; // Hata olsa da yükleme durumunu sonlandır
      notifyListeners();
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _authService.signInWithEmail(email, password);
      
      // Başarılı giriş yapıldığında oturum bilgisini kaydet
      if (result != null) {
        await _saveLoginStatus(true);
        
        // Kullanıcı bilgilerini yükle
        await _loadUserData();
        
        // Son giriş tarihini güncelle
        await _updateLastLogin();
        
        // Favori gezileri senkronize et
        if (_user != null) {
          await _syncFavorites(_user!.uid);
        }
        
        print('Login successful: ${_user?.email}');
      } else {
        // Giriş başarısız olduğunda yükleme durumunu sonlandır
        _isLoading = false;
        notifyListeners();
      }
      
      return result != null;
    } catch (e) {
      print('Error in signInWithEmail: $e');
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password, String fullName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _authService.signUpWithEmail(email, password, fullName);
      
      // Başarılı kayıt tamamlandığında otomatik giriş yapmıyoruz
      if (result != null) {
        await _authService.signOut(); // Oturumu sonlandır
      }
      
      // Yükleme durumunu sonlandır
      _isLoading = false;
      notifyListeners();
      
      return result != null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      print('Starting Google sign-in...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _authService.signInWithGoogle();
      
      if (result == null) {
        print('Google Sign-In failed (result was null)');
        _isLoading = false;
        _error = 'Google Sign-In failed. Please check SHA-1 configuration.';
        notifyListeners();
        return false;
      }
      
      // Başarılı Google girişinde oturum bilgisini kaydet
      await _saveLoginStatus(true);
      
      // Son giriş tarihini güncelle
      await _updateLastLogin();
      
      // Favori gezileri senkronize et
      if (result.user != null) {
        await _syncFavorites(result.user!.uid);
      }
      
      // Google girişi başarılı, authStateChanges ve _loadUserData tarafından işlenecek
      return true;
    } catch (e) {
      _isLoading = false;
      _error = "Google Sign-In Error: ${e.toString()}";
      print("Google Sign-In detaylı hata: ${e.toString()}");
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Önce SharedPreferences'dan oturum bilgisini temizle
      await _saveLoginStatus(false);
      // Sonra Firebase oturumunu kapat
      await _authService.signOut();
      _userModel = null;
      _user = null;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // SharedPreferences'a oturum durumunu kaydet
  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', isLoggedIn);
      // Kullanıcı UID'sini de kaydet (null kontrolü ile)
      if (isLoggedIn && _user != null) {
        await prefs.setString('user_uid', _user!.uid);
      } else {
        // Çıkış yaparken UID'yi temizle
        await prefs.remove('user_uid');
      }
      print('Login status saved to prefs: $isLoggedIn');
    } catch (e) {
      print('Error saving login status: $e');
    }
  }

  // SharedPreferences'dan oturum durumunu kontrol et
  Future<bool> _checkLoginStatusFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      print('Login status from prefs: $isLoggedIn');
      return isLoggedIn;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  // JSON'dan favori gezileri kullanıcının favorilerine senkronize eder
  Future<void> _syncFavorites(String userId) async {
    try {
      print('Syncing favorites for user: $userId');
      await _favoritesService.initializeFavoritesFromJson(userId);
    } catch (e) {
      print('Error syncing favorites: $e');
    }
  }
  
  // JSON'dan isFavorite=true olan gezilerin ID'lerini döndürür
  Future<List<String>> _getFavoriteTripsFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/data/travels.json');
      final List<dynamic> data = json.decode(response);
      
      List<String> favoriteIds = [];
      for (var travel in data) {
        if (travel['isFavorite'] == true) {
          favoriteIds.add(travel['id']);
        }
      }
      
      print('Found ${favoriteIds.length} favorite trips in JSON');
      return favoriteIds;
    } catch (e) {
      print('Error loading favorite trips from JSON: $e');
      return [];
    }
  }
  
  // Son giriş tarihini günceller
  Future<void> _updateLastLogin() async {
    try {
      if (_userModel != null && _user != null) {
        _userModel = _userModel!.copyWith(lastLogin: DateTime.now());
        await _authService.updateUserData(_userModel!);
        notifyListeners();
        print('Last login updated: ${_userModel!.lastLogin}');
      }
    } catch (e) {
      print('Error updating last login: $e');
    }
  }
}
