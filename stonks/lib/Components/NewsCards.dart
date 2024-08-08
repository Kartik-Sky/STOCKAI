import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatefulWidget {
  const NewsCard({super.key});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> with AutomaticKeepAliveClientMixin{
  String Headline="Not Found";
  String Image_path="https://www.livemint.com/lm-img/img/2023/08/27/600x338/2-0-92302946-India-Markets1-4C-0_1681818756364_1693102727927.jpg";
  String Link = "";
  bool isLoading=true;
  @override
  void initState() {
    super.initState();
    if (isLoading==true)
    {
      fetchNews();
      print("News Fetched");
    }
    // timer = Timer.periodic(Duration(seconds: 30), (Timer t) => fetchNews(Ticker));
  }
  Future<void> fetchNews() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/GetNews'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted)
        setState(() {
          Headline = data['Headline'].toString();
          Image_path = data["image"];
          Link=data['Link'];
          print(Headline);
          isLoading=false;
        });
      } else {
        if (mounted)
        setState(() {
          Headline = 'No output';
          isLoading=false;
        });
      }
    } catch (e) {
      if (mounted)
      setState(() {
        Headline = 'Error: $e';
        isLoading=false;
      });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print("Could Not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    return GestureDetector(
        onTap:()=>_launchURL(Link),
      child: Container(
        decoration: BoxDecoration(
          color:Colors.green,
          image: DecorationImage(
            
            image: NetworkImage(Image_path)
            ,fit:BoxFit.cover,
          )
          
      
        ),
        width:300,
        margin:EdgeInsets.only(right:10),
        child:Container(
          
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
          gradient:LinearGradient(begin: Alignment.bottomRight,
          stops:const [0.1,0.9,0.99],
          colors: [
            Colors.black.withOpacity(.8),
            Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
          ])),
          child:Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              isLoading?"":Headline,
              style:GoogleFonts.noticiaText(
                color:Colors.white,
                fontSize:23
              )),
          )
          ,
        ),
        // color: Colors.green,
      ),
    );
    
  }
  @override
  bool get wantKeepAlive => true;

}