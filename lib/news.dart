import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LaunchScreen.dart';
import 'jureHelp.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

bool listNewsReady = false;
var parsedJsonNewsList;


class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();

}

class _NewsPageState extends State<NewsPage> {

  getNewsList()async{
    try{
      var response = await http.post('https://lgototvet.koldashev.ru/LgotOtvetAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "region":"$region",
            "subject": "news"
          })
      );
      var jsonStaffList = response.body;
      parsedJsonNewsList = json.decode(jsonStaffList);
      //print(response.body);
      listNewsReady = true;
    } catch (error) {print(error);}

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getNewsList();
  }

  goToSite(url) async {
    if (await canLaunch('$url')) {
      await launch('$url');
    } else {
      throw 'Невозможно набрать номер $url';
    }
    print('пробуем позвонить');
  }
  callClient(url) async {
    if (await canLaunch('tel://$url')) {
      await launch('tel://$url');
    } else {
      throw 'Невозможно набрать номер $url';
    }
    print('пробуем позвонить');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Container(width: 200, height: 50, child: Stack( children: <Widget> [Positioned(left:0, top: 5, child: Image.asset('images/logo.png',  height: 44, width:99, ),),]),),
          centerTitle: false,
          backgroundColor: Color(0xFFFFFFFF),
          brightness: Brightness.light,
          // leading: Container(width: 250, margin: EdgeInsets.fromLTRB(20,10,10,10), child: Image.asset('images/lgotLogo.png',  height: 44, width:99, ),)
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  callClient('88005113854');
                },
                child:
                Container(
                    margin: EdgeInsets.fromLTRB(0,5,10,5),
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: '8 (800) 511-38-54 ', style: TextStyle(fontSize: 16.0, color: Color(0xFFFF2A24), fontFamily: 'Open Sans',fontWeight: FontWeight.bold ),
                        children: <TextSpan>[
                          TextSpan(text: '\nБесплатная юридическая', style: TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                          TextSpan(text: ' \nконсультация', style: TextStyle(fontSize: 12.0, color: Colors.black, fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                )
            ),
          ]
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
              child: Column(
                  children: <Widget>[

              listNewsReady == true ? ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: parsedJsonNewsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Color(0xFFFFFFFF),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: Alignment.topLeft,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(

                              alignment: Alignment.topLeft,
                              child:
                              Text('\n   ${parsedJsonNewsList[index]['dateNews']}', style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey,
                                fontFamily: 'Open Sans', /*fontWeight: FontWeight.bold*/),
                                  textAlign: TextAlign.left),),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Text(
                                '${parsedJsonNewsList[index]['title']}',
                                style: TextStyle(fontSize: 14.0,
                                  color: Colors.black,
                                  fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(
                                //'${parsedJsonNewsList[index]['text']}',
                              '${parsedJsonNewsList[index]['text'].length > 200 ? parsedJsonNewsList[index]['text'].replaceRange(200, parsedJsonNewsList[index]['text'].length, '...') : parsedJsonNewsList[index]['text']}',
                                style: TextStyle(fontSize: 12.0,
                                  color: Colors.black,
                                  fontFamily: 'Open Sans', /*fontWeight: FontWeight.bold*/),
                                textAlign: TextAlign.left),),
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                /*borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7.0),
                                    bottomLeft: Radius.circular(7.0)),*/
                                color: Color(0xFFFFFFFF),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${parsedJsonNewsList[index]['linkPic']}'),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment(0.0, 0.0)
                                ),
                              ),
                              child: Text(''),),

                            Align(
                                alignment: Alignment.bottomLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    goToSite('${parsedJsonNewsList[index]['link']}');
                                  },
                                  child: Text('\n   Читать полностью...\n',
                                      style: TextStyle(fontSize: 14.0,
                                        color: Colors.blue,
                                        fontFamily: 'Open Sans', /*fontWeight: FontWeight.bold*/),
                                      textAlign: TextAlign.left),
                                )),

                          ]
                      ),
                    );
                  }) : Container( margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/2-10, MediaQuery.of(context).size.height/2-10, 0, 0), child: CircularProgressIndicator())



              ]
            ),
          ),
        ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            label: 'Пособия',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined ),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Спросить',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFFFF2A24),
        onTap: _onItemTapped,
      ),
    );
  }
  //int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    if(selectedIndex == 0) {
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => MyHomePage()));
    }
    if(selectedIndex == 1){
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => NewsPage()));
    }
    if(selectedIndex == 2){
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => PlayWithComputer()));
    }
  }
}

/*
старый блок новостей
Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Color(0xFFFFFFFF),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: Alignment.topLeft,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7.0),
                                    bottomLeft: Radius.circular(7.0)),
                                color: Color(0xFFFFFFFF),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${parsedJsonNewsList[index]['linkPic']}'),
                                    fit: BoxFit.fitHeight,
                                    alignment: Alignment(0.1, 0.0)
                                ),
                              ),
                              child: Text(''),),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child:
                                        Text('${parsedJsonNewsList[index]['dateNews']}', style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.grey,
                                          fontFamily: 'Open Sans', /*fontWeight: FontWeight.bold*/),
                                            textAlign: TextAlign.left),),
                                      Text(
                                          '${parsedJsonNewsList[index]['title']}',
                                          style: TextStyle(fontSize: 13.0,
                                            color: Colors.black,
                                            fontFamily: 'Open Sans', /*fontWeight: FontWeight.bold*/),
                                          textAlign: TextAlign.left),
                                      /*Text(
                                          '${parsedJsonPaysList[index]['text']}',
                                          style: TextStyle(fontSize: 12.0,
                                            color: Colors.black,
                                            fontFamily: 'Open Sans', /*fontWeight: FontWeight.bold*/),
                                          textAlign: TextAlign.left),*/
                                      Align(
                                          alignment: Alignment.bottomLeft,
                                          child: GestureDetector(
                                            onTap: () {
                                              goToSite('${parsedJsonNewsList[index]['link']}');
                                            },
                                            child: Text('\nПодробнее...',
                                                style: TextStyle(fontSize: 14.0,
                                                  color: Colors.blue,
                                                  fontFamily: 'Open Sans', /*fontWeight: FontWeight.bold*/),
                                                textAlign: TextAlign.left),
                                          ))
                                    ]

                                ),
                              ),
                            ),
                          ]
                      ),
 */