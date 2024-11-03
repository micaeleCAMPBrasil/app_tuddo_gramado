import 'package:app_tuddo_gramado/data/models/usuario.dart';
import 'package:app_tuddo_gramado/data/php/functions.dart';
import 'package:app_tuddo_gramado/data/php/http_client.dart';
import 'package:app_tuddo_gramado/data/stores/user_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService extends ChangeNotifier {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // apple sign in - inicio

  // listen to auth changes
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  // get user email
  String getUserEmail() => _firebaseAuth.currentUser?.email ?? "User";

  // apple login method
  Future<UserCredential?> signInWithApple() async {
    final UsuarioStore storeUser = UsuarioStore(
      repository: IFuncoesPHP(
        client: HttpClient(),
      ),
    );

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential usercred =
          await _firebaseAuth.signInWithCredential(oAuthCredential);

      User? user = usercred.user;

      Usuario usuario = Usuario(
          uid: user!.uid,
          tokenAlert: '',
          nome: user.displayName.toString(),
          username: user.email.toString(),
          email: user.email.toString(),
          telefone: '',
          photo: '',
          data: '');

      await storeUser.updatenew(usuario);
      return await _firebaseAuth.signInWithCredential(oAuthCredential);
    } catch (e) {
      print("Erro no Login com Apple: $e");
      return null;
    }
  }
  // apple sign in - final

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
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];
      GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: scopes,
      ).signIn();

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
      debugPrint('n_cadastrado');
      return 'n_cadastrado';
    } catch (e) {
      debugPrint('erro gmail - $e');
      return "Você não escolheu um e-mail";
    }
  }

  static signInWithEmail(String email) async {
    debugPrint('email digitado é - $email');

    try {
      debugPrint('fazendo login');
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: email);
      return 'Sucess';
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      debugPrint('cadastrando');
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: email);
      return 'Sucess';
    } catch (e) {
      return "Você não escolheu um e-mail";
    }
  }
}
