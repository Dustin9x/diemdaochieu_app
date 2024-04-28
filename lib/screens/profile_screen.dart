import 'dart:convert' show json;
import 'package:diemdaochieu_app/screens/article_detail.dart';
import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:intl/intl.dart';
import 'package:diemdaochieu_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:diemdaochieu_app/widgets/custom_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var storage = const FlutterSecureStorage();
  var userInfo;

  loginState() async {
    if (await storage.read(key: "user") != null) {
      isLoggedIn = true;
      var user = await storage.read(key: 'user');
      userInfo = await json.decode(user!);
    }
  }
  bool isLoggedIn = false;

  Future deleteAuthAll() async {
    await storage.deleteAll();
    setState(() {
      isLoggedIn = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var dialog = CustomAlertDialog(
        title: "Đang đăng xuất",
        message: "Bạn có muốn đăng xuất khỏi Điểm Đảo Chiều?",
        positiveBtnText: 'Xác nhận',
        negativeBtnText: 'Hủy',
        onPostivePressed: deleteAuthAll,
        onNegativePressed: () {
          Navigator.of(context).pop();
        });

    return FutureBuilder(
        future: loginState(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return isLoggedIn
              ? Scaffold(
            appBar: AppBar(
              title: const Text('Của Tôi'),
              surfaceTintColor: Colors.white,
              //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            backgroundColor: const Color.fromARGB(20, 0, 0, 0),
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height*1.1,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Card(
                          elevation: 0,
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 60, left: 10, right: 10),
                          child: SizedBox(
                            width: double.infinity,
                            height: 170,
                            child: Column(
                              children: [
                                const SizedBox(height: 70),
                                Text(
                                  userInfo['fullName'],
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                RichText(
                                  text: TextSpan(
                                    text: 'Đang là thành viên: ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: userInfo['currentPackage']['packageType'],
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Hạn sử dụng: ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      if (userInfo['currentPackage']['packageType'] == "FREE")
                                        const TextSpan(
                                            text: "Mãi Mãi",
                                            style: TextStyle(fontWeight: FontWeight.bold))
                                      else TextSpan(
                                        text: DateFormat("dd-MM-yyyy").format(DateTime.parse(userInfo['currentPackage']['endDate']),),
                                        style: const TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 15),
                          child: CircleAvatar(
                            radius: 52,
                            backgroundColor: AppUtils.colorPackage(userInfo['currentPackage']['packageType']),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundImage: userInfo['imageUrl'] != null ? NetworkImage(userInfo['imageUrl']) : const NetworkImage('https://i.pravatar.cc/100'),
                                radius: 44,
                              ) ,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    myAction(),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => dialog);
                      },
                      child: const Text('Đăng xuất'),
                    ),
                  ],
                ),
              ),
            ),
          )
              : Scaffold(
            appBar: AppBar(
                title: const Text('Của Tôi'),
                surfaceTintColor: Colors.white,
                actions: profileAction()
              //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            backgroundColor: const Color.fromARGB(20, 0, 0, 0),
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Card(
                          elevation: 0,
                          color: Colors.white,
                          margin: const EdgeInsets.only(
                              top: 60, left: 10, right: 10),
                          child: SizedBox(
                            width: double.infinity,
                            height: 170,
                            child: Column(
                              children: [
                                const SizedBox(height: 70),
                                const Text(
                                  'CHƯA ĐĂNG NHẬP',
                                  style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                RichText(
                                  text: TextSpan(
                                    text: 'Đang là thành viên: ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Chưa đăng nhập',
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Hạn sử dụng: ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Chưa có',
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 15),
                          child: CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            child: const CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
                                radius: 44,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    myAction(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  List<Widget> profileAction() => [
    SizedBox(
      height: 35,
      child: TextButton(
          child: const Text('Đăng ký'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => const LoginScreen(
                  tabIndex: 0,
                )));
          }),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: SizedBox(
        height: 35,
        child: ElevatedButton(
          child: const Text('Đăng nhập'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => const LoginScreen(
                  tabIndex: 1,
                )));
          },
        ),
      ),
    ),
  ];

  Widget myAction() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CÀI ĐẶT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            alignment: Alignment.centerLeft,
                          ),
                          icon: const Icon(EneftyIcons.setting_2_outline),
                          label: const Text('Cài đặt ứng dụng'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            alignment: Alignment.centerLeft,
                          ),
                          icon:
                          const Icon(EneftyIcons.message_question_outline),
                          label: const Text('Hướng dẫn sử dụng'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const ArticleDetail(
                                    articleId: 801
                                )));
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            alignment: Alignment.centerLeft,
                          ),
                          icon: const Icon(EneftyIcons.tick_circle_outline),
                          label: const Text('Bình chọn'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            alignment: Alignment.centerLeft,
                          ),
                          icon: const Icon(EneftyIcons.info_circle_outline),
                          label: const Text('Về chúng tôi'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LIÊN HỆ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            alignment: Alignment.centerLeft,
                          ),
                          icon: const Icon(EneftyIcons.message_outline),
                          label: const Text('Zalo: 0933 721 095'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            alignment: Alignment.centerLeft,
                          ),
                          icon: const Icon(Icons.facebook_outlined),
                          label: const Text('Fanpage: diemdaochieu'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            alignment: Alignment.centerLeft,
                          ),
                          icon: const Icon(EneftyIcons.call_outline),
                          label: const Text('Hotline: 0389 0787 69'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            alignment: Alignment.centerLeft,
                          ),
                          icon: const Icon(Icons.mail_outline),
                          label: const Text('Email: diemdaochieu@gmail.com'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
