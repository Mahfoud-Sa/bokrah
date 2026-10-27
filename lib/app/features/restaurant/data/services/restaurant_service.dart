import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurant_entity.dart';

class RestaurantService {
  static const String _storageKey = 'restaurant_profile_info';

  /// Fetches saved restaurant information or seeds default if empty
  Future<RestaurantEntity> getRestaurantInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      final defaultInfo = RestaurantEntity.defaultRestaurant();
      await prefs.setString(_storageKey, json.encode(defaultInfo.toMap()));
      return defaultInfo;
    }

    try {
      final Map<String, dynamic> data = json.decode(jsonString);
      return RestaurantEntity.fromMap(data);
    } catch (_) {
      final fallback = RestaurantEntity.defaultRestaurant();
      await prefs.setString(_storageKey, json.encode(fallback.toMap()));
      return fallback;
    }
  }

  /// Updates and persists the restaurant profile
  Future<bool> updateRestaurantInfo(RestaurantEntity info) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final updated = info.copyWith(
        updatedAt: DateTime.now().toIso8601String(),
      );
      return await prefs.setString(
        _storageKey,
        json.encode(updated.toMap()),
      );
    } catch (_) {
      return false;
    }
  }

  /// Resets restaurant information to default preset
  Future<RestaurantEntity> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    final defaultInfo = RestaurantEntity.defaultRestaurant();
    await prefs.setString(_storageKey, json.encode(defaultInfo.toMap()));
    return defaultInfo;
  }
}
