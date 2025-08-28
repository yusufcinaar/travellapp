import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/travel.dart';
import '../providers/travel_provider.dart';
import '../providers/locale_provider.dart';
import '../screens/travel_detail_screen.dart';

class TravelCard extends StatelessWidget {
  final Travel travel;
  final bool isGridView;

  const TravelCard({super.key, required this.travel, this.isGridView = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TravelDetailScreen(travelId: travel.id),
        ),
      ),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withValues(red: 0, green: 0, blue: 0, alpha: 26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getCardColor(travel.category),
                _getCardColor(travel.category).withOpacity(0.8),
              ],
            ),
          ),
          child: isGridView ? _buildGridCard(context) : _buildListCard(context),
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      travel.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${travel.region}, ${travel.country}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              _buildFavoriteButton(context),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  travel.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${DateFormat('dd MMM').format(travel.startDate)} - ${DateFormat('dd MMM yyyy').format(travel.endDate)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Text(
            travel.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _toggleFavorite(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4285F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 1,
                  ),
                  child: Text(
                    travel.isFavorite 
                        ? (Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                            ? 'Aus Favoriten entfernen'
                            : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                ? 'Remove from Favorites'
                                : 'Favorilerden Çıkar'))
                        : (Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                            ? 'Zu Favoriten hinzufügen'
                            : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                ? 'Add to Favorites'
                                : 'Favorilere Ekle')),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 1,
                  ),
                  child: Text(
                    Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                        ? 'Teilen'
                        : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                            ? 'Share'
                            : 'Paylaş'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  travel.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildFavoriteButton(context),
            ],
          ),
          const SizedBox(height: 8),
          
          Text(
            travel.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          
          Text(
            '${travel.region}, ${travel.country}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              travel.category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          
          Text(
            '${DateFormat('dd MMM').format(travel.startDate)} - ${DateFormat('dd MMM').format(travel.endDate)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _toggleFavorite(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          travel.isFavorite ? Icons.star : Icons.star_border,
          color: travel.isFavorite ? Colors.amber : Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _toggleFavorite(BuildContext context) {
    Provider.of<TravelProvider>(context, listen: false)
        .toggleFavorite(travel.id);
  }

  Color _getCardColor(String category) {
    switch (category.toLowerCase()) {
      case 'kültür':
        return const Color(0xFF6B73FF);
      case 'doğa':
        return const Color(0xFF4CAF50);
      case 'festival':
        return const Color(0xFFFF6B6B);
      case 'macera':
        return const Color(0xFFFF9800);
      case 'yemek':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF42A5F5);
    }
  }
}
