import 'package:diemdaochieu_app/modal/register_success.dart';
import 'package:diemdaochieu_app/screens/tabs.dart';
import 'dart:convert' show json, utf8;
import 'package:diemdaochieu_app/widgets/my_elevated_button.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_toggle_tab/helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() {
    return _ForgetPasswordScreenState();
  }
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formResetPw = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  var _enteredRegEmail = '';

  void _submitLogin() async {
    final isValid = _formResetPw.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formResetPw.currentState!.save();

    String baseUrl = 'https://api-prod.diemdaochieu.com/auth/forget-password/?platform=ANDROID&email=$_enteredRegEmail';
    Map<String, String> jsonBody = {
      'email': _enteredRegEmail,
    };
    try {
      Map<String, String> requestHeaders = {
        'platform': 'ANDROID',
        'Content-Type': 'application/json',
      };

      Response response = await post(Uri.parse(baseUrl), headers: requestHeaders, body:json.encode(jsonBody));
      final message = json.decode(utf8.decode(response.bodyBytes))['message'];

      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes))['data'];
        showDialog(context: context, builder: (BuildContext dialogContext){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(children: <Widget>[
          SvgPicture.asset(
            'assets/images/loginbg.svg',
            alignment: Alignment.center,
            width: double.maxFinite,
            height: double.maxFinite,
            fit: BoxFit.cover,
          ),
          Center(
              child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
            child: Form(
              key: _formResetPw,
              child: Column(
                children: [
                  const Icon(
                    EneftyIcons.info_circle_bold,
                    size: 50,
                    color: Colors.indigoAccent,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Quên mật khẩu",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Vui lòng nhập email đăng ký để lấy lại mật khẩu",
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Email",
                      fillColor: Colors.white70,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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
                      _enteredRegEmail = value!;
                    },
                  ),
                  const SizedBox(height: 40),
                  MyElevatedButton(
                    disable: false,
                    width: widthInPercent(50, context),
                    height: 45,
                    onPressed: _submitLogin,
                    borderRadius: BorderRadius.circular(40),
                    child: const Text(
                      'Gửi mật khẩu mới',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ]));
  }
}
