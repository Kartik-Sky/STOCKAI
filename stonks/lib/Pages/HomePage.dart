import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stonks/Components/MarketCards.dart';
import 'package:stonks/Components/NewsCards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var conversion={
    'SENSEX':"SENSEX:INDEXBOM",
    'BSECG':"S&P BSE - CAPITAL GOODS",
    'N50':"NIFTY_50",
    'N50B':"NIFTY_BANK",
    'S&PBSE':"S&P BSE - 500",
    'S&PBSEM':"S&P BSE Midcap",
    'NASDAQ':"NASDAQ"

  };
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        
        child: Container(
          margin: EdgeInsets.only(left: 10,right:10,top:10),
          child: Column(
            children: <Widget>[
              // Asset Values
              Container(
          
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(

                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        
                        "Your Holdings",
                        
                        style: GoogleFonts.titilliumWeb(
                          fontSize: 20,
                          color: Color.fromARGB(255, 60, 60, 60)
                        ),
                      ),
                    ),
                    Text(
                      "\$2,93,000.00",
                      style: GoogleFonts.openSans(
                        fontSize:45
                      ),
                    ),
                    Container(
                      padding:EdgeInsets.only(bottom: 35),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1,color:Color.fromARGB(73, 0, 0, 0)))
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.arrow_upward,color: Colors.green,),
                          Text("19.61%",
                          style: GoogleFonts.ptSans(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold
                          )
                          ,)
                        ],
                      )
                    )
                  ],
                )
                
              ),
      
              //Sensex, Nifty, Etc.
              Container(
                // height: 200,
                margin: EdgeInsets.only(top:15),
                padding: EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1,color:Color.fromARGB(73, 0, 0, 0)))
                ),
                child:Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      alignment: Alignment.centerLeft,
                      // child:Text("Market Information",style:GoogleFonts.noticiaText(
                      //   fontSize:40,
      
                      // )),
                    ),
                    Container(
                      height: 170,
                      
                      // child: ListView(
                        
                      //   scrollDirection: Axis.horizontal,
                      //   children: [
                      //     SensexCard(Name: "SENSEX",Ticker:"SENSEX"),
                      //     SensexCard(Name: conversion['SENSEX']??"",Ticker:"SENSEX"),
                      //   ],
                      // ),
                      child: Container(
                        // margin: EdgeInsets.all(10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: conversion.keys.length,
                          itemBuilder: (context, index) {
                            return SensexCard(Name: conversion[conversion.keys.elementAt(index)]??"",Ticker:conversion.keys.elementAt(index));
                          }),
                      ),
                      
                    ),
                  ],
                )
              ),
              
      
              // News Headlines
              Container(
                // height: 200,
                margin: EdgeInsets.only(top:15),
                padding: EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1,color:Color.fromARGB(73, 0, 0, 0)))
                ),
                child:Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      alignment: Alignment.centerLeft,
                      child:Text("Top News Picks",style:GoogleFonts.noticiaText(
                        fontSize:40,
      
                      )),
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView(
                        
                        scrollDirection: Axis.horizontal,
                        children: [
                          NewsCard(),
                          NewsCard(),
                          NewsCard(),
                          NewsCard()
                        ],
                      ),
                    ),
                  ],
                )
              )
            
              
            ],
          ),
        ),
      ),
    );
  }
}
