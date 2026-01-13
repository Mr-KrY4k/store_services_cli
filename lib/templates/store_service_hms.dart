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

  Future<void> init() async {
    // 1. Init HMS
    await HmsService().init();

    // 2. Assign adapters
    analytics = HmsAnalyticsImpl();
    push = HmsPushImpl();
    ads = HmsAdsImpl();
    remoteConfig = HmsRemoteConfigImpl();

    print('✅ StoreService (HMS) fully initialized');
  }
}
