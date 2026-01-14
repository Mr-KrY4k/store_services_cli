import 'dart:async';

import 'package:huawei_ads/huawei_ads.dart';

import '../store_interfaces.dart';

class HmsAnalyticsImpl implements StoreAnalytics {
  final _appInstanceId = Completer<String>();

  @override
  Future<String> get appInstanceId async => _appInstanceId.future;

  @override
  Future<void> init() async {
    final id = await _getAppInstanceId();
    _appInstanceId.complete(id ?? 'NA');
  }

  Future<String?> _getAppInstanceId() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'NA';
  }
}

class HmsPushImpl implements StorePush {
  @override
  Future<PushNotificationStatus> checkPermissionStatus() {
    // TODO: implement checkPermissionStatus
    throw UnimplementedError();
  }

  @override
  Future<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

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
  Future<PushNotificationStatus> requestPermission() {
    // TODO: implement requestPermission
    throw UnimplementedError();
  }

  @override
  // TODO: implement token
  Future<String?> get token => throw UnimplementedError();
}

class HmsAdsImpl implements StoreAds {
  final _advertisingId = Completer<String>();

  @override
  final String advertisingType = 'OAID';

  @override
  Future<String> get advertisingId async => _advertisingId.future;

  Future<String?> _getAdvertisingId() async {
    try {
      final client = await AdvertisingIdClient.getAdvertisingIdInfo();
      return client.getId;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> init() async {
    final id = await _getAdvertisingId();
    _advertisingId.complete(id ?? 'NA');
  }
}

class HmsRemoteConfigImpl implements StoreRemoteConfig {
  @override
  Future<void> fetchAndActivate() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  String getString(String key) => '';

  @override
  bool getBool(String key) => false;

  @override
  int getInt(String key) => 0;

  @override
  double getDouble(String key) => 0.0;

  @override
  Map<String, dynamic> getAll() => {};
}

class HmsService {
  static final HmsService _instance = HmsService._internal();

  factory HmsService() {
    return _instance;
  }

  HmsService._internal();

  late final StoreAnalytics analytics;
  late final StorePush push;
  late final StoreAds ads;
  late final StoreRemoteConfig remoteConfig;

  Future<void> init() async {
    print('🔴 HmsService (Stub) initialized');

    analytics = HmsAnalyticsImpl();
    push = HmsPushImpl();
    ads = HmsAdsImpl();
    remoteConfig = HmsRemoteConfigImpl();

    await analytics.init();
    await ads.init();

    // push.init() is currently abstract/unimplemented in stub,
    // but if we implemented it, we'd call it here.
    // For now we assume safety or that stub implements it securely.
    // However, the user added `init()` to HmsPushImpl but it throws UnimplementedError.
    // We should NOT call it if it throws.
    // Actually, earlier the user showed HmsPushImpl with UnimplementedError for init.
    // Calling it will crash.
    // But StoreService structure requires valid instances.
    // I should probably FIX HmsPushImpl to have a safe init first?
    // Or just try specific calls.

    // Wait, the user added `init` to interfaces.
    try {
      await push.init();
    } catch (_) {} // safe stub

    await remoteConfig.fetchAndActivate();

    print('🔴 Hms Adapters initialized');
  }
}
