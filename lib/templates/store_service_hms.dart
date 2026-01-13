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
    // 1. Init HMS (and adapters internally)
    final service = HmsService();
    await service.init();

    // 2. Assign adapters
    analytics = service.analytics;
    push = service.push;
    ads = service.ads;
    remoteConfig = service.remoteConfig;

    print('✅ StoreService (HMS) fully initialized');
  }
}
