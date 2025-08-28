import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print('AuthWrapper - isLoading: ${authProvider.isLoading}, isAuthenticated: ${authProvider.isAuthenticated}');
        
        // Kayıt işlemi sırasında yükleme ekranını gösterme
        // Sadece gerçek giriş işlemlerinde göster
        if (authProvider.isLoading && authProvider.isAuthenticated) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4285F4)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Giriş yapılıyor...",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Kimlik doğrulanmış kullanıcıları MainScreen'e, diğerlerini Giriş Ekranına yönlendir
        if (authProvider.isAuthenticated) {
          print('User is authenticated, showing MainScreen');
          return const MainScreen();
        } else {
          print('User is not authenticated, showing LoginScreen');
          return const LoginScreen();
        }
      },
    );
  }
}
