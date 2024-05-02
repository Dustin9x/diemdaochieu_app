import 'package:diemdaochieu_app/screens/login_form.dart';
import 'package:diemdaochieu_app/screens/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_toggle_tab/helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  late ValueNotifier<int> _tabIndexBasicToggle;
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    int indexScreen = widget.tabIndex;
    _tabIndexBasicToggle = ValueNotifier(indexScreen);
  }

  List<String> get _listTextTabToggle => ["Đăng ký", "Đăng nhập"];

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
                height: 45,
                selectedIndex: _tabIndexBasicToggle.value,
                marginSelected: const EdgeInsets.all(5.0),
                selectedBackgroundColors: const [
                  Colors.orangeAccent,
                  Color.fromARGB(255, 251, 196, 2),
                ],
                selectedTextStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unSelectedTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
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
                return const RegisterForm();
              } else {
                return const LoginForm();
              }
            },
          ),
        ],
      );
}
