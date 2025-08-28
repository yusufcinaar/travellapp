import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/travel.dart';
import '../models/travel_filter.dart';

class TravelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Travel>> loadTravels() async {
    try {
      // JSON dosyasından seyahat verilerini yükle
      final String response = await rootBundle.loadString('assets/data/travels.json');
      final List<dynamic> data = json.decode(response);
      
      List<Travel> travels = data.map((json) => Travel.fromJson(json)).toList();
      
      // Favorileri yükle - önce JSON'dan gelen isFavorite değerlerini koru
      if (_auth.currentUser != null) {
        try {
          final userFavorites = await getFavorites();
          for (var travel in travels) {
            // JSON'da isFavorite=true olan veya kullanıcının favorilerine eklediği geziler
            travel.isFavorite = travel.isFavorite || userFavorites.contains(travel.id);
          }
        } catch (e) {
          // Favori yüklenirken hata olursa JSON'daki isFavorite değerleri korunur
          print('Error loading user favorites: $e');
        }
      }
      
      print('Travel data loaded: ${travels.length} items');
      return travels;
    } catch (e) {
      print('Load Travels Error: $e');
      return [];
    }
  }

  Future<List<String>> getFavorites() async {
    try {
      if (_auth.currentUser == null) return [];

      final doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favorites')
          .doc('travels')
          .get();

      if (doc.exists) {
        final data = doc.data();
        final favorites = List<String>.from(data?['travelIds'] ?? []);
        return favorites;
      }
      return [];
    } catch (e) {
      print('Get Favorites Error from Firestore: $e');
      return [];
    }
  }

  Future<void> toggleFavorite(String travelId) async {
    try {
      if (_auth.currentUser == null) return;

      // Mevcut favorileri al
      List<String> favorites = await getFavorites();
      
      // Favoriyi ekle veya çıkar
      if (favorites.contains(travelId)) {
        favorites.remove(travelId);
      } else {
        favorites.add(travelId);
      }
      
      // Firestore'u güncelle
      final favoritesRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favorites')
          .doc('travels');
          
      await favoritesRef.set({
        'travelIds': favorites,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      print('Favorites updated in Firestore: ${favorites.length} items');
    } catch (e) {
      print('Toggle Favorite Error: $e');
    }
  }

  List<Travel> filterTravels(List<Travel> travels, TravelFilter filter) {
    if (filter.isEmpty) return travels;

    List<Travel> filteredTravels = travels.where((travel) {
      bool matchesCountry = filter.country == null || travel.country == filter.country;
      bool matchesRegion = filter.region == null || travel.region == filter.region;
      bool matchesCategory = filter.category == null || travel.category == filter.category;
      
      bool matchesDateRange = true;
      if (filter.startDate != null && filter.endDate != null) {
        matchesDateRange = travel.startDate.isAfter(filter.startDate!) &&
                          travel.endDate.isBefore(filter.endDate!);
      }

      return matchesCountry && matchesRegion && matchesCategory && matchesDateRange;
    }).toList();
    
    print('Travel data filtered: ${filteredTravels.length}/${travels.length} items');
    return filteredTravels;
  }

  List<String> getUniqueCountries(List<Travel> travels) {
    return travels.map((travel) => travel.country).toSet().toList()..sort();
  }

  List<String> getUniqueRegions(List<Travel> travels, String? country) {
    if (country == null) {
      return travels.map((travel) => travel.region).toSet().toList()..sort();
    }
    return travels
        .where((travel) => travel.country == country)
        .map((travel) => travel.region)
        .toSet()
        .toList()
      ..sort();
  }

  List<String> getUniqueCategories(List<Travel> travels) {
    return travels.map((travel) => travel.category).toSet().toList()..sort();
  }
}
