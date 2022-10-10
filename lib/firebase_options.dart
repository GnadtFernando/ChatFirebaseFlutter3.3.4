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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCXCvjz-Cri7q3Zn78xozX41KYFq8krAO8',
    appId: '1:736982929691:android:5d6a67aa71a0e5ca5ac3be',
    messagingSenderId: '736982929691',
    projectId: 'chatflutter-37daf',
    storageBucket: 'chatflutter-37daf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSdIPfiTTJzllA5oeeLA_YsoCXbDvHPa4',
    appId: '1:736982929691:ios:dd22cd987ed01cca5ac3be',
    messagingSenderId: '736982929691',
    projectId: 'chatflutter-37daf',
    storageBucket: 'chatflutter-37daf.appspot.com',
    androidClientId: '736982929691-s12qslp71r8lorllmof9rd2jmeddnqhn.apps.googleusercontent.com',
    iosClientId: '736982929691-bigq9o92n1ssf72o4sperhdnoivvphcl.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatFirebase',
  );
}