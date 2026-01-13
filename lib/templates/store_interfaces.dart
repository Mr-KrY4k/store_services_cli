abstract class StoreAnalytics {
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]);
  // Add other common methods if needed
}

abstract class StorePush {
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
}

abstract class StoreAds {
  String get advertisingType;
  Future<String> get advertisingId;
}

abstract class StoreRemoteConfig {
  Future<void> fetchAndActivate();
  String getString(String key);
  bool getBool(String key);
  int getInt(String key);
  double getDouble(String key);
}
