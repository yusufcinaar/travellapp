import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import '../providers/travel_provider.dart';
import '../providers/locale_provider.dart';
import '../models/travel_filter.dart';

class TravelFilterWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Function onFilterChanged;

  const TravelFilterWidget({super.key, required this.scrollController, required this.onFilterChanged});

  @override
  State<TravelFilterWidget> createState() => _TravelFilterWidgetState();
}

class _TravelFilterWidgetState extends State<TravelFilterWidget> {
  String? selectedCountry;
  String? selectedRegion;
  String? selectedCategory;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    final travelProvider = Provider.of<TravelProvider>(context, listen: false);
    final currentFilter = travelProvider.filter;
    
    selectedCountry = currentFilter.country;
    selectedRegion = currentFilter.region;
    selectedCategory = currentFilter.category;
    startDate = currentFilter.startDate;
    endDate = currentFilter.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Başlık
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                      ? 'Filter'
                      : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                          ? 'Filter'
                          : 'Filtrele'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                        ? 'Löschen'
                        : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                            ? 'Clear'
                            : 'Temizle'),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Consumer<TravelProvider>(
                  builder: (context, travelProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ülke Seçimi
                        _buildSectionTitle(
                          Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                              ? 'Alle Länder'
                              : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                  ? 'All Countries'
                                  : 'Tüm Ülkeler'),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdown<String>(
                          value: selectedCountry,
                          items: [
                            Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                ? 'Alle Länder'
                                : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                    ? 'All Countries'
                                    : 'Tüm Ülkeler'),
                            ...travelProvider.countries
                          ],
                          onChanged: (value) {
                            setState(() {
                              final allCountriesText = Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                  ? 'Alle Länder'
                                  : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                      ? 'All Countries'
                                      : 'Tüm Ülkeler');
                              selectedCountry = value == allCountriesText ? null : value;
                              selectedRegion = null; // Reset region when country changes
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Bölge Seçimi
                        _buildSectionTitle(
                          Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                              ? 'Alle Regionen'
                              : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                  ? 'All Regions'
                                  : 'Tüm Bölgeler'),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdown<String>(
                          value: selectedRegion,
                          items: [
                            Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                ? 'Alle Regionen'
                                : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                    ? 'All Regions'
                                    : 'Tüm Bölgeler'),
                            ...travelProvider.getRegionsForCountry(selectedCountry)
                          ],
                          onChanged: (value) {
                            setState(() {
                              final allRegionsText = Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                  ? 'Alle Regionen'
                                  : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                      ? 'All Regions'
                                      : 'Tüm Bölgeler');
                              selectedRegion = value == allRegionsText ? null : value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Kategori Seçimi
                        _buildSectionTitle(
                          Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                              ? 'Alle Kategorien'
                              : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                  ? 'All Categories'
                                  : 'Tüm Kategoriler'),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdown<String>(
                          value: selectedCategory,
                          items: [
                            Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                ? 'Alle Kategorien'
                                : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                    ? 'All Categories'
                                    : 'Tüm Kategoriler'),
                            ...travelProvider.categories
                          ],
                          onChanged: (value) {
                            setState(() {
                              final allCategoriesText = Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                  ? 'Alle Kategorien'
                                  : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                      ? 'All Categories'
                                      : 'Tüm Kategoriler');
                              selectedCategory = value == allCategoriesText ? null : value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Tarih Aralığı
                        _buildSectionTitle(
                          Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                              ? 'Datumsbereich'
                              : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                  ? 'Date Range'
                                  : 'Tarih Aralığı'),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateButton(
                                label: Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                    ? 'Startdatum'
                                    : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                        ? 'Start Date'
                                        : 'Başlangıç Tarihi'),
                                date: startDate,
                                onTap: () => _selectStartDate(context),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDateButton(
                                label: Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                    ? 'Enddatum'
                                    : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                        ? 'End Date'
                                        : 'Bitiş Tarihi'),
                                date: endDate,
                                onTap: () => _selectEndDate(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Uygula Butonu
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _applyFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                  ? 'Filter anwenden'
                                  : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                      ? 'Apply Filters'
                                      : 'Filtreleri Uygula'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDropdown<T>(
      {required T? value, required List<T> items, required ValueChanged<T?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'Seçiniz',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectStartDate(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2025, 1, 1),
      maxTime: DateTime(2030, 12, 31),
      currentTime: startDate ?? DateTime.now(),
      locale: LocaleType.tr,
      onConfirm: (date) {
        setState(() {
          startDate = date;
        });
      },
    );
  }

  void _selectEndDate(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: startDate ?? DateTime(2025, 1, 1),
      maxTime: DateTime(2030, 12, 31),
      currentTime: endDate ?? DateTime.now(),
      locale: LocaleType.tr,
      onConfirm: (date) {
        setState(() {
          endDate = date;
        });
      },
    );
  }

  void _applyFilters() {
    final filter = TravelFilter(
      country: selectedCountry,
      region: selectedRegion,
      category: selectedCategory,
      startDate: startDate,
      endDate: endDate,
    );

    Provider.of<TravelProvider>(context, listen: false).updateFilter(filter);
    widget.onFilterChanged();
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      selectedCountry = null;
      selectedRegion = null;
      selectedCategory = null;
      startDate = null;
      endDate = null;
    });
    
    // Apply clear filters immediately
    final provider = Provider.of<TravelProvider>(context, listen: false);
    provider.clearFilter();
    widget.onFilterChanged();
    Navigator.pop(context);
  }
}
