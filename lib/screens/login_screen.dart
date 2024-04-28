import 'package:diemdaochieu_app/modal/register_success.dart';
import 'package:diemdaochieu_app/screens/forget_pw_screen.dart';
import 'package:diemdaochieu_app/screens/tabs.dart';
import 'dart:convert' show json, utf8;
import 'package:diemdaochieu_app/widgets/my_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_toggle_tab/helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();
  late ValueNotifier<int> _tabIndexBasicToggle;
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void initState() {
    super.initState();
    int indexScreen = widget.tabIndex;
    _tabIndexBasicToggle = ValueNotifier(indexScreen);
  }

  bool termCheck = false;

  List<String> get _listTextTabToggle => ["Đăng ký", "Đăng nhập"];

  void _termCheck(bool newValue) => setState(() {
        termCheck = newValue;
      });

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: basicTabToggle()))
    ]));
  }

  Widget basicTabToggle() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 64),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    'assets/images/icon.png',
                    width: 30,
                    height: 30,
                ),
                const SizedBox(width: 8),
                const Text('ĐIỂM ĐẢO CHIỀU',style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),)
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _tabIndexBasicToggle,
            builder: (context, currentIndex, _) {
              return FlutterToggleTab(
                // width in percent
                width: 60,
                borderRadius: 30,
                height: 40,
                selectedIndex: _tabIndexBasicToggle.value,
                selectedBackgroundColors: const [
                  Colors.orangeAccent,
                  Color.fromARGB(255, 251, 196, 2),
                ],
                selectedTextStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                unSelectedTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                labels: _listTextTabToggle,
                selectedLabelIndex: (index) {
                  _tabIndexBasicToggle.value = index;
                },
                isScroll: false,
              );
            },
          ),
          SizedBox(height: heightInPercent(3, context)),
          ValueListenableBuilder(
            valueListenable: _tabIndexBasicToggle,
            builder: (context, currentIndex, _) {
              if (currentIndex == 0) {
                return formRegister();
              } else {
                return formLogin();
              }
            },
          ),
        ],
      );

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
        'platform': 'ANDROID',
        'Content-Type': 'application/json',
      };

      Response response = await post(Uri.parse(baseUrl),
          headers: requestHeaders, body: json.encode(jsonBody));
      final message = json.decode(utf8.decode(response.bodyBytes))['message'];

      if (response.statusCode == 200) {
        showDialog(context: context, builder: (BuildContext dialogContext){
          return RegisterSuccessModal(email: _enteredEmailRegister,);
        });
      }else{
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
      print(e.toString());
    }
  }

  Widget formRegister() => Form(
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
                    !value.contains('@') || !value.contains('.')) {
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
                      _obscureText1
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey[800],
                    ),
                    onPressed: _toggle1
                ),
              ),
              obscureText: _obscureText1,
              controller: passController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Mật khẩu không được để trống';
                }else if(value.length <6 ){
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
                      _obscureText2
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey[800],
                    ),
                    onPressed: _toggle2
                ),
              ),
              obscureText: _obscureText2,
              controller: confirmPassController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Mật khẩu không được để trống';
                } else if(passController.text != confirmPassController.text){
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

  var _enteredEmail = '';
  var _enteredPassword = '';

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
        'platform': 'ANDROID',
        'Content-Type': 'application/json',
      };

      Response response = await post(Uri.parse(baseUrl),
          headers: requestHeaders, body: json.encode(jsonBody));
      final message = json.decode(utf8.decode(response.bodyBytes))['message'];

      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes))['data'];
        await storage.write(key: 'jwt', value: result['accessToken']);
        await storage.write(key: 'user', value: json.encode(result['user']));
        Navigator.of(context).
        pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => const TabsScreen()),(Route<dynamic> route) => false);
      }else{
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

  Widget formLogin() => Form(
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
                    !value.contains('@') || !value.contains('.')) {
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
                    _obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey[800],
                  ),
                  onPressed: _toggle
                ),
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
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
}
