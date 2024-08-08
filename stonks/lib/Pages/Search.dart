import 'dart:async';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:stonks/Components/Search_Widget.dart';
import 'package:stonks/Components/SearchList.dart' show data;
import 'package:stonks/Pages/StockPage.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //   List<String> data = [
  //   'Apple',
  //   'Banana',
  //   'Cherry',
  //   'Date',
  //   'Elderberry',
  //   'Fig',
  //   'Grapes',
  //   'Honeydew',
  //   'Kiwi',
  //   'Lemon',
  // ];
  List<String> searchResults = [];

  void onQueryChanged(String query) {
    if (query!="")
    setState(() {
      searchResults = data.keys
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
    else{
      setState(() {
      searchResults = [];
    });
    }
  }
  int display=0;
  String selectedStock="LICI";
  


  @override
  Widget build(BuildContext context) {
    if (display==0){
    return SafeArea(
      child:Container(
        child: Column(
          children: [
            
            TextField(
              onChanged: onQueryChanged,
              decoration: InputDecoration(
                labelText: 'Search stocks',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),

            Expanded(
              child:ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                    child:Text(searchResults[index])
                  ),
                  onTap: () => {
                    setState(() => {
                      display=1,
                      selectedStock=searchResults[index]+'.NS'
                    },)
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => StockPage(StockName:searchResults[index])))
                  },
                );
              },
            ),

            ),

          ],
        ),
      )

    );}

    else{
      return Scaffold(
        appBar: AppBar(
          title:Text(selectedStock),
          leading: GestureDetector(
            onTap: ()=>{
              setState(() => {
                display=0,
                selectedStock="",
                searchResults=[]
              },)
            },
            child:Icon(Icons.arrow_back),

          ),
        ),

        body:StockPage(StockName: selectedStock),
        
      );
    }
  }

}

