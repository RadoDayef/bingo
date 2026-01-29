/// Core database engine for the Bingo package
/// 
/// This internal engine provides persistent storage using Sembast with
/// in-memory caching for fast access. It handles database initialization,
/// CRUD operations, and cache synchronization automatically.
/// 
/// **Note:** This is an internal utility class and should not be used
/// directly by external packages. Use the public Bingo API instead.
/// 
/// Example:
/// ```dart
/// // Internal use - managed automatically by Bingo.setup()
/// final engine = Engine();
/// await engine.init();
/// engine.save('key', 'value');
/// ```
library;

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

/// Internal database engine for Bingo storage operations
/// 
/// This class provides the core storage functionality using Sembast
/// database with an in-memory cache layer for performance optimization.
/// 
/// **Internal use only.** This class is used internally by Bingo
/// components and should not be called directly from external code.
class Engine {
  Database? _db;
  final _store = StoreRef<String, dynamic>.main();

  final Map<String, dynamic> _cache = {};

  /// Initializes the database and loads all existing records into memory cache
  /// 
  /// Creates the database file in the application documents directory
  /// and loads all existing records into the in-memory cache for fast access.
  /// Must be called before any other operations.
  /// 
  /// **Internal use only.** Use Bingo.setup() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// await engine.init();
  /// // Database is ready and cache is populated
  /// ```
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/bingo.db';
    _db = await databaseFactoryIo.openDatabase(dbPath);

    final records = await _store.find(_db!);
    for (var record in records) {
      _cache[record.key] = record.value;
    }
  }

  /// Retrieves a value from the in-memory cache by key
  /// 
  /// Returns the cached value for the given key, or null if not found.
  /// This operation is very fast as it only accesses memory.
  /// 
  /// **Internal use only.** Use Bingo.call() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// final value = engine.read('user_name');
  /// // Returns: 'John' or null
  /// ```
  dynamic read(String key) {
    return _cache[key];
  }

  /// Saves a value to both cache and persistent storage
  /// 
  /// Stores the value in both the in-memory cache and the persistent
  /// database to ensure data consistency and fast future access.
  /// 
  /// **Internal use only.** Use Bingo.mark() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// engine.save('user_name', 'John');
  /// // Value is now in both cache and database
  /// ```
  void save(String key, dynamic value) {
    _cache[key] = value;
    _store.record(key).put(_db!, value);
  }

  /// Updates an existing map value by merging partial data, or saves as new map if not exists
  /// 
  /// If the existing value is a Map, performs a shallow merge with the partial data.
  /// If no existing value or not a Map, saves the partial data as a new Map.
  /// 
  /// **Internal use only.** Use Bingo.remark() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// engine.update('user', {'age': 25});
  /// // Merges with existing user data or creates new user map
  /// ```
  void update(String key, Map<String, dynamic> partialData) {
    final existing = _cache[key];
    if (existing is Map) {
      final Map<String, dynamic> updatedMap = {...existing, ...partialData};
      _cache[key] = updatedMap;
      _store.record(key).put(_db!, updatedMap);
    } else {
      save(key, partialData);
    }
  }

  /// Deletes a value from both cache and persistent storage by key
  /// 
  /// Removes the key-value pair from both the in-memory cache and the
  /// persistent database to maintain consistency.
  /// 
  /// **Internal use only.** Use Bingo.erase() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// engine.delete('temporary_data');
  /// // Key-value pair is removed from both cache and database
  /// ```
  void delete(String key) {
    _cache.remove(key);
    _store.record(key).delete(_db!);
  }

  /// Clears all values from both cache and persistent storage
  /// 
  /// Removes all data from both the in-memory cache and the persistent
  /// database. Use with caution as this operation is irreversible.
  /// 
  /// **Internal use only.** Use Bingo.clear() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// engine.clearAll();
  /// // All data is removed from both cache and database
  /// ```
  void clearAll() {
    _cache.clear();
    _store.delete(_db!);
  }
}
