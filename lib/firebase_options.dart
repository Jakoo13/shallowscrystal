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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBQEbMLi8M-Z_ibNq87TgpV0nDQ0ECMMx8',
    appId: '1:1053741217645:web:5f556f9c61c37c4a3b8c64',
    messagingSenderId: '1053741217645',
    projectId: 'shallowscrystal',
    authDomain: 'shallowscrystal.firebaseapp.com',
    storageBucket: 'shallowscrystal.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6inicWN9-0Xr4iyAfxqfsXMqyTOt0V8o',
    appId: '1:1053741217645:android:d793092c65ceb7d03b8c64',
    messagingSenderId: '1053741217645',
    projectId: 'shallowscrystal',
    storageBucket: 'shallowscrystal.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjU3U2lbGmLUO7Pnkq6gFwrQCq-rgXTEo',
    appId: '1:1053741217645:ios:e1e6557b2c79d6933b8c64',
    messagingSenderId: '1053741217645',
    projectId: 'shallowscrystal',
    storageBucket: 'shallowscrystal.appspot.com',
    androidClientId: '1053741217645-eh6g590d04cgp5q5i0a05egkols7pr1p.apps.googleusercontent.com',
    iosClientId: '1053741217645-8b0c4r58k8rkg29b65ssa8sl3c3ni82s.apps.googleusercontent.com',
    iosBundleId: 'com.netscaledigital.crystal',
  );
}
