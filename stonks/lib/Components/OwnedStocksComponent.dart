import 'package:flutter/material.dart';

class OwnedStocks extends StatefulWidget {
  String StockName;
  OwnedStocks({Key?key,required this.StockName}):super(key: key);

  @override
  State<OwnedStocks> createState() => _OwnedStocksState();
}

class _OwnedStocksState extends State<OwnedStocks> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          color: Colors.white,
          child: DataTable(
            border: TableBorder.symmetric(),
            columns: [
              DataColumn(label: Text("ID")),
              DataColumn(label: Text("Buying Date")),
              DataColumn(label: Text("Buying Price")),
              DataColumn(label: Text("Shares")),
              DataColumn(label: Text("Holding Value")),
              DataColumn(label: Text("Delta"))
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text("1")),
                DataCell(Text("07-08-2024")),
                DataCell(Text("2000")),
                DataCell(Text("25")),
                DataCell(Text("100")),
                DataCell(Text("100")),
              ]),
              DataRow(cells: [
                DataCell(Text("2")),
                DataCell(Text("07-08-2024")),
                DataCell(Text("2000")),
                DataCell(Text("25")),
                DataCell(Text("100")),
                DataCell(Text("100")),
              ]),
              
            ],
            
          )
        ),
      ),
    );
  }
}