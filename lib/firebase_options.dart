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
    apiKey: 'AIzaSyBmJfYhwRk66QMb90uLIp6OsQl1tiVhgOU',
    appId: '1:243938927337:web:ff12623ad2913c0e428678',
    messagingSenderId: '243938927337',
    projectId: 'universite-69406',
    authDomain: 'universite-69406.firebaseapp.com',
    storageBucket: 'universite-69406.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpaUMHY7fND3-3rMSgnnhSsvZtubrwuJg',
    appId: '1:243938927337:android:3a8d39cd70e68926428678',
    messagingSenderId: '243938927337',
    projectId: 'universite-69406',
    storageBucket: 'universite-69406.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBWM8i8PInULD7s1gYjJXlf07u83DR1N4',
    appId: '1:243938927337:ios:398784c05ea11724428678',
    messagingSenderId: '243938927337',
    projectId: 'universite-69406',
    storageBucket: 'universite-69406.appspot.com',
    iosBundleId: 'com.example.studentPresence',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBBWM8i8PInULD7s1gYjJXlf07u83DR1N4',
    appId: '1:243938927337:ios:398784c05ea11724428678',
    messagingSenderId: '243938927337',
    projectId: 'universite-69406',
    storageBucket: 'universite-69406.appspot.com',
    iosBundleId: 'com.example.studentPresence',
  );
}
