import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginData? _data;
  bool _isSignedIn = false;

  Future<String> _onLogin(LoginData data) async {
    final username = data.name.split('@')[0];
    try {
      final res = await Amplify.Auth.signIn(
        username: username,
        password: data.password,
      );
      _isSignedIn = res.isSignedIn;
    } on AuthException catch (e) {
      if (e.message.isNotEmpty) {
        await Amplify.Auth.signOut();
        return 'Problem logging in. Please try again.';
      }
      return '${e.message} - ${e.recoverySuggestion}';
    }
    return '';
  }

  Future<String> _onRecoverPassword(BuildContext context, String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);

      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        Navigator.of(context).pushReplacementNamed(
          '/confirm-reset',
          arguments: LoginData(name: email, password: ''),
        );
      }
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
    return '';
  }

  Future<String> _onSignup(LoginData data) async {
    final username = data.name.split("@")[0];
    try {
      await AmplifyClass.instance.Auth.signUp(
        username:
            username, //username cannot be email as per cognito userpool setting
        password: data.password, //min length: 8
        options: CognitoSignUpOptions(userAttributes: {
          'email': data.name,
        }),
      );
      _data = data;
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'AmpAwesome',
      onLogin: _onLogin,
      onSignup: _onSignup,
      onRecoverPassword: (String email) => _onRecoverPassword(context, email),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(
            _isSignedIn ? '/dashboard' : '/confirm',
            arguments: _data);
      },
    );
  }
}
