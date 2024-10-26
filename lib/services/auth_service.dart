import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  static Future logout() async {
    await _googleSignIn.signOut();
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

  static Future<String> signInWithGoogle() async {
    try {
      // Iniciar o processo de login
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return "Cancelado pelo usuário";
      }

      // Obter os detalhes da autenticação
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Criar credencial do Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Fazer login no Firebase
      final UserCredential userCredential = 
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        return "Sucess";
      } else {
        return "Erro no login com Google";
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Erro FirebaseAuth: ${e.message}');
      return e.message ?? "Erro no login com Google";
    } catch (e) {
      debugPrint('Erro geral: $e');
      return "Erro no processo de login com Google";
    }
  }

  static signInWithEmail(String email) async {
    debugPrint('email digitado é - $email');

    try {
      debugPrint('fazendo login');
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: email);
      return 'Sucess';
    } on FirebaseAuthException {
      debugPrint('cadastrando');
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: email);
      return 'Sucess';
    } catch (e) {
      return "Você não escolheu um e-mail";
    }
  }
}