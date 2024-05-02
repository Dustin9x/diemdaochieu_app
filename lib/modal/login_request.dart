import 'package:diemdaochieu_app/screens/login_form.dart';
import 'package:diemdaochieu_app/screens/login_screen.dart';
import 'package:diemdaochieu_app/widgets/my_elevated_button.dart';
import 'package:flutter/material.dart';

class LoginRequestModal extends StatelessWidget {
  const LoginRequestModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 10.0,
      ),
      title: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
            style: TextStyle(
                color: Colors.black87,
                fontSize: 16),
            text: "Bạn hãy đăng nhập để tiếp tục nhé"),
      ),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoginForm(),
              // Container(
              //   width: double.infinity,
              //   height: 55,
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: const Text("Quay lại"),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
