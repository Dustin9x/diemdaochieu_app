import 'package:diemdaochieu_app/screens/login_screen.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';

class RegisterSuccessModal extends StatelessWidget {
  const RegisterSuccessModal({super.key, required this.email});

  final String email;

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
      content: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              EneftyIcons.tick_circle_bold,
              size: 50,
              color: Colors.green,
            ),
            const Text(
              "Đăng ký thành công",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top:24,bottom: 12),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Để hoàn tất đăng ký vui lòng xác thực email ",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    children: <TextSpan>[
                      TextSpan(
                        text: email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text:"Vui lòng kiểm tra hộp thư spam nếu không nhận được email",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24,),
            Container(
              width: double.infinity,
              height: 55,
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const LoginScreen(
                        tabIndex: 1,
                      )));
                },
                child: const Text(
                  "Đăng Nhập",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
