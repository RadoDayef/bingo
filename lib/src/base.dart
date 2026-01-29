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
  static void setup() => _controller.setup();

  /// Registers a factory function for deserializing objects of type T
  /// 
  /// Use this to enable automatic deserialization of custom objects.
  /// The factory should accept a Map<String, dynamic> and return an instance of T.
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
  static void mark(String key, dynamic value) => _controller.mark(key, value);

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

  /// Updates or saves a value, using update for maps and save for other types
  /// 
  /// For map values, performs a shallow merge with existing data.
  /// For other types, replaces the existing value entirely.
  /// 
  /// Example:
  /// ```dart
  /// Bingo.remark('settings', {'theme': 'light'}); // Merges with existing settings
  /// Bingo.remark('counter', 42); // Replaces existing counter
  /// ```
  static void remark(String key, dynamic value) => _controller.remark(key, value);

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
