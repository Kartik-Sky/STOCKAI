import 'dart:async';
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:stonks/Pages/HomePage.dart';
import 'package:stonks/Pages/MarketPage.dart';
import 'package:stonks/Pages/Portfolio.dart';
import 'package:stonks/Pages/Search.dart';
import 'package:stonks/Pages/Settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> Pages =[
    HomePage(),
    SearchPage(),
    MarketPage(),
    PortfolioPage(),
    SettingsPage()
  ];


  Timer? timer;
  String message = 'Fetching data...';
  String Ticker="";
  int pageval=4;

  @override
   void initState() {
    super.initState();
    // fetchData("YATRA");
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => fetchData(Ticker));
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  Future<void> fetchData(String ticker) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000//GetStock?Symbol=$ticker'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (mounted)
        setState(() {
          message = data['value'].toString();
        });
      } else {
        
        if (mounted)
        setState(() {
          message = '';
        });
      }
    } catch (e) {
      
      if (mounted)
      setState(() {
        message = 'Error: $e';
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    
    void _bottomNavigationBarTapped(value){
      if (mounted)
      setState(() {pageval=value;});}


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home:Scaffold(

        appBar: AppBar(
          title:Text("Welcome, Kartik",
          style:GoogleFonts.merriweather(
            fontSize: 20,
            fontWeight: FontWeight.w500
          )
          
          ),
          actions: [
            Container(
              margin:EdgeInsets.only(right: 20),              
              child: Icon(Icons.person,
                size:30
              )

              )
          ],
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 1,
          // leading: Icon(Icons.person)
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: pageval,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home,size:30),label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search,size:30),label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart,size:30),label: "Market"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.money_dollar,size:32),label: "Portfolio"),
            BottomNavigationBarItem(icon: Icon(Icons.settings,size:30),label: "Settings"),
          ],
          onTap:_bottomNavigationBarTapped,
          selectedItemColor: Colors.green,
        ),
        body:SafeArea(
          child: Pages.elementAt(pageval)
        )
      )
    );
  }
}
