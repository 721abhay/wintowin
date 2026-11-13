import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://demo-wintowin.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'public-anon-key-placeholder',
  );

  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static SupabaseClient? get client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static Future<void> initialize() async {
    try {
      if (supabaseUrl.isNotEmpty &&
          supabaseAnonKey.isNotEmpty &&
          !supabaseUrl.contains('demo-wintowin')) {
        await Supabase.initialize(
          url: supabaseUrl,
          // ignore: deprecated_member_use
          anonKey: supabaseAnonKey,
        );
        _isInitialized = true;
        debugPrint('[Supabase] Initialized successfully with $supabaseUrl');
      } else {
        debugPrint('[Supabase] Running in local demo/offline mode.');
      }
    } catch (e) {
      debugPrint('[Supabase] Initialization deferred: $e');
      _isInitialized = false;
    }
  }
}
