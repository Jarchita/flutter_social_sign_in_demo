import 'dart:convert';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../logger.dart';
import '../base/base_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

// enum SocialLoginType { fb, google, apple }

class AuthProvider {
  static const String fb = "Facebook";
  static const String google = "Google";
  static const String apple = "Apple";
}

/// Purpose : business logic component for login screen
class LoginBloc extends BaseBloc {
  LoginBloc() : super(InitialState()) {
    _onEvent();
  }

  static String tag = "LoginBloc";

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  // Future<void> _doLogin(
  //   Emitter<BaseState> emit, {
  //     AuthProvider? providerName,
  //       String? token, //required in case of facebook,gmail login
  //   String? appleIdentifier, //required in case of Apple login
  // }) async {
  //   await apiService.authClient!
  //       .doLogin(LoginRequest(
  //     userName: userName,
  //     password: password,
  //     grantType: grantType,
  //     email: email,
  //     token: token,
  //     providerName: providerName,
  //     appleUserIdentifier: appleIdentifier,
  //   ))
  //       .then((value) async {
  //     await saveLoginInfo(value, socialLoginProvider: providerName);
  //     emit(const LoadingState(isLoading: false));
  //     emit(SuccessState(data: value));
  //
  //     //call add token API
  //     await _addDeviceToken();
  //   }).catchError((e) {
  //     Logger.e(tag, e);
  //     if (apiService.isSocketException(e)) {
  //       emit(const ConnectionFailedState());
  //     } else {
  //       emit(FailedState(msg: apiService.getError(e)));
  //     }
  //     emit(const LoadingState(isLoading: false));
  //   });
  // }



  /// Purpose : on event handler
  void _onEvent() {

    ///Social Login
    on<SocialLogin>((event, emit) async {
      emit(const LoadingState());
      try {
        //fb
        if (event.type == AuthProvider.fb) {
          final result = await FacebookAuth.instance.login();
          if (result.status == LoginStatus.success) {
            Logger.d(tag, "User successfully logged in with Facebook");
            final accessToken = result.accessToken!;
            final token = accessToken.token;
            Logger.d(tag, "token: $token");
            Logger.d(tag, "userId: ${accessToken.userId}");
            final user = await FacebookAuth.i.getUserData();
            final email = user["email"];final name =user["name"];
            Logger.d(tag, "email: $email");
            Logger.d(tag, "display name: $name");
           saveLoginInfo(socialLoginProvider: event.type,displayName: name);
          } else {
            if (result.status == LoginStatus.failed) {
              emit(FailedState(msg: result.message));
            }
            Logger.e(tag, "Login Failed");
            Logger.e(tag, " ${result.status} : ${result.message}");
          }
        }

        //google
        else if (event.type == AuthProvider.google) {
          final result = await _googleSignIn.signIn();
          if (result != null) {
            Logger.d(tag, "User successfully logged in with Google");
            final email = result.email;final name=result.displayName;
            Logger.d(tag, "userEmail: $email");
            Logger.d(tag, "display name: $name");
            final auth = await result.authentication;
            final token = auth.idToken;
            Logger.d(tag, "token: $token");
            saveLoginInfo(socialLoginProvider: event.type,displayName: name,email: email);

          }
        }

        //apple
        else if (event.type == AuthProvider.apple) {
          final result = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          Logger.d(tag, "User successfully logged in with Apple");
          //get email from identityToken
          final parsedToken = _parseJwt(result.identityToken!);
          final email = parsedToken["email"];final name=result.givenName;
          Logger.d(tag, "userEmail: $email");
          Logger.d(tag, "authorizationCode: ${result.authorizationCode}");
          Logger.d(tag, "state: ${result.state}");
          Logger.d(tag, "familyName: ${result.familyName}");
          Logger.d(tag, "display name: $name");
          Logger.d(tag, "identityToken: ${result.identityToken}");
          Logger.d(tag, "userIdentifier: ${result.userIdentifier}");
          final identifier = result.userIdentifier;
          Logger.d(tag, "identifier: $identifier");
          saveLoginInfo(socialLoginProvider: event.type,displayName: name,email: email);

          // await _doLogin(emit,
          //     email: email,
          //     grantType: AuthGrantType.externalAuth,
          //     providerName: AuthProvider.apple,
          //     appleIdentifier: identifier);
        }

        emit(const LoadingState(isLoading: false));
      } catch (e) {
        Logger.e(tag, e);
       if (e is SignInWithAppleException) {
          Logger.e(tag, e);
        } else {
          emit(FailedState(msg: e.toString()));
        }

        emit(const LoadingState(isLoading: false));
      }
      return;
    });
  }

  Future<bool> isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    if (email != null) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = prefs.getString("authProvider");
    //fb
    if (provider == AuthProvider.fb) {
      await FacebookAuth.instance.logOut();
    }

    //google
    else if (provider == AuthProvider.google) {
      await _googleSignIn.signOut();
    }
    Logger.d(tag, "$provider : Logged out successfully");
    // await _deleteDeviceToken();
    await prefs.clear();
  }

  Future<void> saveLoginInfo(
      {String? socialLoginProvider,String? email, String? displayName}) async {
    Logger.d(tag, "socialLoginType: $socialLoginProvider");
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("authProvider", socialLoginProvider ?? "");
    } catch (e) {
      Logger.e(tag, e);
      rethrow;
    }
  }

  ///function to parse JWT token
  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    var output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
