# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-01-29

### Added
- **Initial Release** of the Bingo Storage Engine.
- **Synchronous Cache:** Implemented a high-speed in-memory cache layer for zero-latency data retrieval.
- **Sembast Integration:** Reliable NoSQL persistent storage using Sembast.
- **Custom Type Registry:** Added `Bingo.register<T>()` to allow automatic deserialization of custom Dart objects and Lists.
- **Core API Methods:**
    - `setup()`: Initializing the database and warming up the cache.
    - `mark()`: Saving primitives and complex objects.
    - `call<T>()`: Type-safe synchronous retrieval.
    - `remark()`: Smart merging for Map updates.
    - `erase()`: Deleting specific keys.
    - `clear()`: Wiping the entire database.
- **Logger:** Built-in success/failure emoji logging for better developer experience in debug mode.
- **Data Handler:** Automatic serialization logic for objects with `toJson()` or `toMap()` methods.

### Changed
- Refined internal `Engine` logic to ensure cache and database are always in sync.
- Optimized `Handler` to handle nested lists and recursive maps.

### Security
- Implemented `Converter.clean()` to ensure data purity and prevent non-JSON compatible objects from corrupting the persistent store.
