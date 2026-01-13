class StoreService {
  static final StoreService _instance = StoreService._internal();

  factory StoreService() {
    return _instance;
  }

  StoreService._internal();

  Future<void> init() async {
    // TODO: Initialize appropriate service (GMS/HMS)
  }
}
