import 'package:diemdaochieu_app/screens/login_screen.dart';
import 'package:diemdaochieu_app/widgets/my_elevated_button.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class PremiumRequestModal extends StatelessWidget {
  const PremiumRequestModal({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textListStyle() {
      return const TextStyle(color: Colors.black87, fontSize: 13);
    }

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
            text: "CHUYÊN MỤC CHỈ DÀNH CHO TÀI KHOẢN ",
            children: <TextSpan>[
              TextSpan(
                  text: "PREMIUM",
                  style: TextStyle(color: Colors.orangeAccent)),
            ]),
      ),
      content: Container(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Nâng cấp/ Gia hạn để nhận ngay:",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Tín hiệu điểm Mua / Bán cổ phiếu',
                style: textListStyle(),
              ),
              leading: const Icon(
                FluentIcons.alert_20_regular,
              ),
              visualDensity: const VisualDensity(vertical: -4),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title:
                  Text('Bài viết phân tích chuyên sâu', style: textListStyle()),
              leading: const Icon(FluentIcons.document_queue_20_regular),
              visualDensity: const VisualDensity(vertical: -4),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Hệ thống xếp hạng và nhận diện cơ hội',
                  style: textListStyle()),
              leading: const Icon(FluentIcons.document_search_16_regular),
              visualDensity: const VisualDensity(vertical: -4),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title:
                  Text('Dự báo chuyển động dòng tiền', style: textListStyle()),
              leading: const Icon(FluentIcons.data_bar_vertical_ascending_16_regular),
              visualDensity: const VisualDensity(vertical: -4),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Lọc cổ phiếu nâng cao', style: textListStyle()),
              leading: const Icon(
                EneftyIcons.filter_outline,
                size: 22,
              ),
              visualDensity: const VisualDensity(vertical: -4),
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
