import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/travel_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/travel_card.dart';
import '../widgets/travel_filter_widget.dart';
import '../models/travel_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TravelProvider>(context, listen: false).loadTravels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
              ? 'Reisen'
              : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                  ? 'Travels'
                  : 'Seyahatler'),
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
        ),
        backgroundColor: const Color(0xFF4285F4),
        elevation: 0,
        actions: [
          // Görünüm değiştirme butonu
          Consumer<TravelProvider>(
            builder: (context, travelProvider, child) {
              return IconButton(
                onPressed: travelProvider.toggleViewMode,
                icon: Icon(
                  travelProvider.isGridView ? Icons.view_list : Icons.grid_view,
                  color: Colors.white,
                ),
                tooltip: travelProvider.isGridView 
                    ? (Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                        ? 'Listenansicht'
                        : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                            ? 'List View'
                            : 'Liste Görünümü'))
                    : (Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                        ? 'Rasteransicht'
                        : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                            ? 'Grid View'
                            : 'Izgara Görünümü')),
              );
            },
          ),
          // Filtre butonu
          IconButton(
            onPressed: () => _showFilterDialog(context),
            icon: const Icon(Icons.filter_list, color: Colors.white),
            tooltip: Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                ? 'Filter'
                : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                    ? 'Filter'
                    : 'Filtrele'),
          ),
        ],
      ),
      body: Consumer<TravelProvider>(
        builder: (context, travelProvider, child) {
          if (travelProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4285F4)),
              ),
            );
          }

          if (travelProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: const Color(0xFF4285F4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                        ? 'Fehler'
                        : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                            ? 'Error'
                            : 'Hata'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    travelProvider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      travelProvider.clearError();
                      travelProvider.loadTravels();
                    },
                    child: Text(
                      Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                          ? 'Erneut versuchen'
                          : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                              ? 'Retry'
                              : 'Tekrar Dene'),
                    ),
                  ),
                ],
              ),
            );
          }

          final travels = travelProvider.filteredTravels;

          if (travels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.travel_explore,
                    size: 64,
                    color: const Color(0xFF4285F4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                        ? 'Keine Reisen gefunden'
                        : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                            ? 'No travels found'
                            : 'Seyahat bulunamadı'),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (!travelProvider.filter.isEmpty)
                    TextButton(
                      onPressed: travelProvider.clearFilter,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF4285F4),
                      ),
                      child: Text(
                        Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                            ? 'Filter zurücksetzen'
                            : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                ? 'Clear filters'
                                : 'Filtreleri temizle'),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: travelProvider.loadTravels,
            child: Column(
              children: [
                // Show active filters
                if (!travelProvider.filter.isEmpty)
                  _buildActiveFilters(travelProvider),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    // Google Material Design'a uygun içerik
                    child: travelProvider.isGridView
                        ? _buildGridView(travels)
                        : _buildListView(travels),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(List travels) {
    return ListView.builder(
      itemCount: travels.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TravelCard(
            travel: travels[index],
            isGridView: false,
          ),
        );
      },
    );
  }

  Widget _buildGridView(List travels) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: travels.length,
      itemBuilder: (context, index) {
        return TravelCard(
          travel: travels[index],
          isGridView: true,
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return TravelFilterWidget(
            scrollController: scrollController,
            onFilterChanged: () {
              setState(() {}); // Refresh UI when filters change
            },
          );
        },
      ),
    );
  }
  
  Widget _buildActiveFilters(TravelProvider provider) {
    final filter = provider.filter;
    final List<Widget> filterChips = [];
    
    if (filter.country != null) {
      filterChips.add(_buildFilterChip(
        label: '${Provider.of<LocaleProvider>(context).locale.languageCode == 'de' ? 'Land' : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en' ? 'Country' : 'Ülke')}: ${filter.country}',
        onTap: () => _removeFilter('country'),
      ));
    }
    
    if (filter.region != null) {
      filterChips.add(_buildFilterChip(
        label: '${Provider.of<LocaleProvider>(context).locale.languageCode == 'de' ? 'Region' : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en' ? 'Region' : 'Bölge')}: ${filter.region}',
        onTap: () => _removeFilter('region'),
      ));
    }
    
    if (filter.category != null) {
      filterChips.add(_buildFilterChip(
        label: '${Provider.of<LocaleProvider>(context).locale.languageCode == 'de' ? 'Kategorie' : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en' ? 'Category' : 'Kategori')}: ${filter.category}',
        onTap: () => _removeFilter('category'),
      ));
    }
    
    if (filter.startDate != null && filter.endDate != null) {
      filterChips.add(_buildFilterChip(
        label: '${Provider.of<LocaleProvider>(context).locale.languageCode == 'de' ? 'Datumsbereich' : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en' ? 'Date Range' : 'Tarih Aralığı')}: ${DateFormat('dd/MM/yyyy').format(filter.startDate!)} - ${DateFormat('dd/MM/yyyy').format(filter.endDate!)}',
        onTap: () => _removeFilter('dates'),
      ));
    } else if (filter.startDate != null) {
      filterChips.add(_buildFilterChip(
        label: '${Provider.of<LocaleProvider>(context).locale.languageCode == 'de' ? 'Startdatum' : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en' ? 'Start Date' : 'Başlangıç Tarihi')}: ${DateFormat('dd/MM/yyyy').format(filter.startDate!)}',
        onTap: () => _removeFilter('startDate'),
      ));
    } else if (filter.endDate != null) {
      filterChips.add(_buildFilterChip(
        label: '${Provider.of<LocaleProvider>(context).locale.languageCode == 'de' ? 'Enddatum' : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en' ? 'End Date' : 'Bitiş Tarihi')}: ${DateFormat('dd/MM/yyyy').format(filter.endDate!)}',
        onTap: () => _removeFilter('endDate'),
      ));
    }
    
    // If no filters are active, return an empty container
    if (filterChips.isEmpty) {
      return Container();
    }
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...filterChips,
          _buildFilterChip(
            label: Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                ? 'Filter löschen'
                : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                    ? 'Clear Filters'
                    : 'Filtreleri Temizle'),
            onTap: () {
              Provider.of<TravelProvider>(context, listen: false).clearFilter();
              setState(() {});
            },
            backgroundColor: const Color(0xFFF5B7B1),
            labelColor: const Color(0xFFE74C3C),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip({
    required String label, 
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? labelColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF4285F4).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: labelColor ?? const Color(0xFF4285F4),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.close,
              size: 14,
              color: labelColor ?? const Color(0xFF4285F4),
            ),
          ],
        ),
      ),
    );
  }
  
  void _removeFilter(String filterType) {
    final provider = Provider.of<TravelProvider>(context, listen: false);
    final currentFilter = provider.filter;
    
    switch (filterType) {
      case 'country':
        provider.updateFilter(TravelFilter(
          region: currentFilter.region,
          category: currentFilter.category,
          startDate: currentFilter.startDate,
          endDate: currentFilter.endDate,
        ));
        break;
      case 'region':
        provider.updateFilter(TravelFilter(
          country: currentFilter.country,
          category: currentFilter.category,
          startDate: currentFilter.startDate,
          endDate: currentFilter.endDate,
        ));
        break;
      case 'category':
        provider.updateFilter(TravelFilter(
          country: currentFilter.country,
          region: currentFilter.region,
          startDate: currentFilter.startDate,
          endDate: currentFilter.endDate,
        ));
        break;
      case 'dates':
        provider.updateFilter(TravelFilter(
          country: currentFilter.country,
          region: currentFilter.region,
          category: currentFilter.category,
        ));
        break;
      case 'startDate':
        provider.updateFilter(TravelFilter(
          country: currentFilter.country,
          region: currentFilter.region,
          category: currentFilter.category,
          endDate: currentFilter.endDate,
        ));
        break;
      case 'endDate':
        provider.updateFilter(TravelFilter(
          country: currentFilter.country,
          region: currentFilter.region,
          category: currentFilter.category,
          startDate: currentFilter.startDate,
        ));
        break;
    }
    
    setState(() {});
  }
}
