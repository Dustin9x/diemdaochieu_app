import 'package:flutter/material.dart';

class ArchivedArticlesScreen extends StatelessWidget{
  const ArchivedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài viết lưu trữ'),
      ),
      body: const Center(
        child: Text('Tính năng đang được xây dựng, vui lòng quay lại sau')
      ),
    );
  }
}