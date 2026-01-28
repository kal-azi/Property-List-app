enum SyncStatus { synced, syncing, queued, failed, cached }

class Property {
  final int? id;
  final String title;
  final String city;
  final String state;
  final double price;
  final String imageUrl;
  final bool isFavorite;
  final SyncStatus syncStatus;
  final int beds;
  final double baths;
  final int sqft;
  final String description;
  final String address;

  const Property({
    this.id,
    required this.title,
    required this.city,
    required this.state,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    this.syncStatus = SyncStatus.synced,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.description,
    required this.address,
  });

  Property copyWith({
    int? id,
    String? title,
    String? city,
    String? state,
    double? price,
    String? imageUrl,
    bool? isFavorite,
    SyncStatus? syncStatus,
    int? beds,
    double? baths,
    int? sqft,
    String? description,
    String? address,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      city: city ?? this.city,
      state: state ?? this.state,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      syncStatus: syncStatus ?? this.syncStatus,
      beds: beds ?? this.beds,
      baths: baths ?? this.baths,
      sqft: sqft ?? this.sqft,
      description: description ?? this.description,
      address: address ?? this.address,
    );
  }

  static SyncStatus _statusFromDb(int value) => SyncStatus.values[value];
  static int _statusToDb(SyncStatus status) => status.index;

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] as int?,
      title: map['title'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      isFavorite: (map['isFavorite'] as int) == 1,
      syncStatus: _statusFromDb(map['syncStatus'] as int),
      beds: map['beds'] as int,
      baths: (map['baths'] as num).toDouble(),
      sqft: map['sqft'] as int,
      description: map['description'] as String,
      address: map['address'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'city': city,
      'state': state,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite ? 1 : 0,
      'syncStatus': _statusToDb(syncStatus),
      'beds': beds,
      'baths': baths,
      'sqft': sqft,
      'description': description,
      'address': address,
    };
  }
}