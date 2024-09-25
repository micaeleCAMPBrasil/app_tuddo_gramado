import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);
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
    //try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    /*AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      //final user = await _firebaseAuth.signInWithCredential(credential);
      //if (user.user != null) {
        return "Sucess";
      /*} else {
        return "Erro";
      }*/
    } on FirebaseAuthException catch (e) {
      return e.message.toString();*/
    try {
      debugPrint('fazendo login');
      await _firebaseAuth.signInWithEmailAndPassword(
          email: googleUser!.email, password: googleUser.email);
      // ignore: unrelated_type_equality_checks

      /*if (cred.hashCode == '') {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: googleUser!.email, password: googleUser.email);
    }*/
      return 'Sucess';
    // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      debugPrint('cadastrando');
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: googleUser!.email, password: googleUser.email);
      return 'Sucess';
    } catch (e) {
      return "Você não escolheu um e-mail";
    }
  }
}
