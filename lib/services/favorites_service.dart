import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/travel.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // JSON'dan favorileri yükle ve kullanıcıya ata
  Future<List<String>> initializeFavoritesFromJson(String userId) async {
    try {
      // JSON dosyasını oku
      final String jsonString = await rootBundle.loadString('assets/data/travels.json');
      final List<dynamic> travelsJson = json.decode(jsonString);
      
      // Favorileri filtrele
      final List<String> favoriteIds = [];
      for (var travelJson in travelsJson) {
        final travel = Travel.fromJson(travelJson);
        if (travel.isFavorite) {
          favoriteIds.add(travel.id);
        }
      }

      // Kullanıcının Firestore'daki favorilerini güncelle
      await _firestore.collection('users').doc(userId).update({
        'favoriteTrips': favoriteIds,
      });

      return favoriteIds;
    } catch (e) {
      print('Error initializing favorites: $e');
      return [];
    }
  }

  // Kullanıcının favorilerini getir
  Future<List<String>> getUserFavorites(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();
      
      if (data != null && data['favoriteTrips'] != null) {
        return List<String>.from(data['favoriteTrips']);
      }
      
      // Eğer favoriler yoksa JSON'dan yükle
      return await initializeFavoritesFromJson(userId);
    } catch (e) {
      print('Error getting user favorites: $e');
      return [];
    }
  }

  // Favori ekle/çıkar
  Future<bool> toggleFavorite(String userId, String travelId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      List<String> favorites = [];
      
      if (doc.exists && doc.data()?['favoriteTrips'] != null) {
        favorites = List<String>.from(doc.data()!['favoriteTrips']);
      }

      if (favorites.contains(travelId)) {
        favorites.remove(travelId);
      } else {
        favorites.add(travelId);
      }

      await _firestore.collection('users').doc(userId).update({
        'favoriteTrips': favorites,
      });

      return favorites.contains(travelId);
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }

  // JSON'dan tüm gezileri getir
  Future<List<Travel>> getAllTravels() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/travels.json');
      final List<dynamic> travelsJson = json.decode(jsonString);
      
      return travelsJson.map((json) => Travel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading travels: $e');
      return [];
    }
  }

  // Favori gezileri getir
  Future<List<Travel>> getFavoriteTravels(String userId) async {
    try {
      final favoriteIds = await getUserFavorites(userId);
      final allTravels = await getAllTravels();
      
      return allTravels.where((travel) => favoriteIds.contains(travel.id)).toList();
    } catch (e) {
      print('Error getting favorite travels: $e');
      return [];
    }
  }
}
