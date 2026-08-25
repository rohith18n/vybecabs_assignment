// File generated for VybeCabs Firebase initialization.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] used by `Firebase.initializeApp`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDLyefd1vFuwpFwwvJ1fPJUqJjS97_1MC0',
    appId: '1:817016084169:web:df9bc97c20a14520fadf18',
    messagingSenderId: '817016084169',
    projectId: 'vybecabs-77b5b',
    authDomain: 'vybecabs-77b5b.firebaseapp.com',
    storageBucket: 'vybecabs-77b5b.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLyefd1vFuwpFwwvJ1fPJUqJjS97_1MC0',
    appId: '1:817016084169:android:df9bc97c20a14520fadf18',
    messagingSenderId: '817016084169',
    projectId: 'vybecabs-77b5b',
    storageBucket: 'vybecabs-77b5b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLyefd1vFuwpFwwvJ1fPJUqJjS97_1MC0',
    appId: '1:817016084169:ios:df9bc97c20a14520fadf18',
    messagingSenderId: '817016084169',
    projectId: 'vybecabs-77b5b',
    storageBucket: 'vybecabs-77b5b.firebasestorage.app',
    iosBundleId: 'com.example.vybecabsAssignment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDLyefd1vFuwpFwwvJ1fPJUqJjS97_1MC0',
    appId: '1:817016084169:ios:df9bc97c20a14520fadf18',
    messagingSenderId: '817016084169',
    projectId: 'vybecabs-77b5b',
    storageBucket: 'vybecabs-77b5b.firebasestorage.app',
    iosBundleId: 'com.example.vybecabsAssignment',
  );
}
