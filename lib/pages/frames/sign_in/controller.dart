// ignore_for_file: unnecessary_overrides, unused_field, prefer_final_fields

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/values/server.dart';
import 'package:flutter/material.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/routes.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/widgets/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'index.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignInController extends GetxController {
  final state = SignInState();
  SignInController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'openid',
    ],
  );

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  handleSignIn(String type) async {
    // type 1:email，2:google,3:facebook,4 apple,5 phone
    try {
      if (type == "email") {
        Get.toNamed(AppRoutes.EmailLogin);
      } else if (type == "phone") {
        Get.toNamed(AppRoutes.Phone);
      } else if (type == "google") {
        var user = await _googleSignIn.signIn();
        print("user------");
        print(user);
        if (user != null) {
          String? displayName = user.displayName;
          String email = user.email;
          String id = user.id;
          String photoUrl =
              user.photoUrl ?? "${SERVER_API_URL}uploads/default.png";

          LoginRequestEntity loginPageListRequestEntity =
              new LoginRequestEntity();
          loginPageListRequestEntity.avatar = photoUrl;
          loginPageListRequestEntity.name = displayName;
          loginPageListRequestEntity.email = email;
          loginPageListRequestEntity.open_id = id;
          loginPageListRequestEntity.type = 2;
          asyncPostAllData(loginPageListRequestEntity);
        } else {
          toastInfo(msg: 'email login error');
        }

        print("googleAuth--------------------------");
      } else if (type == "facebook") {
        print("facebook--------------------------");
        var user = await signInWithFacebook();
        print(user.user);
        if (user.user != null) {
          String? displayName = user.user?.displayName;
          String? email = user.user?.email;
          String? id = user.user?.uid;
          String? photoUrl = user.user?.photoURL;

          LoginRequestEntity loginPageListRequestEntity =
              new LoginRequestEntity();
          loginPageListRequestEntity.avatar = photoUrl;
          loginPageListRequestEntity.name = displayName;
          loginPageListRequestEntity.email = email;
          loginPageListRequestEntity.open_id = id;
          loginPageListRequestEntity.type = 3;
          asyncPostAllData(loginPageListRequestEntity);
        } else {
          toastInfo(msg: 'facebook login error');
        }
      } else if (type == "apple") {
        print("apple--------------------------");
        var user = await signInWithApple();
        print(user.user);
        if (user.user != null) {
          String displayName = "apple_user";
          String email = "apple@email.com";
          String id = user.user!.uid;
          String photoUrl = "${SERVER_API_URL}uploads/default.png";
          print(photoUrl);
          print("apple uid----");
          print(id);
          LoginRequestEntity loginPageListRequestEntity =
              new LoginRequestEntity();
          loginPageListRequestEntity.avatar = photoUrl;
          loginPageListRequestEntity.name = displayName;
          loginPageListRequestEntity.email = email;
          loginPageListRequestEntity.open_id = id;
          loginPageListRequestEntity.type = 4;
          asyncPostAllData(loginPageListRequestEntity);
        } else {
          toastInfo(msg: 'apple login error');
        }
      }
    } catch (error) {
      toastInfo(msg: 'login error');
      print("signIn--------------------------");
      print(error);
    }
  }

  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    var result = await UserAPI.Login(params: loginRequestEntity);
    print(result);
    if (result.code == 0) {
      await UserStore.to.saveProfile(result.data!);
      EasyLoading.dismiss();
      Get.offAllNamed(AppRoutes.Message);
    } else {
      EasyLoading.dismiss();
      toastInfo(msg: 'internet error');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
