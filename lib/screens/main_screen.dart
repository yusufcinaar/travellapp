import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';
import '../providers/locale_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  // Uygulamadaki ekranlar
  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack kullanarak sayfa durumunu koruyalım
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4285F4),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                ? 'Reisen'
                : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                    ? 'Travels'
                    : 'Seyahatler'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            label: Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                ? 'Favoriten'
                : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                    ? 'Favorites'
                    : 'Favoriler'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                ? 'Profil'
                : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                    ? 'Profile'
                    : 'Profil'),
          ),
        ],
      ),
    );
  }
}
