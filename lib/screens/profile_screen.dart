import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Của tôi'),
        actions: [
          TextButton(child: const Text('Đăng ký'), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: ElevatedButton(
              child: const Text('Đăng nhập'),
              onPressed: () {},
            ),
          ),
        ],
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
                  const Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 60, left: 10, right: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 170,
                      child: Column(
                        children: [
                          SizedBox(height: 70),
                          Text(
                            'Username',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          Text('Đang là thành viên'),
                          Text('Hạn sử dụng'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15),
                    child: const CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.all(4), // Border radius
                        child: ClipOval(
                          child: Image(
                            image: NetworkImage('https://i.pravatar.cc/100'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                icon: const Icon(EneftyIcons.setting_2_outline),
                                label: const Text('Cài đặt ứng dụng'),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                icon: const Icon(EneftyIcons.message_question_outline),
                                label: const Text('Hướng dẫn sử dụng'),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                icon: const Icon(EneftyIcons.tick_circle_outline),
                                label: const Text('Bình chọn'),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
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
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                icon: const Icon(EneftyIcons.message_outline),
                                label: const Text('Zalo: 0933 721 095'),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                icon: const Icon(Icons.facebook_outlined),
                                label: const Text('Fanpage: diemdaochieu'),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                icon: const Icon(EneftyIcons.call_outline),
                                label: const Text('Hotline: 0389 0787 69'),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
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
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: () {},
                child: const Text('Đăng xuất'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
