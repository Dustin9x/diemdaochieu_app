import 'package:flutter/material.dart';

class Articles extends StatelessWidget {
  const Articles({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      color: Colors.white,
      elevation: 0,
      child: InkWell(
        onTap: (){},
        child: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8), // Image border
                child: SizedBox.fromSize(
                  child: Image.network(
                    'https://i.pravatar.cc/100',
                    width: 110,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nỗi lo tiền bạc khi Công chúa Nhật lấy thường dân Nỗi lo tiền bạc khi Công chúa Nhật lấy thường dân',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color:
                          Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Text('DDC Trả phí', style: TextStyle(fontSize: 11),),
                    ),
                    SizedBox(height: 6),
                    const Row(
                      children: [
                        Text('7 phut',style: TextStyle(fontSize: 11)),
                        SizedBox(width: 24),
                        Icon(Icons.thumb_up_alt_outlined),
                        SizedBox(width: 4),
                        Text('99',style: TextStyle(fontSize: 11)),
                        SizedBox(width: 24),
                        Icon(Icons.chat_bubble_outline),
                        SizedBox(width: 4),
                        Text('99',style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
