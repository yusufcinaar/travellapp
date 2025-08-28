class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final String? photoUrl;
  final List<String>? favoriteTrips;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.createdAt,
    this.lastLogin,
    this.photoUrl,
    this.favoriteTrips,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: json['lastLogin'] != null 
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      photoUrl: json['photoUrl'] as String?,
      favoriteTrips: json['favoriteTrips'] != null 
          ? List<String>.from(json['favoriteTrips'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'photoUrl': photoUrl,
      'favoriteTrips': favoriteTrips,
    };
  }

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? photoUrl,
    List<String>? favoriteTrips,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteTrips: favoriteTrips ?? this.favoriteTrips,
    );
  }
}
