// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC0nvFmNuJaroKiYvk1amaA5wl8fyQdWP0',
    appId: '1:1001821509354:web:8301f5cd1315d5747d6993',
    messagingSenderId: '1001821509354',
    projectId: 'fir-demo-9d98a',
    authDomain: 'fir-demo-9d98a.firebaseapp.com',
    storageBucket: 'fir-demo-9d98a.firebasestorage.app',
    measurementId: 'G-KRPFVJMK3Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAg8_cmdUOgzr1xk8Pn4Q6puBMSolA48jk',
    appId: '1:1001821509354:android:8c2ac182733edc8c7d6993',
    messagingSenderId: '1001821509354',
    projectId: 'fir-demo-9d98a',
    storageBucket: 'fir-demo-9d98a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDV1892A0Pwi0VllF3Ozze-ADC25dxgFQ',
    appId: '1:1001821509354:ios:cc6c738ef45ab1d07d6993',
    messagingSenderId: '1001821509354',
    projectId: 'fir-demo-9d98a',
    storageBucket: 'fir-demo-9d98a.firebasestorage.app',
    androidClientId: '1001821509354-4gaq9dqkrg40454p0r80q7k7dtv37cv9.apps.googleusercontent.com',
    iosBundleId: 'com.example.moodo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDV1892A0Pwi0VllF3Ozze-ADC25dxgFQ',
    appId: '1:1001821509354:ios:cc6c738ef45ab1d07d6993',
    messagingSenderId: '1001821509354',
    projectId: 'fir-demo-9d98a',
    storageBucket: 'fir-demo-9d98a.firebasestorage.app',
    androidClientId: '1001821509354-4gaq9dqkrg40454p0r80q7k7dtv37cv9.apps.googleusercontent.com',
    iosBundleId: 'com.example.moodo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC0nvFmNuJaroKiYvk1amaA5wl8fyQdWP0',
    appId: '1:1001821509354:web:01695d2c6d2fa1a97d6993',
    messagingSenderId: '1001821509354',
    projectId: 'fir-demo-9d98a',
    authDomain: 'fir-demo-9d98a.firebaseapp.com',
    storageBucket: 'fir-demo-9d98a.firebasestorage.app',
    measurementId: 'G-69TVZV6637',
  );
}
