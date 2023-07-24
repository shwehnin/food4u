

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<Map<String, dynamic>> signWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
      
      switch (result.status) {
        case LoginStatus.success:
          //final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
          /*
          final userCredential =
              await _fAuth.signInWithCredential(facebookCredential);*/
           final userData = await FacebookAuth.instance.getUserData();

          return userData;
        case LoginStatus.cancelled:
          return {};
        case LoginStatus.failed:
          return {};
        default:
          return {};
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
