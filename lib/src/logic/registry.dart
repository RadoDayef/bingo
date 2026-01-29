/// Type registry for deserializing custom objects in the Bingo package
/// 
/// This internal registry manages factory functions for converting
/// JSON data back into custom object types. It supports both single
/// objects and lists of objects.
/// 
/// **Note:** This is an internal utility class and should not be used
/// directly by external packages. Use the public Bingo.register() API instead.
/// 
/// Example:
/// ```dart
/// // Internal use - use Bingo.register<User>((json) => User.fromJson(json)) instead
/// Registry.register<User>((json) => User.fromJson(json));
/// ```
library;

class Registry {
  Registry._();

  static final Map<Type, dynamic Function(Map<String, dynamic>)> factories = {};
  static final Map<String, dynamic Function(List)> listFactories = {};

  /// Registers a factory function for creating objects of type T from JSON
  /// 
  /// Automatically registers both single object and list factories for the type.
  /// The factory should accept a Map<String, dynamic> and return an instance of T.
  /// 
  /// **Internal use only.** Use Bingo.register<T>() instead of calling this directly.
  /// 
  /// Example:
  /// ```dart
  /// Registry.register<User>((json) => User.fromJson(json));
  /// // Automatically creates List<User> factory as well
  /// ```
  static void register<T>(T Function(Map<String, dynamic>) factory) {
    factories[T] = factory;
    listFactories["List<$T>"] = (List rawList) {
      return rawList.map((item) => factory(Map<String, dynamic>.from(item))).toList().cast<T>();
    };
  }
}
