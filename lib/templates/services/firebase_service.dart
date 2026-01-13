import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
// ignore: depend_on_referenced_packages
import 'package:advertising_id/advertising_id.dart';
import '../store_interfaces.dart';

class FirebaseAnalyticsImpl implements StoreAnalytics {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    final Map<String, Object>? params = parameters?.cast<String, Object>();
    await _analytics.logEvent(name: name, parameters: params);
  }
}

class FirebasePushImpl implements StorePush {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
}

class FirebaseAdsImpl implements StoreAds {
  String? _advertisingId;

  @override
  final String advertisingType = 'GAID';

  @override
  Future<String> get advertisingId async {
    _advertisingId ??= await AdvertisingId.id(true);
    return _advertisingId ?? 'NA';
  }
}

class FirebaseRemoteConfigImpl implements StoreRemoteConfig {
  final FirebaseRemoteConfig _config = FirebaseRemoteConfig.instance;

  @override
  Future<void> fetchAndActivate() async {
    await _config.fetchAndActivate();
  }

  @override
  String getString(String key) => _config.getString(key);

  @override
  bool getBool(String key) => _config.getBool(key);

  @override
  int getInt(String key) => _config.getInt(key);

  @override
  double getDouble(String key) => _config.getDouble(key);
}

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      print('🔥 FirebaseService initialized');
    } catch (e) {
      print('🔥 FirebaseService init error: $e');
    }
  }
}
