import 'services/firebase_service.dart';
import 'services/hms_service.dart';

class StoreService {
  static final StoreService _instance = StoreService._internal();

  factory StoreService() {
    return _instance;
  }

  StoreService._internal();

  Future<void> init() async {
    // In Hybrid mode, we might want to initialize both or check availability.
    // For now, initializing both.
    try {
      await FirebaseService().init();
    } catch (e) {
      print('Firebase Init Error: $e');
    }

    try {
      await HmsService().init();
    } catch (e) {
      print('HMS Init Error: $e');
    }
  }
}
