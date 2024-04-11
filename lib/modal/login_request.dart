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
                fontSize: 20,
                fontWeight: FontWeight.bold),
            text: "VUI LÒNG ĐĂNG NHẬP ĐỂ TIẾP TỤC NHÉ"),
      ),
      content: Container(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),

            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.all(8.0),
              child: MyElevatedButton(
                borderRadius: BorderRadius.circular(40),
                height: 50,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Nâng Cấp / Gia Hạn Ngay"),
              ),
            ),
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
