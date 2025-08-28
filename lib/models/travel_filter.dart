class TravelFilter {
  final String? country;
  final String? region;
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;

  TravelFilter({
    this.country,
    this.region,
    this.category,
    this.startDate,
    this.endDate,
  });

  factory TravelFilter.fromJson(Map<String, dynamic> json) {
    return TravelFilter(
      country: json['country'] as String?,
      region: json['region'] as String?,
      category: json['category'] as String?,
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'region': region,
      'category': category,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  TravelFilter copyWith({
    String? country,
    String? region,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TravelFilter(
      country: country ?? this.country,
      region: region ?? this.region,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  bool get isEmpty {
    return country == null &&
        region == null &&
        category == null &&
        startDate == null &&
        endDate == null;
  }

  TravelFilter clear() {
    return TravelFilter();
  }
}
