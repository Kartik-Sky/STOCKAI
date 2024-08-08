
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockCard extends StatefulWidget {
  final String Name;
  double stockValue;
  int Rise;
  double difference;
  StockCard({Key? key,this.Name="",this.stockValue=0,this.Rise=1, this.difference=0}):super(key: key);

  @override
  State<StockCard> createState() => _StockCardState(Name:Name,stockValue:stockValue,rise:Rise,difference:difference);
}

class _StockCardState extends State<StockCard> {
  String Name;
  double stockValue;
  int rise;
  double difference;
  _StockCardState({this.Name="",this.stockValue=0,this.rise=1,this.difference=0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      // height: 300,
      width:250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        
      ),
      child:Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              // border:Border.all(color: Colors.green,width: 3)
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Container(
              width: 230,
              height:40,
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(10),
                border:Border(
                  bottom:BorderSide(color: Colors.green,width: 3))
              ),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top:5),
              padding: EdgeInsets.only(top:5,bottom: 5,left:5,right:10),
              child: Text(Name.toUpperCase(),
              textAlign: TextAlign.left,
              
              
              style:GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              fontSize:15,
        
              letterSpacing: 2
              ),
              )
              ),
              
            Container(
              margin: EdgeInsets.only(top:10,left:5),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
                children: [
        
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stockValue.toString(),
                        style:GoogleFonts.ebGaramond(
                          fontSize:29,
                          fontWeight: FontWeight.bold
                        )
                        ),
                      Container(
                        margin: EdgeInsets.only(left:5),
                        child: Text(
                          difference.toString(),
                          
                          style:GoogleFonts.josefinSans(
                            color: const Color.fromARGB(255, 99, 99, 99),
                            fontSize:15
                          )
                        ),
                      )
                    ],
                  ),
                  
                  Flexible(child: Status(rise))
                    
                ],
              )
            )
                   
          ],
        ),
      )
    );
  }
}

Widget Status(rise)

{
  if (rise==0)
  {
    return(
      Icon(Icons.arrow_drop_down,color: Colors.red,size: 60,)
    );
  }
  else if(rise==1)
  {
    return(
      Container(
        padding: EdgeInsets.all(10),
      child: (
        
        Icon(Icons.remove_circle_outline,color: Colors.grey,size: 30,)
      ),
    ));
  }
  return Icon(Icons.arrow_drop_up,color: Colors.green,size: 60,);
}