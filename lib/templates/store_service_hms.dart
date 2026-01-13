import 'services/hms_service.dart';

class StoreService {
  static final StoreService _instance = StoreService._internal();

  factory StoreService() {
    return _instance;
  }

  StoreService._internal();

  Future<void> init() async {
    await HmsService().init();
  }
}
