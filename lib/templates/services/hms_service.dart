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
  Future<String?> getToken() async {
    print('🔔 [HMS Stub] getToken');
    return 'hms_stub_token';
  }

  @override
  Stream<String> get onTokenRefresh => Stream.empty();
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
    print('⚙️ [HMS Stub] fetchAndActivate');
  }

  @override
  String getString(String key) => '';

  @override
  bool getBool(String key) => false;

  @override
  int getInt(String key) => 0;

  @override
  double getDouble(String key) => 0.0;
}

class HmsService {
  static final HmsService _instance = HmsService._internal();

  factory HmsService() {
    return _instance;
  }

  HmsService._internal();

  Future<void> init() async {
    print('🔴 HmsService (Stub) initialized');
  }
}
