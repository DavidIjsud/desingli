import 'dart:developer';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/widgets/buttons/primary_button.dart';
import '../../../services/authentication/auth0_authentication.dart';
import 'main_page.dart';

class LoginAuth0Page extends StatefulWidget {
  const LoginAuth0Page({super.key});

  @override
  State<LoginAuth0Page> createState() => _LoginAuth0PageState();
}

class _LoginAuth0PageState extends State<LoginAuth0Page> {
  late final Auth0AuthenticaionViewModel _auth0authenticaionViewModel;

  @override
  void initState() {
    super.initState();
    _auth0authenticaionViewModel = context.read<Auth0AuthenticaionViewModel>();
  }

  Future<void> login() async {
    try {
      var credentials = await _auth0authenticaionViewModel.loginAuth0();
    } catch (e) {
      log("A problem ocurred $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ButtonPrimary(
            isActive: true,
            onPressed: () async {
              login().then((_) {
                Navigator.pop(context);
              });

              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const MainPageMultipleSelection();
              }));
            },
            text: "Auth Login",
            width: MediaQuery.of(context).size.width * 0.5,
            height: 100,
          ),
        ),
      ),
    );
  }
}
