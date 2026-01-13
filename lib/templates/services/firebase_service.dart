import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
// ignore: depend_on_referenced_packages
import 'package:advertising_id/advertising_id.dart';
import '../store_interfaces.dart';

class FirebaseAnalyticsImpl implements StoreAnalytics {
  final _analytics = FirebaseAnalytics.instance;

  final _appInstanceId = Completer<String>();

  @override
  Future<String> get appInstanceId async => _appInstanceId.future;

  @override
  Future<void> init() async {
    final id = await _getAppInstanceId();
    _appInstanceId.complete(id ?? 'NA');
  }

  Future<String?> _getAppInstanceId() async {
    try {
      final id = await _analytics.appInstanceId;
      return id;
    } catch (e) {
      return null;
    }
  }
}

class FirebasePushImpl implements StorePush {
  @override
  // TODO: implement messages
  Future<Map<String, dynamic>> get messages => throw UnimplementedError();

  @override
  // TODO: implement onMessageReceived
  Stream<Map<String, dynamic>> get onMessageReceived =>
      throw UnimplementedError();

  @override
  // TODO: implement onMessagesReceived
  Stream<List<Map<String, dynamic>>> get onMessagesReceived =>
      throw UnimplementedError();

  @override
  // TODO: implement permissionStatus
  PushNotificationStatus get permissionStatus => throw UnimplementedError();

  @override
  // TODO: implement permissionStatusReceived
  Stream<PushNotificationStatus> get permissionStatusReceived =>
      throw UnimplementedError();

  @override
  Future<String?> get token async => _token.future;

  final _messaging = FirebaseMessaging.instance;

  final _token = Completer<String>();

  @override
  Future<void> init() async {
    final token = await _getToken();
    _token.complete(token ?? 'NA');
  }

  Future<String?> _getToken() async {
    try {
      final token = await _messaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> checkPermissionStatus() {
    // TODO: implement checkPermissionStatus
    throw UnimplementedError();
  }

  @override
  Future<void> requestPermission({
    void Function()? onPermissionGranted,
    void Function()? onPermissionDenied,
  }) async {
    final permission = await _messaging.requestPermission();
    switch (permission.authorizationStatus) {
      case AuthorizationStatus.authorized:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthorizationStatus.provisional:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthorizationStatus.denied:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AuthorizationStatus.notDetermined:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

class FirebaseAdsImpl implements StoreAds {
  final _advertisingId = Completer<String>();

  @override
  final String advertisingType = 'GAID';

  @override
  Future<String> get advertisingId async => _advertisingId.future;

  @override
  Future<void> init() async {
    final id = await _getAdvertisingId();
    _advertisingId.complete(id ?? 'NA');
  }

  Future<String?> _getAdvertisingId() async {
    try {
      final id = await AdvertisingId.id(true);
      return id;
    } catch (e) {
      return null;
    }
  }
}

class FirebaseRemoteConfigImpl implements StoreRemoteConfig {
  final FirebaseRemoteConfig _config = FirebaseRemoteConfig.instance;

  final _settings = RemoteConfigSettings(
    fetchTimeout: Duration.zero,
    minimumFetchInterval: Duration.zero,
  );

  @override
  Future<void> fetchAndActivate() async {
    await _config.setConfigSettings(_settings);
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

  @override
  Map<String, dynamic> getAll() => _config.getAll();
}

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  late final StoreAnalytics analytics;
  late final StorePush push;
  late final StoreAds ads;
  late final StoreRemoteConfig remoteConfig;

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      print('🔥 FirebaseService initialized');

      analytics = FirebaseAnalyticsImpl();
      push = FirebasePushImpl();
      ads = FirebaseAdsImpl();
      remoteConfig = FirebaseRemoteConfigImpl();

      await analytics.init();
      await ads.init();
      await push.init();
      await remoteConfig.fetchAndActivate();

      print('🔥 Firebase Adapters initialized');
    } catch (e) {
      print('🔥 FirebaseService init error: $e');
    }
  }
}
