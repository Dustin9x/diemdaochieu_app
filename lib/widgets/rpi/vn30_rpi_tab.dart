import 'package:diemdaochieu_app/services/RPIServices.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class VN30RPITab extends ConsumerStatefulWidget {
  const VN30RPITab({super.key});

  @override
  ConsumerState<VN30RPITab> createState() => _VN30RPITabState();
}

class _VN30RPITabState extends ConsumerState<VN30RPITab> {
  late String _selectedDate = '';

  @override
  void initState() {
    super.initState();
    if (DateTime.now().weekday == 7) {
      _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 2)));
    } else if (DateTime.now().weekday == 6) {
      _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
    } else {
      _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    try{
      setState(() {
        if (args.value is DateTime) {
          _selectedDate = DateFormat('yyyy-MM-dd').format(args.value);
          ref.watch(rpiProvider).getVN30RPIHisroty(_selectedDate);
        }
      });
    }catch (e){
      print(e.toString());
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
          rangeSelectionColor: Colors.amber,
          selectionColor: Colors.amber,
          view: DateRangePickerView.month,
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.single,
          initialSelectedDate: DateTime.tryParse(_selectedDate),
      ),
    );
  }

  var betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
    int x,
    double pilates,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates,
          color: pilates > 0 ? Colors.amber : Colors.black87,
          width: 5,
        ),
      ],
    );
  }

  late Map<String, dynamic> vn30RpiHistoryData;
  late var data;

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 8);
    String text;
    text = data[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
      angle: 55,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<dynamic> getData(selectedDate) async {
      return ref.watch(rpiProvider).getVN30RPIHisroty(selectedDate);
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
                  Text(_selectedDate, style: TextStyle(fontSize: 10),),
                  const SizedBox(width: 8),
                  const Icon(EneftyIcons.calendar_outline, size: 15,)
                ],
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1.3,
            child: FutureBuilder(
                future: getData(_selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    getData(_selectedDate);
                  }
                  if(snapshot.data['data'] == null ){
                    return const Center(child: Text('Xin lỗi, không có data, vui lòng chọn ngày khác'));
                  }
                  Map<String, dynamic> response = snapshot.data['data'];
                  final sortedEntries = response.entries.toList()
                    ..sort((a, b) => a.value.compareTo(b.value));
                  final vn30RpiHistoryData = Map.fromEntries(sortedEntries);
                  data = vn30RpiHistoryData.keys.toList();

                  return BarChart(
                    BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: leftTitles,
                              reservedSize: 20,
                            ),
                          ),
                          rightTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 20,
                            ),
                          ),
                        ),
                        barTouchData: BarTouchData(enabled: true),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingVerticalLine: (value) {
                            return const FlLine(
                              color: Color.fromARGB(255, 240, 240, 240),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        barGroups: [
                          for (int i = 0; i < data.length; i++)
                            generateGroupData(i, vn30RpiHistoryData[data[i]])
                        ],
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: 3,
                              color: Colors.red,
                              strokeWidth: 1,
                              dashArray: [10, 10],
                            ),
                            HorizontalLine(
                              y: -3,
                              color: Colors.red,
                              strokeWidth: 1,
                              dashArray: [10, 10],
                            ),
                          ],
                        ),
                        maxY: 5,
                        minY: -5),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
