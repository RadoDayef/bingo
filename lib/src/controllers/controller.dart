/// Internal controller for managing Bingo storage operations
/// 
/// This controller acts as the intermediary between the public Bingo API
/// and the internal storage engine. It handles data processing, serialization,
/// error handling, and logging for all storage operations.
/// 
/// **Note:** This is an internal utility class and should not be used
/// directly by external packages. Use the public Bingo API instead.
/// 
/// Example:
/// ```dart
/// // Internal use - managed automatically by Bingo static methods
/// final controller = Controller();
/// controller.setup();
/// controller.mark('key', 'value');
/// ```
library;

import 'package:bingo/src/engines/engine.dart';
import 'package:bingo/src/logic/converter.dart';
import 'package:bingo/src/logic/handler.dart';
import 'package:bingo/src/logic/registry.dart';
import 'package:bingo/src/utils/logger.dart';

/// Internal controller for coordinating Bingo storage operations
/// 
/// This class manages the flow of data between the public API and the
/// storage engine, handling processing, serialization, and error management.
/// 
/// **Internal use only.** This class is used internally by Bingo
/// components and should not be called directly from external code.
class Controller {
  static final Engine _engine = Engine();

  /// Initializes the storage system and database connection
  /// 
  /// Sets up the database engine and loads existing data into cache.
  /// Must be called before any other storage operations.
  /// 
  /// **Internal use only.** Use Bingo.setup() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// controller.setup();
  /// // Storage system is ready for use
  /// ```
  void setup() => _engine.init();

  /// Registers a factory function for deserializing custom objects
  /// 
  /// Delegates to the Registry to enable automatic deserialization
  /// of custom object types during retrieval operations.
  /// 
  /// **Internal use only.** Use Bingo.register() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// controller.register<User>((json) => User.fromJson(json));
  /// // User objects can now be deserialized automatically
  /// ```
  void register<T>(T Function(Map<String, dynamic>) factory) {
    Registry.register<T>(factory);
  }

  /// Saves a value with the given key, handling serialization and logging
  /// 
  /// Processes the value for JSON compatibility, cleans the data,
  /// saves to both cache and persistent storage, and logs the operation.
  /// 
  /// **Internal use only.** Use Bingo.mark() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// controller.mark('username', 'john_doe');
  /// // Value is saved and success is logged
  /// ```
  void mark(String key, dynamic value) {
    try {
      final processed = Handler.process(value);
      _engine.save(key, Converter.clean(processed));
      Logger.successDebugLog("Data marked successfully with key: $key");
    } catch (error) {
      Logger.failureDebugLog("Failed to mark $key. $error");
    }
  }

  /// Retrieves and deserializes a value by key with type safety
  /// 
  /// Reads from cache, attempts deserialization using registered factories,
  /// and handles both primitive and complex data types with proper error logging.
  /// 
  /// **Internal use only.** Use Bingo.call() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// final username = controller.call<String>('username');
  /// // Returns: 'john_doe' or null
  /// ```
  T? call<T>(String key) {
    try {
      final data = _engine.read(key);
      if (data == null) return null;
      if (data is! Map && data is! List) return data as T;
      if (data is List) {
        final maker = Registry.listFactories[T.toString()];
        return maker != null ? maker(data) as T : data.cast<Object?>() as T;
      }
      if (data is Map) {
        final factory = Registry.factories[T];
        final cleanMap = Map<String, dynamic>.from(data);
        return factory != null ? factory(cleanMap) as T : cleanMap as T;
      }
      return data as T;
    } catch (error) {
      Logger.failureDebugLog("Failed to call $key. $error");
      return null;
    }
  }

  /// Updates or saves a value with smart merge logic for maps
  /// 
  /// For map values, performs a shallow merge with existing data.
  /// For other types, replaces the existing value entirely.
  /// Handles processing, cleaning, and appropriate storage operations.
  /// 
  /// **Internal use only.** Use Bingo.remark() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// controller.remark('settings', {'theme': 'dark'});
  /// // Merges with existing settings or creates new
  /// ```
  void remark(String key, dynamic value) {
    try {
      final processed = Handler.process(value);
      final cleanData = Converter.clean(processed);

      if (cleanData is Map<String, dynamic> && value is! List) {
        _engine.update(key, cleanData);
      } else {
        _engine.save(key, cleanData);
      }
      Logger.successDebugLog("Data remarked successfully with key: $key");
    } catch (error) {
      Logger.failureDebugLog("Failed to remark $key. $error");
    }
  }

  /// Removes a specific key from storage with logging
  /// 
  /// Deletes the key-value pair from both cache and persistent storage
  /// and logs the operation result.
  /// 
  /// **Internal use only.** Use Bingo.erase() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// controller.erase('temporary_data');
  /// // Key is removed and success is logged
  /// ```
  void erase(String key) {
    try {
      _engine.delete(key);
      Logger.successDebugLog("Data erased successfully with key: $key.");
    } catch (error) {
      Logger.failureDebugLog("Failed to erase $key. $error");
    }
  }

  /// Clears all data from storage with comprehensive logging
  /// 
  /// Removes all data from both cache and persistent storage.
  /// Use with caution as this operation is irreversible.
  /// 
  /// **Internal use only.** Use Bingo.clear() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// controller.clear();
  /// // All data is removed and success is logged
  /// ```
  void clear() {
    try {
      _engine.clearAll();
      Logger.successDebugLog("All data cleared successfully from storage.");
    } catch (error) {
      Logger.failureDebugLog("Failed to clear database. $error");
    }
  }
}
