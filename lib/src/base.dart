/// Bingo - A simple and efficient storage solution for Flutter applications
///
/// This package provides a clean API for persisting data with automatic
/// serialization, caching, and type-safe retrieval.
///
/// Features:
/// - Automatic JSON serialization/deserialization
/// - In-memory caching for fast access
/// - Type-safe storage and retrieval
/// - Support for complex objects and collections
///
/// Example usage:
/// ```dart
/// // Initialize the storage
/// await Bingo.setup();
///
/// // Save data
/// Bingo.mark('user', {'name': 'John', 'age': 30});
///
/// // Retrieve data
/// final user = Bingo.call<Map<String, dynamic>>('user');
/// ```
library;

import 'package:bingo/src/controllers/controller.dart';
import 'package:bingo/src/logic/registry.dart';

/// The main Bingo class providing the public API for storage operations
///
/// This class serves as a facade for all storage functionality, offering
/// a simple and intuitive interface for persisting and retrieving data.
class Bingo {
  Bingo._();

  static final Controller _controller = Controller();

  /// Initializes the Bingo storage system
  ///
  /// Must be called before any other Bingo operations. Sets up the
  /// database connection and loads existing data into memory cache.
  ///
  /// Example:
  /// ```dart
  /// Bingo.setup();
  /// ```
  static Future<void> setup() async => await _controller.setup();

  /// Registers a factory function for deserializing objects of type T
  ///
  /// Use this to enable automatic deserialization of custom objects.
  /// The factory should accept a `Map<String, dynamic>` and return an instance of T.
  ///
  /// Example:
  /// ```dart
  /// Bingo.register<User>((json) => User.fromJson(json));
  /// ```
  static void register<T>(T Function(Map<String, dynamic>) factory) => Registry.register<T>(factory);

  /// Saves a value with the given key, handling serialization of complex objects
  ///
  /// Automatically serializes objects, lists, and primitive types.
  /// Supports any type that can be converted to JSON or has a toJson()/toMap() method.
  ///
  /// Example:
  /// ```dart
  /// Bingo.mark('username', 'john_doe');
  /// Bingo.mark('settings', {'theme': 'dark', 'notifications': true});
  /// Bingo.mark('users', [User('John'), User('Jane')]);
  /// ```
  static void mark(String key, dynamic value, {bool merge = true}) => _controller.mark(key, value, merge: merge);

  /// Retrieves and deserializes a value by key, returning null if not found
  ///
  /// Type-safe retrieval that automatically deserializes objects if a factory
  /// has been registered for the type. Returns null if the key doesn't exist.
  ///
  /// Example:
  /// ```dart
  /// final username = Bingo.call<String>('username');
  /// final settings = Bingo.call<Map<String, dynamic>>('settings');
  /// final users = Bingo.call<List<User>>('users');
  /// ```
  static T? call<T>(String key) => _controller.call<T>(key);

  /// Removes a specific key from the database
  ///
  /// Deletes the key-value pair from both memory cache and persistent storage.
  ///
  /// Example:
  /// ```dart
  /// Bingo.erase('key');
  /// ```
  static void erase(String key) => _controller.erase(key);

  /// Wipes every single piece of data in the Bingo DB
  ///
  /// Clears all stored data from both memory cache and persistent storage.
  /// Use with caution as this operation is irreversible.
  ///
  /// Example:
  /// ```dart
  /// Bingo.clear(); // Clears all data
  /// ```
  static void clear() => _controller.clear();
}

/// Extension on [String] for convenient key existence checks
///
/// Provides a more natural syntax for checking if a key exists
/// in the Bingo storage system without calling the static API.
///
/// Example:
/// ```dart
/// final exists = 'username'.isMarked;
/// ```
extension BingoStringExtension on String {
  /// Checks if this key exists in the Bingo database
  ///
  /// Returns true if the key exists in the cache, false otherwise.
  /// Provides a clean, readable syntax for key existence checks.
  ///
  /// Example:
  /// ```dart
  /// if ('user_prefs'.isMarked) {
  ///   final data = Bingo.call<Map>('user_prefs');
  /// }
  /// ```
  bool get isMarked => Bingo._controller.isMarked(this);
}
