import 'dart:io';

import 'package:diemdaochieu_app/modal/register_success.dart';
import 'package:diemdaochieu_app/screens/forget_pw_screen.dart';
import 'package:diemdaochieu_app/screens/tabs.dart';
import 'dart:convert' show json, utf8;
import 'package:diemdaochieu_app/widgets/my_elevated_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_toggle_tab/helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKeyLogin = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyLogin,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Email",
              fillColor: Colors.white70,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty ||
                  !value.contains('@') ||
                  !value.contains('.')) {
                return 'Email không hợp lệ';
              }
              return null;
            },
            onSaved: (value) {
              _enteredEmail = value!;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Mật khẩu (*)",
              fillColor: Colors.white70,
              suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: Colors.grey[800],
                  ),
                  onPressed: _toggle),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            obscureText: _obscureText,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mật khẩu không được để trống';
              }
              return null;
            },
            onSaved: (value) {
              _enteredPassword = value!;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Quên mật khẩu'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const ForgetPasswordScreen()));
                },
              ),
            ],
          ),
          MyElevatedButton(
            disable: false,
            width: widthInPercent(40, context),
            height: 45,
            onPressed: _submitLogin,
            borderRadius: BorderRadius.circular(40),
            child: const Text(
              'Đăng nhập',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'hoặc',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/facebook.png',
                width: 45,
                height: 45,
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _handleSignIn, // Image tapped
                splashColor: Colors.white10, // Splash color over image
                child: Image.asset(
                  'assets/images/google.png',
                  width: 45,
                  height: 45,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  var _enteredEmail = '';
  var _enteredPassword = '';
  final fcm = FirebaseMessaging.instance;

  void _submitLogin() async {
    final isValid = _formKeyLogin.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKeyLogin.currentState!.save();
    const baseUrl = 'https://api-prod.diemdaochieu.com/auth/signin';
    const storage = FlutterSecureStorage();
    Map<String, String> jsonBody = {
      'username': _enteredEmail,
      'password': _enteredPassword
    };

    try {
      Map<String, String> requestHeaders = {
        'platform': Platform.operatingSystem.toUpperCase(),
        'Content-Type': 'application/json',
      };

      Response response = await post(Uri.parse(baseUrl),
          headers: requestHeaders, body: json.encode(jsonBody));
      final message = json.decode(utf8.decode(response.bodyBytes))['message'];

      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes))['data'];
        String accessToken = result['accessToken'];
        await storage.write(key: 'jwt', value: accessToken);
        await storage.write(key: 'user', value: json.encode(result['user']));
        await fcm.requestPermission();
        final String? tokenNotification = await fcm.getToken();
        print('fcmtoken ${tokenNotification!}');
        _subscribeFirebase(accessToken, tokenNotification!.toString());
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const TabsScreen()),
            (Route<dynamic> route) => false);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                elevation: 0,
                title: const Text('Thông báo'),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  void _subscribeFirebase(String userToken, String fcmToken) async {
    const baseUrl = 'https://api-prod.diemdaochieu.com/user/settings/update';
    const storage = FlutterSecureStorage();
    Map<String, dynamic> jsonBody = {
      'fcmToken': fcmToken,
      'receiveNotification': true
    };
    try {
      Map<String, String> requestHeaders = {
        'x-ddc-token': userToken,
        'platform': Platform.operatingSystem.toUpperCase(),
        'Content-Type': 'application/json',
      };
      Response response = await post(Uri.parse(baseUrl),
          headers: requestHeaders, body: json.encode(jsonBody));
      if (response.statusCode == 200) {
        await storage.write(
            key: "TOKEN_NOTIFICATION", value: fcmToken.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      var userInfo = await _googleSignIn.signIn();
      print(userInfo);
    } catch (error) {
      print(error);
    }
  }
}
