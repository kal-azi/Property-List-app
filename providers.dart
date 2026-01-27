import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/property_db.dart';
import 'model/property.dart';
import 'repositories/property_repository.dart';

/// Global app settings.
class Settings {
  final bool darkMode;
  final bool offlineMode;
  final bool isOnline;

  const Settings({
    required this.darkMode,
    required this.offlineMode,
    required this.isOnline,
  });

  Settings copyWith({bool? darkMode, bool? offlineMode, bool? isOnline}) {
    return Settings(
      darkMode: darkMode ?? this.darkMode,
      offlineMode: offlineMode ?? this.offlineMode,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

final propertyDbProvider = Provider<PropertyDb>((ref) => PropertyDb());

final propertyRepositoryProvider = Provider<PropertyRepository>(
      (ref) => PropertyRepository(ref.watch(propertyDbProvider)),
);

final settingsProvider =
StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier()
      : super(const Settings(
    darkMode: false,
    offlineMode: false,
    isOnline: true,
  ));

  void toggleDarkMode() =>
      state = state.copyWith(darkMode: !state.darkMode);

  void toggleOfflineMode() =>
      state = state.copyWith(offlineMode: !state.offlineMode);

  void toggleOnlineStatus() =>
      state = state.copyWith(isOnline: !state.isOnline);
}

/// Offline indicator for banner text / icon.
final offlineIndicatorProvider = Provider<bool>((ref) {
  final s = ref.watch(settingsProvider);
  return !s.isOnline || s.offlineMode;
});

/// Property list state.
final propertyListProvider =
AsyncNotifierProvider<PropertyListNotifier, List<Property>>(
    PropertyListNotifier.new);

class PropertyListNotifier extends AsyncNotifier<List<Property>> {
  @override
  Future<List<Property>> build() async {
    final repo = ref.read(propertyRepositoryProvider);
    return repo.loadProperties();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(propertyRepositoryProvider);
      return repo.loadProperties();
    });
  }

  Future<void> toggleFavorite(Property property) async {
    final repo = ref.read(propertyRepositoryProvider);
    await repo.toggleFavorite(property);
    await refresh();
  }

  Future<void> cycleSyncStatus(Property property) async {
    final statuses = SyncStatus.values;
    final nextIndex = (property.syncStatus.index + 1) % statuses.length;
    final repo = ref.read(propertyRepositoryProvider);
    await repo.updateSyncStatus(property, statuses[nextIndex]);
    await refresh();
  }
}

final favoritesProvider = Provider<List<Property>>((ref) {
  final list = ref.watch(propertyListProvider).value ?? const <Property>[];
  return list.where((p) => p.isFavorite).toList();
});