import 'package:diemdaochieu_app/services/RPIServices.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RPIHistoryChart extends ConsumerStatefulWidget {
  const RPIHistoryChart({super.key});

  @override
  ConsumerState<RPIHistoryChart> createState() => _RPIHistoryChartState();
}

class _RPIHistoryChartState extends ConsumerState<RPIHistoryChart> {
  List<Color> amberGradientColors = [
    Colors.amber.withOpacity(0.5),
    Colors.amber.withOpacity(0.1),
    Colors.transparent
  ];
  List<Color> blackGradientColors = [
    Colors.black.withOpacity(0.5),
    Colors.black.withOpacity(0.1),
    Colors.transparent
  ];

  bool showAvg = false;

  late List<dynamic> rpiHistoryData;


  late String _from = '';
  late String _to = '';
  late String _range = '';

  @override
  void initState() {
    super.initState();
    _from = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)));
    _to = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _range = '${DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 30)))} -'
        ' ${DateFormat('dd-MM-yyyy').format(DateTime.now())}';
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    try{
      setState(() {
        if (args.value is PickerDateRange) {
          _from = DateFormat('yyyy-MM-dd').format(args.value!.startDate);
          _to = DateFormat('yyyy-MM-dd').format(args.value!.endDate);
          _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          // ignore: lines_longer_than_80_chars
              ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
          ref.watch(rpiProvider).getRPIHisroty(_from, _to);
        }
      });
    }catch (e){
      print (e.toString());
    }

  }

  Widget getDateRangePicker() {
    return Card(
      child: SfDateRangePicker(
        backgroundColor: Colors.white,
        showActionButtons: true,
        onSubmit: (value) {
          Navigator.pop(context);
        },
        cancelText: 'Đặt lại',
        confirmText: 'Xác nhận',
        rangeSelectionColor: const Color.fromARGB(255, 237, 242, 247),
        startRangeSelectionColor: Colors.amber,
        endRangeSelectionColor: Colors.amber,
        selectionColor: Colors.amber,
        view: DateRangePickerView.month,
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.range,
        initialSelectedRange: PickerDateRange(
            DateTime.tryParse(_from),
            DateTime.tryParse(_to)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<dynamic> getData(_from, _to) async {
      return ref.watch(rpiProvider).getRPIHisroty(_from, _to);
    }

    return FutureBuilder(
      future: getData(_from, _to),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          getData(_from, _to);
        }
        rpiHistoryData = snapshot.data.map((e) => e).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                getDateRangePicker(),
                              ],
                            ));
                      });
                },
                child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_range, style: TextStyle(fontSize: 10),),
                        const SizedBox(width: 8),
                        const Icon(EneftyIcons.calendar_outline, size: 15,)
                      ],
                    ),
              ),
            ),
            AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 12,
                  bottom: 12,
                ),
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
    );

    return SideTitleWidget(
      space: meta.appliedInterval,
      axisSide: meta.axisSide,
      angle: 75,
      child: Padding(
        padding: const EdgeInsets.only(right: 6, top: 6),
        child: Text(DateFormat("dd-MM-yy").format(DateTime.parse(rpiHistoryData[value.toInt()]['date'])), style: style),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    switch ((2 * value).floorToDouble() / 2) {
      case 0:
        text = '';
        break;
      case 0.5:
        text = '0.5';
        break;
      case 1:
        text = '1.0';
        break;
      case 1.5:
        text = '1.5';
        break;
      case 2:
        text = '2.0';
        break;
      case 2.5:
        text = '2.5';
        break;
      case 3:
        text = '3.0';
        break;
      case 3.5:
        text = '3.5';
        break;
      case 4:
        text = '4.0';
        break;
      case 4.5:
        text = '4.5';
        break;
      case 5:
        text = '5.0';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (value) {
              bool first = true;
              String rpiDate = '';
              return value.map((barSpot) {
                for (int i = 0; i < rpiHistoryData.length; i++) {
                  rpiDate = DateFormat("dd-MM-yyyy").format(DateTime.parse(rpiHistoryData[barSpot.spotIndex]['date']));
                }
                if (first) {
                  first = false;
                  return LineTooltipItem(
                    '$rpiDate\n',
                    const TextStyle(fontSize: 12, height: 2),
                    children: [
                      TextSpan(
                        text: 'RPI: ${barSpot.y}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          height: 0,
                        ),
                      ),
                    ],
                  );
                } else {
                  first = true;
                  return LineTooltipItem(
                      'MA5: ${barSpot.y}',
                      const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ));
                }
              }).toList();
            },
            getTooltipColor: (touchedSpot) => Colors.white,
            tooltipBorder: const BorderSide(color: Colors.grey, width: 1),
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipPadding: const EdgeInsets.all(6.0)
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 0.5,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 240, 240, 240),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 240, 240, 240),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 4,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 20,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 1,
            color: Colors.red,
            strokeWidth: 1,
            dashArray: [10, 10],
          ),
          HorizontalLine(
            y: 4,
            color: Colors.red,
            strokeWidth: 1,
            dashArray: [10, 10],
          ),
        ],
      ),
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < rpiHistoryData.length; i++)
              FlSpot(i.toDouble(), rpiHistoryData[i]['rpi']),
          ],
          isCurved: true,
          color: Colors.amber,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
        LineChartBarData(
          spots: [
            for (int i = 0; i < rpiHistoryData.length; i++)
              FlSpot(i.toDouble(), rpiHistoryData[i]['ma5']),
          ],
          isCurved: true,
          color: Colors.black,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}
