/// Data processing utility for transforming objects into JSON-safe formats
/// 
/// This internal handler processes various data types and converts them
/// into formats compatible with JSON serialization and database storage.
/// It handles primitives, collections, and custom objects seamlessly.
/// 
/// **Note:** This is an internal utility class and should not be used
/// directly by external packages. Use the public Bingo API instead.
/// 
/// Example:
/// ```dart
/// // Internal use - processed automatically by Bingo.mark() and Bingo.remark()
/// final processed = Handler.process(complexObject);
/// ```
library;

import 'converter.dart';

/// Internal data processor for Bingo operations
/// 
/// This class provides static methods for converting various data types
/// into JSON-compatible formats suitable for storage and serialization.
/// 
/// **Internal use only.** This class is used internally by Bingo
/// components and should not be called directly from external code.
class Handler {
  Handler._();

  /// Transforms any object into a JSON-safe format (Map, List, or Primitive)
  /// 
  /// Handles various data types:
  /// - Primitives (String, num, bool): returned as-is
  /// - Iterables: converted to Lists
  /// - Lists: recursively processes each item
  /// - Custom objects: serialized using Converter.serialize()
  /// 
  /// **Internal use only.** This method is used internally by Bingo
  /// storage operations and should not be called directly.
  /// 
  /// Example:
  /// ```dart
  /// final processed = Handler.process(userObject);
  /// // Returns: {'name': 'John', 'age': 30}
  /// ```
  static dynamic process(dynamic value) {
    if (value is Iterable && value is! List) value = value.toList();
    if (value is String || value is num || value is bool) return value;
    if (value is List) {
      return value.map((item) {
        if (item is Map || item is String || item is num || item is bool) return item;
        return Converter.serialize(item);
      }).toList();
    }
    return Converter.serialize(value);
  }
}
