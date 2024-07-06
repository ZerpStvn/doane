// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAC7BHGoMbxGXeBdejCiS2sjMdpOGAk_v4',
    appId: '1:857987860304:web:967be0c41e4a453e128e55',
    messagingSenderId: '857987860304',
    projectId: 'doane-c693d',
    authDomain: 'doane-c693d.firebaseapp.com',
    storageBucket: 'doane-c693d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnlOloHLAozCPtsSGeMHZV77bYw7SVJ70',
    appId: '1:857987860304:android:3b1c6b088f82861d128e55',
    messagingSenderId: '857987860304',
    projectId: 'doane-c693d',
    storageBucket: 'doane-c693d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlj7ihQymPP0kY2sn-bROo1S0MxmG67mA',
    appId: '1:857987860304:ios:840275d77d7c4f28128e55',
    messagingSenderId: '857987860304',
    projectId: 'doane-c693d',
    storageBucket: 'doane-c693d.appspot.com',
    iosBundleId: 'com.example.doane',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlj7ihQymPP0kY2sn-bROo1S0MxmG67mA',
    appId: '1:857987860304:ios:b03e43c5e5ddf9f2128e55',
    messagingSenderId: '857987860304',
    projectId: 'doane-c693d',
    storageBucket: 'doane-c693d.appspot.com',
    iosBundleId: 'com.example.doane.RunnerTests',
  );
}