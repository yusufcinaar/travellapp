import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/travel.dart';
import '../models/travel_filter.dart';
import '../utils/logger.dart';
import '../services/travel_service.dart';

class TravelProvider with ChangeNotifier {
  final TravelService _travelService = TravelService();
  
  List<Travel> _allTravels = [];
  List<Travel> _filteredTravels = [];
  TravelFilter _filter = TravelFilter();
  bool _isLoading = false;
  String? _error;
  bool _isGridView = false;

  List<Travel> get allTravels => _allTravels;
  List<Travel> get filteredTravels => _filteredTravels;
  List<Travel> get favoriteTravels => _allTravels.where((travel) => travel.isFavorite).toList();
  TravelFilter get filter => _filter;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isGridView => _isGridView;

  List<String> get countries => _travelService.getUniqueCountries(_allTravels);
  List<String> get categories => _travelService.getUniqueCategories(_allTravels);
  
  List<String> getRegionsForCountry(String? country) {
    return _travelService.getUniqueRegions(_allTravels, country);
  }

  TravelProvider() {
    _loadPreferences();
    loadTravels();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isGridView = prefs.getBool('isGridView') ?? false;
      
      final filterJson = prefs.getString('travelFilter');
      if (filterJson != null) {
        try {
          final Map<String, dynamic> filterMap = json.decode(filterJson);
          _filter = TravelFilter.fromJson(filterMap);
          logger.i('Filter preferences loaded successfully');
        } catch (e) {
          logger.e('Error parsing filter preferences: $e');
        }
      }
      
      notifyListeners();
    } catch (e) {
      logger.e('Error loading preferences: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isGridView', _isGridView);
      
      // Save filter preferences
      if (!_filter.isEmpty) {
        final filterJson = json.encode(_filter.toJson());
        await prefs.setString('travelFilter', filterJson);
        logger.i('Filter preferences saved successfully');
      } else {
        // If filter is empty, remove saved preferences
        await prefs.remove('travelFilter');
      }
    } catch (e) {
      logger.e('Error saving preferences: $e');
    }
  }

  Future<void> loadTravels() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _allTravels = await _travelService.loadTravels();
      _applyFilter();
      
      _isLoading = false;
      notifyListeners();
      logger.i('Travel data loaded: ${_allTravels.length} items');
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      logger.e('Error loading travels: $e');
      notifyListeners();
    }
  }

  void _applyFilter() {
    _filteredTravels = _travelService.filterTravels(_allTravels, _filter);
  }

  void updateFilter(TravelFilter newFilter) {
    _filter = newFilter;
    _applyFilter();
    _savePreferences();
    notifyListeners();
  }

  void clearFilter() {
    _filter = TravelFilter();
    _applyFilter();
    _savePreferences();
    notifyListeners();
  }

  Future<void> toggleFavorite(String travelId) async {
    try {
      await _travelService.toggleFavorite(travelId);
      
      // Local state güncelle
      final travelIndex = _allTravels.indexWhere((travel) => travel.id == travelId);
      if (travelIndex != -1) {
        _allTravels[travelIndex].isFavorite = !_allTravels[travelIndex].isFavorite;
        _applyFilter();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void toggleViewMode() {
    _isGridView = !_isGridView;
    _savePreferences();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Travel? getTravelById(String id) {
    try {
      return _allTravels.firstWhere((travel) => travel.id == id);
    } catch (e) {
      return null;
    }
  }
}
