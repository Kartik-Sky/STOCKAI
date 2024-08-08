import 'dart:async';
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


class SensexCard extends StatefulWidget {
  final String Name,Ticker;

  SensexCard({Key?key,required this.Name,required this.Ticker}):super(key: key);

  @override
  State<SensexCard> createState() => _SensexCardState();
}

class _SensexCardState extends State<SensexCard> with AutomaticKeepAliveClientMixin{
  bool isLoading=true;
  double value=0;
  double delta=0;
  double percentage=0;
  Timer? timer;


  @override
  void initState() {
    super.initState();
    if (isLoading==true)
    {
      fetchMarket(widget.Ticker);
      print("Market Fetched");
    }
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => fetchMarket(widget.Ticker));
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  Future<void> fetchMarket(Ticker) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/GetMarketVal?Ticker=$Ticker'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
      if (mounted)
        setState(() {
          value = data['value'];
          delta = data["increase"];
          percentage=data['percentage'];
          print(value);
          isLoading=false;
        });
      } else {
      if (mounted)
        setState(() {
          value = 0;
          isLoading=false;
        });
      }
    } catch (e) {
    if (mounted)
      setState(() {
        print('Error: $e');
        value=0;
        isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:350,
      // height:100,
      margin: EdgeInsets.symmetric(horizontal:10,vertical: 10),
      
      // color:Colors.green.shade500
      decoration:BoxDecoration(
        color:Colors.white,
        boxShadow: [BoxShadow(color:Colors.grey, spreadRadius:1,blurRadius: 10,offset: Offset(2,2))],
        borderRadius: BorderRadius.circular(20),
      ) ,
      padding:EdgeInsets.all(7),
      child:Container(
        margin: EdgeInsets.only(left:20),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex:1,
              child:Column(    
                mainAxisAlignment: MainAxisAlignment.center,  
                children: [
                  // Image.asset("assets/flags/Indian_Flag.png",
                  //   width: 40,
                  // ),
                  Text(
                    widget.Name,
                    style:GoogleFonts.sairaSemiCondensed(
                      fontSize:22,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  Text(
                    widget.Ticker,
                    textAlign: TextAlign.center,
                    style:GoogleFonts.sairaSemiCondensed(
                      fontSize:12,
                      // fontWeight: FontWeight.bold,
                      
                    ),

                  )
                ],
              )
            ),
            Expanded(
              flex:2,
              child: Container(
                child:Column(
                  crossAxisAlignment:CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                  
                  Container(
                    margin: EdgeInsets.only(left:15),
                    child: Text(value.toString(),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.sairaSemiCondensed(
                      color:Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w800
                      ),
                      
                      ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_drop_up,color:Colors.green,size:40),
                        Container(
                          padding: EdgeInsets.only(left:15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Text(delta.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sairaSemiCondensed(
                                color:Colors.green,
                                fontSize: 17,
                                fontWeight: FontWeight.w700
                                ),
                                
                                ),
                              Text("("+percentage.toString()+"%)",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sairaSemiCondensed(
                                color:Colors.green,
                                fontSize: 17,
                                fontWeight: FontWeight.w700
                                ),
                                
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ]
                )
              )
            )
          ],
        )
      )
    );
    
  }
  @override
  bool get wantKeepAlive => true;

}