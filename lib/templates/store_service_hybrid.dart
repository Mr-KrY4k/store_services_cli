import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';
import 'services/firebase_service.dart';
import 'services/hms_service.dart';
import 'store_interfaces.dart';

export 'store_interfaces.dart';

class StoreService {
  static final StoreService _instance = StoreService._internal();

  factory StoreService() {
    return _instance;
  }

  StoreService._internal();

  // Public Interfaces
  late final StoreAnalytics analytics;
  late final StorePush push;
  late final StoreAds ads;
  late final StoreRemoteConfig remoteConfig;

  bool _isHms = false;

  Future<void> init() async {
    // Check HMS Availability
    try {
      final hmsApi = HmsApiAvailability();
      final result = await hmsApi.isHMSAvailable();
      // 0 means SUCCESS (HMS Available)
      _isHms = result == 0;
      print('🔍 HMS Available: \$_isHms (Code: \$result)');
    } catch (e) {
      print('⚠️ HmsApiAvailability check failed: \$e');
      _isHms = false;
    }

    if (_isHms) {
      await HmsService().init();
      analytics = HmsAnalyticsImpl();
      push = HmsPushImpl();
      ads = HmsAdsImpl();
      remoteConfig = HmsRemoteConfigImpl();

      await analytics.init();
      await ads.init();

      print('✅ StoreService initialized in HMS Mode');
    } else {
      await FirebaseService().init();
      analytics = FirebaseAnalyticsImpl();
      push = FirebasePushImpl();
      ads = FirebaseAdsImpl();
      remoteConfig = FirebaseRemoteConfigImpl();

      await analytics.init();
      await ads.init();

      print('✅ StoreService initialized in GMS Mode');
    }
  }
}
