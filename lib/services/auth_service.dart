import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService extends ChangeNotifier {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static String verifyId = "";

  static Future sendOtp({
    required String phone,
    required Function erroStep,
    required Function nextStep,
  }) async {
    await _firebaseAuth
        .verifyPhoneNumber(
      timeout: const Duration(seconds: 30),
      phoneNumber: "+55$phone",
      verificationCompleted: (phoneAuthCredential) async {
        return;
      },
      verificationFailed: (error) async {
        return;
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyId = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        return;
      },
    )
        .onError((error, stackTrace) {
      erroStep();
    });
  }

  // verificar o otp
  static Future loginWithOtp({required String otp}) async {
    final cred = PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);
    try {
      final user = await _firebaseAuth.signInWithCredential(cred);
      if (user.user != null) {
        return "Sucess";
      } else {
        return "Erro in Oto Login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // function logout
  static Future logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  static gerarUserFirebase() {
    var user = _firebaseAuth.currentUser;
    return user;
  }

  static Future<bool> isLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }

  static signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      debugPrint('fazendo login');
      final user = await _firebaseAuth.signInWithCredential(credential);
      return user;
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      debugPrint('n_cadastrado');
      return 'n_cadastrado';
    } catch (e) {
      debugPrint('erro gmail - $e');
      return "Você não escolheu um e-mail";
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  static String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    try {
      final user = await _firebaseAuth.signInWithCredential(oauthCredential);
      return user;
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  static signInWithEmail(String email) async {
    debugPrint('email digitado é - $email');

    try {
      debugPrint('fazendo login');
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: email);
      return 'Sucess';
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      debugPrint('cadastrando');
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: email);
      return 'Sucess';
    } catch (e) {
      return "Você não escolheu um e-mail";
    }
  }
}
