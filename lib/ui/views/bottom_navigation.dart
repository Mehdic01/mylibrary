import 'package:flutter/material.dart';
import 'package:mylibrary/ui/views/ana_sayfa.dart';
import 'package:mylibrary/ui/views/database.dart';
import 'package:mylibrary/ui/views/favori_sayfa.dart';
import 'package:mylibrary/ui/views/profil_sayfa.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 1; // Başlangıçta seçili olan index (Ana Sayfa)

  final List<Widget> _pages = [
    // Ana Sayfa Widget'ı
    //const DatabasePreviewPage(), // Arama Sayfası Widget'ı
    const FavoriSayfa(),
    const Anasayfa(),// Favoriler Sayfası Widget'ı
    const ProfilSayfa(), // Profil Sayfası Widget'ı
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Seçilen sayfayı göster
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        backgroundColor: Colors.grey.shade900,
        //showSelectedLabels: false,
        unselectedFontSize: 10,
        selectedFontSize: 12,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.lightGreen.shade600, // Seçilen öğenin rengi
        unselectedItemColor: Colors.grey, // Seçilmeyen öğelerin rengi
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Seçilen öğeyi değiştir
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoriler",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Kitaplar",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
