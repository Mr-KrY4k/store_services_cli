import 'package:huawei_ads/huawei_ads.dart';

import '../store_interfaces.dart';

class HmsAnalyticsImpl implements StoreAnalytics {
  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    print('📊 [HMS Stub] logEvent: \$name');
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
  String? _advertisingId;

  @override
  final String advertisingType = 'OAID';

  @override
  Future<String> get advertisingId async {
    _advertisingId ??= await _getAdvertisingId();
    return _advertisingId ?? 'NA';
  }

  Future<String?> _getAdvertisingId() async {
    final client = await AdvertisingIdClient.getAdvertisingIdInfo();
    return client.getId;
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
