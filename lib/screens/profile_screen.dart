import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/travel_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4285F4), // Google mavi arka plan
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
              ? 'Profil'
              : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                  ? 'Profile'
                  : 'Profil'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.userModel;
          
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Profil Fotoğrafı
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: user.photoUrl != null
                        ? Image.network(
                            user.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: const Color(0xFF4285F4),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: const Color(0xFF4285F4),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // İsim
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Bilgi Kartları
                _buildInfoCard(
                  context,
                  Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                      ? 'E-Mail'
                      : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                          ? 'Email'
                          : 'E-posta'),
                  user.email,
                ),
                const SizedBox(height: 16),
                
                _buildInfoCard(
                  context,
                  Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                      ? 'Konto erstellt'
                      : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                          ? 'Account Created'
                          : 'Hesap Oluşturulma'),
                  DateFormat('dd MMM yyyy', Provider.of<LocaleProvider>(context).locale.languageCode).format(user.createdAt),
                ),
                const SizedBox(height: 16),
                
                _buildInfoCard(
                  context,
                  Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                      ? 'Letzter Login'
                      : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                          ? 'Last Login'
                          : 'Son Giriş'),
                  user.lastLogin != null 
                      ? DateFormat('dd MMM yyyy HH:mm', Provider.of<LocaleProvider>(context).locale.languageCode).format(user.lastLogin!)
                      : (Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                          ? 'Nie angemeldet'
                          : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                              ? 'Never logged in'
                              : 'Hiç giriş yapılmamış')),
                ),
                const SizedBox(height: 16),
                
                // Favoriler Sayısı
                Consumer<TravelProvider>(
                  builder: (context, travelProvider, child) {
                    final favoritesCount = travelProvider.favoriteTravels.length;
                    return _buildInfoCard(
                      context,
                      Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                          ? 'Favoriten'
                          : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                              ? 'Favorites'
                              : 'Favoriler'),
                      '$favoritesCount ${Provider.of<LocaleProvider>(context).locale.languageCode == 'de' ? 'reisen' : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en' ? 'travels' : 'seyahat')}',
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Dil Seçimi
                _buildLanguageSelector(context),
                
                const Spacer(),
                
                // Çıkış Yap Butonu
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _signOut(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, 
                      foregroundColor: const Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                          ? 'Abmelden'
                          : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                              ? 'Sign Out'
                              : 'Çıkış Yap'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4285F4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4285F4),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF4285F4),
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }
  
  Widget _buildLanguageSelector(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                ? 'Anwendungssprache'
                : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                    ? 'App Language'
                    : 'Uygulama Dili'),
            style: const TextStyle(
              color: Color(0xFF4285F4),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: LocaleProvider.supportedLocales.map((locale) {
              final isSelected = localeProvider.locale.languageCode == locale.languageCode;
              
              return GestureDetector(
                onTap: () {
                  localeProvider.setLocale(locale);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFF4285F4) 
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF4285F4) : Colors.grey.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    localeProvider.getLocaleName(locale.languageCode),
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF4285F4),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
