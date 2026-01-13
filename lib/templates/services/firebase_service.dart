class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<void> init() async {
    // TODO: Initialize Firebase Core
    // await Firebase.initializeApp();
    print('🔥 FirebaseService initialized');
  }
}
