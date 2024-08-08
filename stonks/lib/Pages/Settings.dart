import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
class StockData {
  double value=0;
  DateTime date=DateTime(0,0,0);
  StockData({required this.value, required this.date});
}

class SettingsPage extends StatefulWidget {
  
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Timer? timer;
  List<dynamic> message=[];
  List<dynamic> DatesList=[];
  List<DateTime> Dates=[];
  List<StockData> Stocks=[];
  String Ticker="";
  int pageval=4;
  String period='1mo';
  bool mounted=true;
  @override
   void initState() {
    super.initState();
    // fetchData("msft");
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => fetchData("BEL.ns"));
  }
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    mounted = false;

  }
  Future<void> fetchData(String ticker) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/DrawChart?Symbol=$ticker&period=$period'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (mounted) {
          setState(() {
          message = data['values'];
          DatesList=data['dates'];
          Dates= DatesList.map((dateTimeString) {return DateTime.parse(dateTimeString).toLocal();}).toList();
          Stocks=List.generate(Dates.length, (index) {
            return StockData(
              value:message[index],
              date: Dates[index]
            );
            
          });
          print(Stocks[0].date);
          
          
        });
        }
        
      } else {
        
        if (mounted)
        setState(() {
          message = [];
        });
      }
    } catch (e) {
      print(e);
      if (mounted)
      setState(() {
        message = [];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Charts"),
        foregroundColor: Colors.white,

      ),
      body: Container(
        child: Column(
          children: [
            
            SfCartesianChart(
              
              
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                
              ),
              
              primaryXAxis: DateTimeAxis(
                rangePadding: ChartRangePadding.normal,
                // intervalType:DateTimeIntervalType.auto,
                dateFormat: DateFormat("yyyy-MM-dd "),
                // maximum: Dates.last.add(Duration(hours:12)),
                
              ),
              primaryYAxis: NumericAxis(
                rangePadding: ChartRangePadding.auto,
                
              ),
              series:<CartesianSeries>[
                AreaSeries<StockData,DateTime>(
                  
                  onPointTap:(pointInteractionDetails) {
                    print(Stocks[pointInteractionDetails.pointIndex??0].date);
                    print(Stocks[pointInteractionDetails.pointIndex??0].value);
                  },
                  dataSource: Stocks,
                  xValueMapper: (StockData stocks,_)=>stocks.date,
                  yValueMapper: (StockData stocks,_)=>stocks.value,
                  borderColor: Color.fromARGB(159, 27, 168, 17),
                  borderWidth: 2,
                  gradient: LinearGradient(colors: <Color>[
                                                          Color.fromARGB(255, 7, 184, 22),
                                                          Color.fromARGB(131, 111, 255, 123),
                                                          Color.fromARGB(0, 111, 255, 123),
                                                           
                                                           ],
                                            stops:[0,0.5,1],
                                            begin: Alignment.topCenter,
                                            end:Alignment.bottomCenter
                                          )

                )
              ]
            ),
          
          ],
        )

      ),
    );
  }
}

