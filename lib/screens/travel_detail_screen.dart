import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../models/travel.dart';
import '../providers/travel_provider.dart';
import '../providers/locale_provider.dart';

class TravelDetailScreen extends StatelessWidget {
  final String travelId;

  const TravelDetailScreen({super.key, required this.travelId});

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'kültür':
      case 'culture':
        return const Color(0xFF6B73FF);
      case 'doğa':
      case 'nature':
        return const Color(0xFF4CAF50);
      case 'festival':
        return const Color(0xFFFF6B6B);
      case 'macera':
      case 'adventure':
        return const Color(0xFFFF9800);
      case 'yemek':
      case 'food':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF42A5F5);
    }
  }

  void _toggleFavorite(BuildContext context, Travel travel) {
    Provider.of<TravelProvider>(context, listen: false).toggleFavorite(travel.id);
  }
  
  Widget _buildAppBar(BuildContext context, Travel travel) {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      backgroundColor: _getColorForCategory(travel.category),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          travel.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 5,
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getColorForCategory(travel.category),
                _getColorForCategory(travel.category).withOpacity(0.7),
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Placeholder for travel image
              const Icon(
                Icons.travel_explore,
                size: 60,
                color: Colors.white30,
              ),
              // Gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            // Share functionality would go here
          },
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, Travel travel, String locale) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context, travel, locale),
          const SizedBox(height: 24),
          _buildSectionTitle(context, S.of(context).description),
          const SizedBox(height: 8),
          Text(
            travel.description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, S.of(context).locationInfo),
          const SizedBox(height: 8),
          _buildLocationInfo(context, travel),
          const SizedBox(height: 24),
          _buildSectionTitle(context, S.of(context).dateInfo),
          const SizedBox(height: 8),
          _buildDateInfo(context, travel, locale),
          const SizedBox(height: 80), // Extra space for FAB
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, Travel travel, String locale) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getColorForCategory(travel.category).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    travel.category,
                    style: TextStyle(
                      color: _getColorForCategory(travel.category),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${DateFormat('dd MMM', locale).format(travel.startDate)} - ${DateFormat('dd MMM yyyy', locale).format(travel.endDate)}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${travel.region}, ${travel.country}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildLocationInfo(BuildContext context, Travel travel) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF4285F4)),
                const SizedBox(width: 8),
                Text(
                  travel.country,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.map, color: Color(0xFF4285F4)),
                const SizedBox(width: 8),
                Text(
                  travel.region,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(BuildContext context, Travel travel, String locale) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF4285F4)),
                const SizedBox(width: 8),
                Text(
                  '${S.of(context).startDate}: ${DateFormat('d MMMM yyyy', locale).format(travel.startDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF4285F4)),
                const SizedBox(width: 8),
                Text(
                  '${S.of(context).endDate}: ${DateFormat('d MMMM yyyy', locale).format(travel.endDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.timelapse, color: Color(0xFF4285F4)),
                const SizedBox(width: 8),
                Text(
                  '${S.of(context).duration}: ${travel.endDate.difference(travel.startDate).inDays + 1} ${S.of(context).days}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Consumer ile hem TravelProvider hem de LocaleProvider'ı dinliyoruz
    return Consumer2<TravelProvider, LocaleProvider>(
      builder: (context, travelProvider, localeProvider, child) {
        final travel = travelProvider.getTravelById(travelId);
        final locale = localeProvider.locale.languageCode;
        
        if (travel == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).error),
              backgroundColor: const Color(0xFF4285F4),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Text(S.of(context).noTripsFound),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, travel),
              SliverToBoxAdapter(
                child: _buildContent(context, travel, locale),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF4285F4),
            onPressed: () => _toggleFavorite(context, travel),
            child: Icon(
              travel.isFavorite ? Icons.star : Icons.star_border,
              color: travel.isFavorite ? Colors.amber : Colors.white,
            ),
          ),
        );
      },
    );
  }
}
