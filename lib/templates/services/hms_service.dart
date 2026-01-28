import 'dart:async';

import 'package:huawei_ads/huawei_ads.dart';
import 'package:huawei_push/huawei_push.dart';

import '../store_interfaces.dart';

class HmsAnalyticsImpl implements StoreAnalytics {
  String? _appInstanceId;

  @override
  String? get appInstanceId => _appInstanceId;

  @override
  Future<void> init() async {
    _appInstanceId = await _getAppInstanceId();
  }

  Future<String?> _getAppInstanceId() async {
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }
}

class HmsPushImpl implements StorePush {
  String? _token;

  @override
  String? get token => _token;

  PushNotification? _initialMessage;

  @override
  PushNotification? get initialMessage => _initialMessage;

  final _onMessageReceived = StreamController<PushNotification>.broadcast();

  @override
  Stream<PushNotification> get onMessageReceived => _onMessageReceived.stream;

  @override
  Future<void> init() async {
    await _getToken();
    await _initInitialMessage();
    _handleOnMessageReceived();
    _handleOnMessageOpenedApp();
  }

  Future<void> _getToken() async {
    Push.getToken('');
    Push.getTokenStream.listen(
      (token) {
        _token = token;
      },
      onError: (error) {
        _token = null;
      },
    );
  }

  Future<void> _initInitialMessage() async {
    final message = await Push.getInitialNotification();
    if (message != null) {
      _initialMessage = _parsePushNotification(message);
    }
  }

  PushNotification _parsePushNotification(Map<Object?, Object?> message) {
    final extras = message['extras'] as Map<Object?, Object?>;
    return PushNotification(
      title: extras['title'] as String?,
      body: extras['body'] as String?,
      imageUrl: extras['image'] as String?,
      data: {'link': extras['link'] as String?},
      messageId: extras['_push_msgid'] as String?,
    );
  }

  void _handleOnMessageReceived() {
    Push.onMessageReceivedStream.listen(
      (message) {
        _onMessageReceived.add(_parsePushNotification(message.toMap()));
      },
      onError: (error) {
        _onMessageReceived.addError(error);
      },
    );
  }

  void _handleOnMessageOpenedApp() {
    Push.onNotificationOpenedApp.listen(
      (message) {
        _onMessageReceived.add(_parsePushNotification(message.toMap()));
      },
      onError: (error) {
        _onMessageReceived.addError(error);
      },
    );
  }
}

class HmsAdsImpl implements StoreAds {
  String? _advertisingId;

  @override
  final String advertisingType = 'OAID';

  @override
  String? get advertisingId => _advertisingId;

  Future<String?> _getAdvertisingId() async {
    try {
      final client = await AdvertisingIdClient.getAdvertisingIdInfo();
      return client.getId;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> init() async {
    _advertisingId = await _getAdvertisingId();
  }
}

class HmsRemoteConfigImpl implements StoreRemoteConfig {
  @override
  Future<void> fetchAndActivate() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  String getString(String key) => '';

  @override
  bool getBool(String key) => false;

  @override
  int getInt(String key) => 0;

  @override
  double getDouble(String key) => 0.0;

  @override
  Map<String, dynamic> getAll() => {};
}

class HmsService {
  static final HmsService _instance = HmsService._internal();

  factory HmsService() {
    return _instance;
  }

  HmsService._internal();

  late final StoreAnalytics analytics;
  late final StorePush push;
  late final StoreAds ads;
  late final StoreRemoteConfig remoteConfig;

  Future<void> init() async {
    print('🔴 HmsService initialized');

    analytics = HmsAnalyticsImpl();
    push = HmsPushImpl();
    ads = HmsAdsImpl();
    remoteConfig = HmsRemoteConfigImpl();

    await analytics.init();
    await ads.init();
    await push.init();
    await remoteConfig.fetchAndActivate();

    print('🔴 Hms Adapters initialized');
  }
}
