import 'services/firebase_service.dart';
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
    // 1. Init Firebase
    await FirebaseService().init();

    // 2. Assign adapters
    analytics = FirebaseAnalyticsImpl();
    push = FirebasePushImpl();
    ads = FirebaseAdsImpl();
    remoteConfig = FirebaseRemoteConfigImpl();

    await analytics.init();
    await ads.init();
    await remoteConfig.fetchAndActivate();

    print('✅ StoreService (GMS) fully initialized');
  }
}
