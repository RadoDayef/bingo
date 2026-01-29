/// Serialization and data conversion utility for the Bingo package
///
/// This internal converter handles object serialization, key stringification,
/// and data cleaning to ensure compatibility with JSON and database storage.
/// It supports custom objects with toJson() or toMap() methods.
///
/// **Note:** This is an internal utility class and should not be used
/// directly by external packages. Use the public Bingo API instead.
///
/// Example:
/// ```dart
/// // Internal use - processed automatically by Bingo operations
/// final serialized = Converter.serialize(customObject);
/// final cleaned = Converter.clean(serialized);
/// ```
library;

import 'dart:convert';

/// Internal data converter for Bingo serialization operations
///
/// This class provides static methods for converting objects to
/// JSON-compatible formats and ensuring data purity for storage.
///
/// **Internal use only.** This class is used internally by Bingo
/// components and should not be called directly from external code.
class Converter {
  Converter._();

  /// Ensures all Map keys are Strings for Sembast/JSON compatibility
  ///
  /// Recursively converts all map keys to strings, as database systems
  /// typically require string keys. Handles nested maps automatically.
  ///
  /// **Internal use only.** Used internally by Bingo storage operations.
  ///
  /// Example:
  /// ```dart
  /// final map = {1: 'value', 'key': {2: 'nested'}};
  /// final stringified = Converter.stringifyKeys(map);
  /// // Returns: {'1': 'value', 'key': {'2': 'nested'}}
  /// ```
  static Map<String, dynamic> stringifyKeys(Map map) {
    return map.map((key, value) {
      if (value is Map) return MapEntry(key.toString(), stringifyKeys(value));
      return MapEntry(key.toString(), value);
    });
  }

  /// Extracts Map from an Object using toJson or toMap
  ///
  /// Attempts to serialize objects by trying these methods in order:
  /// 1. If already a Map, returns stringified version
  /// 2. Calls toJson() method if available
  /// 3. Calls toMap() method if available
  /// 4. Throws exception if no serialization method found
  ///
  /// **Internal use only.** Used internally by Bingo storage operations.
  ///
  /// Example:
  /// ```dart
  /// final user = User(name: 'John', age: 30);
  /// final serialized = Converter.serialize(user);
  /// // Returns: {'name': 'John', 'age': 30}
  /// ```
  static Map<String, dynamic> serialize(dynamic value) {
    try {
      if (value is Map) return stringifyKeys(value);

      dynamic rawData;
      try {
        rawData = (value as dynamic).toJson();
      } catch (_) {
        try {
          rawData = (value as dynamic).toMap();
        } catch (_) {
          throw "No Serializer found for ${value.runtimeType}";
        }
      }
      return stringifyKeys(rawData as Map);
    } catch (e) {
      rethrow;
    }
  }

  /// Deep cleans data through JSON to ensure it's "pure" primitive data
  ///
  /// Serializes data to JSON string and deserializes back to remove
  /// any non-JSON-compatible types or custom objects. Ensures data
  /// can be safely stored in databases or transmitted over networks.
  ///
  /// **Internal use only.** Used internally by Bingo storage operations.
  ///
  /// Example:
  /// ```dart
  /// final data = {'date': DateTime.now(), 'value': 42};
  /// final cleaned = Converter.clean(data);
  /// // Returns: {'date': '2023-01-01T00:00:00.000Z', 'value': 42}
  /// ```
  static dynamic clean(dynamic data) => jsonDecode(jsonEncode(data));
}
