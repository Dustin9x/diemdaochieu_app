import 'package:diemdaochieu_app/screens/article_detail.dart';
import 'package:diemdaochieu_app/services/RPIServices.dart';
import 'package:diemdaochieu_app/widgets/rpi/rpi_history_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:intl/intl.dart';

class RPITab extends ConsumerWidget {
  const RPITab({super.key});

  riskNameFromRpi(double rpi) {
    switch (rpi) {
      case (>= 0 && <= 0.99):
        return 'Cơ hội';
      case (>= 1 && <= 1.49):
        return 'Rủi ro thấp';
      case (>= 1.5 && <= 3.49):
        return 'Trung tính';
      case (>= 3.5 && <= 3.99):
        return 'Rủi ro';
      case (>= 4 && <= 5):
        return 'Rủi ro cao';
      default:
        return 'Bình thường';
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    Future<dynamic> getData() async {
      return ref.watch(rpiProvider).getRPI();
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                getData();
              }
              var rpiData = snapshot.data;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text('Cập nhật: ${DateFormat("dd-MM-yyyy").format(DateTime.parse(rpiData['dateTime']))}'),
                      const Spacer(),
                      SizedBox(
                          width: 150, // <-- match_parent
                          height: 30, // <-- match-parent
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ArticleDetail(
                                    articleId: 163,
                                  )));
                            },
                            child: const Text('Tìm hiểu thêm'),
                          )
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedRadialGauge(
                    duration: const Duration(seconds: 1),
                    curve: Curves.elasticOut,
                    radius: 90,
                    value: rpiData['rpi'],
                    builder: (context, child, value) => Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 65),
                          Text(
                            '${value.toStringAsFixed(2)} ĐIỂM',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    axis: const GaugeAxis(
                        min: 0,
                        max: 5,
                        degrees: 240,
                        style: GaugeAxisStyle(
                          thickness: 20,
                          background: Color(0xFFDFE2EC),
                          segmentSpacing: 2,
                        ),
                        progressBar: GaugeProgressBar.basic(
                          color: Colors.transparent,
                        ),
                        pointer: GaugePointer.needle(
                          width: 16,
                          height: 70,
                          borderRadius: 16,
                          color: Color(0xFF193663),
                        ),
                        segments: [
                          GaugeSegment(
                            from: 0,
                            to: 0.5,
                            color: Color.fromARGB(255, 23, 143, 39),
                            cornerRadius: Radius.zero,
                          ),
                          GaugeSegment(
                            from: 0.5,
                            to: 1,
                            color: Color.fromARGB(255, 68, 168, 33),
                            cornerRadius: Radius.zero,
                          ),
                          GaugeSegment(
                            from: 1,
                            to: 1.5,
                            color: Color.fromARGB(255, 159, 225, 20),
                            cornerRadius: Radius.zero,
                          ),
                          GaugeSegment(
                            from: 1.5,
                            to: 2,
                            color: Color.fromARGB(255, 180, 255, 85),
                            cornerRadius: Radius.zero,
                          ),
                          GaugeSegment(
                            from: 2,
                            to: 2.5,
                            color: Color.fromARGB(255, 255, 234, 1),
                            cornerRadius: Radius.zero,
                          ),
                          GaugeSegment(
                            from: 2.5,
                            to: 3,
                            color: Color.fromARGB(255, 255, 199, 1),
                            cornerRadius: Radius.zero,
                          ),
                          GaugeSegment(
                            from: 3,
                            to: 3.5,
                            color: Color.fromARGB(255, 250, 164, 35),
                            cornerRadius: Radius.zero,
                          ),
                          GaugeSegment(
                            from: 3.5,
                            to: 4,
                            color: Color.fromARGB(255, 245, 119, 27),
                            cornerRadius: Radius.zero,
                          ),
                          GaugeSegment(
                            from: 4,
                            to: 4.5,
                            color: Color.fromARGB(255, 237, 85, 0),
                            cornerRadius: Radius.zero,
                          ),
                          GaugeSegment(
                            from: 4.5,
                            to: 5,
                            color: Color.fromARGB(255, 226, 13, 13),
                            cornerRadius: Radius.zero,
                          ),
                        ]),
                  ),
                  Text(
                    riskNameFromRpi(rpiData['rpi']).toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                ],
              );
            },
          ),
          const RPIHistoryChart(),
        ],
      ),
    );
  }
}
