import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:stonks/Components/ChartComponent.dart';
import 'package:stonks/Components/OwnedStocksComponent.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';


class StockPage extends StatefulWidget {
  String StockName;
  StockPage({Key?key,required this.StockName}):super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();

}

class _StockPageState extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            ChartComponent(StockName:widget.StockName),
            SizedBox(height: 30,),
            Container(
              height: 70,
              width: 400,
              child:Center(
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Text('\$12000',
                            style:GoogleFonts.anton(
                              color: Colors.black,
                              fontSize: 35,
                              letterSpacing: 3
                            )
                    ),
                    SizedBox(width: 50,),
                    Icon(Icons.arrow_upward,size:40,color: Colors.green,),
                    Text('100 (+0.39%)',
                            style:GoogleFonts.anton(
                              color: Colors.green,
                              fontSize: 20,
                              letterSpacing: 1,
                              
                            )
                    ),
                  ],
                )
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50))
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap:() => {
                    print("Buy")
                  },
                  child: Container(
                    height: 60,
                    width: 180,
                    
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: Center(child: Text("Buy",
                                          style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 20,
                                          ),
                        
                    )),
                  ),
                ),
                InkWell(
                  onTap:() => {
                    print("Sell")
                  },
                  child: Container(
                    height: 60,
                    width: 180,
                    
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: Center(child: Text("Sell",
                                          style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 20,
                                          ),
                        
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            OwnedStocks(StockName:widget.StockName),
          ],
        ),
      ),
    );
    
    
  }
}



class StockData {
  double value=0;
  DateTime date=DateTime(0,0,0);
  StockData({required this.value, required this.date});
}



class ChartComponent extends StatefulWidget {
  String StockName;
  ChartComponent({Key?key,required this.StockName}):super(key: key);
  
  @override
  State<ChartComponent> createState() => _ChartComponentState();
}

class _ChartComponentState extends State<ChartComponent> {

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
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => fetchData(widget.StockName));
  }
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    mounted = false;

  }

  Future<void> fetchData(String ticker) async {
    try {
      String formattedticker = ticker.split(' ')[0]+'.ns';
      print(formattedticker);
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/DrawChart?Symbol=$formattedticker&period=$period'));
      
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
    return  Column(
        children: [
          Container(
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
        ],
      
    );
  }
}

