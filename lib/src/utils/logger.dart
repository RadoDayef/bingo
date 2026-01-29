/// Utility class for logging debug messages in the Bingo package
/// 
/// Provides formatted logging that only outputs in debug mode to avoid
/// cluttering production logs. Messages are prefixed with emoji indicators
/// for easy visual distinction between success and failure states.
/// 
/// Example:
/// ```dart
/// Logger.successDebugLog('Data saved successfully');
/// Logger.failureDebugLog('Failed to save data: $error');
/// ```
library;

import 'package:flutter/foundation.dart';

/// Centralized logging utility for Bingo operations
/// 
/// This class provides static methods for logging success and failure
/// messages with consistent formatting and debug-mode filtering.
/// 
/// **Note:** This is an internal utility class and should not be used
/// directly by external packages. Use the public Bingo API instead.
class Logger {
  Logger._();

  /// Logs failure/error messages with error emoji prefix
  /// 
  /// Only outputs when running in debug mode (kDebugMode is true).
  /// Messages are prefixed with "🚨 BINGO ERROR:" for easy identification.
  /// 
  /// **Internal use only.** This method is used internally by Bingo
  /// components and should not be called directly from external code.
  /// 
  /// Example:
  /// ```dart
  /// Logger.failureDebugLog('Failed to save user data: $error');
  /// ```
  static void failureDebugLog(dynamic object) {
    if (kDebugMode) print("🚨 BINGO ERROR: $object");
  }

  /// Logs success messages with success emoji prefix
  /// 
  /// Only outputs when running in debug mode (kDebugMode is true).
  /// Messages are prefixed with "✅ BINGO SUCCESS:" for easy identification.
  /// 
  /// **Internal use only.** This method is used internally by Bingo
  /// components and should not be called directly from external code.
  /// 
  /// Example:
  /// ```dart
  /// Logger.successDebugLog('User data saved successfully');
  /// ```
  static void successDebugLog(dynamic object) {
    if (kDebugMode) print("✅ BINGO SUCCESS: $object");
  }
}
