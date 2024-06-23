import 'dart:developer';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:designli/components/viewmodel/based_view_model.dart';

class Auth0AuthenticaionViewModel extends BaseViewModel {
  final Auth0 _auth0;

  Auth0AuthenticaionViewModel({required Auth0 auth0}) : _auth0 = auth0;

  Future<bool> loginAuth0() async {
    try {
      WebAuthentication webAuthentication =
          _auth0.webAuthentication(scheme: 'demo');

      await webAuthentication.login(
          useHTTPS: true,
          redirectUrl:
              'demo://dev-iuvrinxum1bpqk01.us.auth0.com/android/com.example.designli/callback');
      log("Authenticated");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logoutAuth0() async {
    WebAuthentication webAuthentication =
        _auth0.webAuthentication(scheme: 'demo');
    await webAuthentication.logout();
  }
}
