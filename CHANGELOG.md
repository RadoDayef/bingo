# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2026-07-02

### Added
- **Key Existence Check:** Added `.isMarked` extension on `String` for checking key presence without retrieval (`'key'.isMarked`).
- **Merge Control:** Added `merge` parameter to `Bingo.mark()` — defaults to `true` (auto-merge Maps), pass `false` to overwrite.

### Changed
- **Unified Write API:** Removed public `remark()` method. `Bingo.mark()` now auto-merges Maps by default — no need to choose between `mark` and `remark`.
- **Example App:** Updated with SETTINGS DEMO section showing merge vs overwrite behavior, `.isMarked` indicator, and cleaned up retrieval logic.

### Removed
- **`Bingo.remark()`** — replaced by `Bingo.mark(key, value)` (default merge) and `Bingo.mark(key, value, merge: false)` (overwrite).

---

## [1.0.2] - 2026-06-29

### Changed
- **Setup:** Updated `setup()` signature from `void` to `Future<void>` for proper async initialization.

---

## [1.0.1] - 2026-01-29

### Fixed
- **Documentation Assets:** Updated README.md to use permanent hosted image URLs for the logo and preview.
- **Project Metadata:** Refined package description and added repository links for better pub.dev score and discoverability.

---

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