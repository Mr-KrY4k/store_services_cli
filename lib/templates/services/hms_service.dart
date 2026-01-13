class HmsService {
  static final HmsService _instance = HmsService._internal();

  factory HmsService() {
    return _instance;
  }

  HmsService._internal();

  Future<void> init() async {
    // TODO: Initialize HMS Core if needed
    print('🧨 HmsService initialized');
  }
}
