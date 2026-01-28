import '../data/property_db.dart';
import '../model/property.dart';

class PropertyRepository {
  final PropertyDb _db;

  PropertyRepository(this._db);

  Future<List<Property>> loadProperties() async {
    final items = await _db.getAll();
    if (items.isNotEmpty) return items;

    // Seed sample data on first run.
    final seed = <Property>[
      Property(
        title: 'Modern Family Home',
        city: 'Cityville',
        state: 'CA',
        price: 520000,
        imageUrl: 'https://picsum.photos/seed/home1/800/600',
        syncStatus: SyncStatus.cached,
        beds: 3,
        baths: 2.0,
        sqft: 1800,
        description:
        'Modern family home with spacious living areas and a private backyard.',
        address: '123 Elm Street, Cityville',
      ),
      Property(
        title: 'Charming Bungalow',
        city: 'Townsville',
        state: 'TX',
        price: 380000,
        imageUrl: 'https://picsum.photos/seed/home2/800/600',
        syncStatus: SyncStatus.synced,
        beds: 2,
        baths: 1.5,
        sqft: 1400,
        description:
        'Cozy bungalow with updated kitchen and a sunny front porch.',
        address: '456 Oak Avenue, Townsville',
      ),
      Property(
        title: 'Luxury Downtown Apartment',
        city: 'Metropolis',
        state: 'NY',
        price: 750000,
        imageUrl: 'https://picsum.photos/seed/home3/800/600',
        syncStatus: SyncStatus.syncing,
        beds: 2,
        baths: 2.5,
        sqft: 1200,
        description:
        'High‑rise apartment offering skyline views and premium amenities.',
        address: '789 Pine Street, Metropolis',
      ),
    ];

    for (final p in seed) {
      await _db.insert(p);
    }
    return _db.getAll();
  }

  Future<void> toggleFavorite(Property property) async {
    await _db.update(property.copyWith(isFavorite: !property.isFavorite));
  }

  Future<void> updateSyncStatus(Property property, SyncStatus status) async {
    await _db.update(property.copyWith(syncStatus: status));
  }

  Future<void> clearAll() => _db.deleteAll();
}