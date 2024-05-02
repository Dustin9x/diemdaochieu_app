import 'dart:io';

import 'package:diemdaochieu_app/modal/register_success.dart';
import 'package:diemdaochieu_app/screens/forget_pw_screen.dart';
import 'package:diemdaochieu_app/screens/login_form.dart';
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

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKeyRegister = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void initState() {
    super.initState();
  }

  bool termCheck = false;

  void _termCheck(bool newValue) => setState(() {
        termCheck = newValue;
      });

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  var _enteredNameRegister = '';
  var _enteredEmailRegister = '';
  var _enteredPhoneRegister = '';
  var _enteredPasswordRegister = '';

  void _submitRegister() async {
    final isValid = _formKeyRegister.currentState!.validate();

    if (!isValid || termCheck == false) {
      return;
    }

    _formKeyRegister.currentState!.save();

    const baseUrl = 'https://api-prod.diemdaochieu.com/auth/signup';
    Map<String, String> jsonBody = {
      'email': _enteredEmailRegister,
      'password': _enteredPasswordRegister,
      'fullName': _enteredNameRegister,
      'phoneNumber': _enteredPhoneRegister
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
        showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return RegisterSuccessModal(
                email: _enteredEmailRegister,
              );
            });
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyRegister,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Họ và tên",
              fillColor: Colors.white70,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onSaved: (value) {
              _enteredNameRegister = value!;
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
              _enteredEmailRegister = value!;
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
              hintText: "Điện thoại",
              fillColor: Colors.white70,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onSaved: (value) {
              _enteredPhoneRegister = value!;
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText1 ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: Colors.grey[800],
                  ),
                  onPressed: _toggle1),
            ),
            obscureText: _obscureText1,
            controller: passController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mật khẩu không được để trống';
              } else if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
            },
            onSaved: (value) {
              _enteredPasswordRegister = value!;
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
              hintText: "Xác nhận mật khẩu (*)",
              fillColor: Colors.white70,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText2 ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: Colors.grey[800],
                  ),
                  onPressed: _toggle2),
            ),
            obscureText: _obscureText2,
            controller: confirmPassController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mật khẩu không được để trống';
              } else if (passController.text != confirmPassController.text) {
                return 'Mật khẩu không trùng khớp';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                value: termCheck,
                onChanged: (bool? value) {
                  _termCheck(value!);
                },
              ),
              const Text(
                'Chấp nhận các điều khoản và điều kiện',
              ), //Text
            ],
          ),
          MyElevatedButton(
            disable: !termCheck,
            width: widthInPercent(40, context),
            height: 45,
            onPressed: termCheck == true ? _submitRegister : null,
            borderRadius: BorderRadius.circular(40),
            child: const Text(
              'Đăng ký',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
