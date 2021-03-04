import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'jureHelp.dart';
import 'main.dart';
import 'news.dart';
import 'LaunchScreen.dart';
import 'package:url_launcher/url_launcher.dart';

bool listRegionsReady = false;
var parsedJsonRegionList;
var regionsBackUp;

class RegionSelectPage extends StatefulWidget {
  @override
  _RegionSelectPageState createState() => _RegionSelectPageState();

}

class _RegionSelectPageState extends State<RegionSelectPage> {
  var _controllerSearchRegion = TextEditingController();
  getRegionsList()async{
    try{
      var response = await http.post('https://lgototvet.koldashev.ru/LgotOtvetAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "subject": "regions"
          })
      );
      var jsonStaffList = response.body;
      parsedJsonRegionList = json.decode(jsonStaffList);
      regionsBackUp = json.decode(jsonStaffList);
      //print(response.body);
      listRegionsReady = true;
    } catch (error) {print(error);}

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getRegionsList();
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
        child:Center(
          child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                Center(
                  child: Text('Выберите свой регион из списка',style: TextStyle(fontSize: 20.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                ),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.fromLTRB(30,0,30,30),
                  child:TextFormField(
                    enabled: true,
                    //keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Поиск",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () { _controllerSearchRegion.clear(); parsedJsonRegionList = regionsBackUp; setState(() {

                        });},
                        icon: Icon(Icons.clear),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ), enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),), validator: (value) {
                    if (value.isEmpty) {
                      return 'Поиск';
                    }
                    return null;
                  },
                    onChanged: (value){
                      if(value.length == 0) {parsedJsonRegionList = regionsBackUp; setState(() {

                      });}
                      //refreshRegions(value);
                      List tempList = [];
                      for(int i = 0; i < parsedJsonRegionList.length; i++){
                        if(parsedJsonRegionList[i]['regionName'].toLowerCase().contains(value.toLowerCase())){
                         // print('нашли совпадение');
                          tempList.add(parsedJsonRegionList[i]);
                        }
                       }
                      setState(() {
                      });
                      parsedJsonRegionList = tempList;
                     // print(parsedJsonRegionList);
                    },
                    // ignore: deprecated_member_use
                    autovalidate: true,
                    controller: _controllerSearchRegion,
                  ),
                ),

                listRegionsReady == true?ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: parsedJsonRegionList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              region = parsedJsonRegionList[index]['regionid'];
                              regionName = parsedJsonRegionList[index]['regionName'];
                            });
                            //пишем регион в файл
                            firstRegistration(region);
                            /*Navigator.pushReplacement(context,
                                CupertinoPageRoute(builder: (context) => MyHomePage()));*/
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20,0,20,0),
                            padding: EdgeInsets.fromLTRB(10,5,5,5),
                            width: MediaQuery.of(context).size.width - 60,
                            height: 50,
                            decoration: BoxDecoration(
                              color: index%2==0?Color.fromRGBO(229, 229, 229, 1):Colors.grey[400],),
                            alignment: Alignment.centerLeft,
                            child: Text('${parsedJsonRegionList[index]['regionName']}',style: TextStyle(fontSize: 17.0 , color: Color(0xFF444444), fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                          )
                      );
                    }):Container(),
              ]
          ),
        ),
      ),
      /*bottomNavigationBar: BottomNavigationBar(
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
      ),*/
    );
  }
 // int _selectedIndex = 0;
  /*void _onItemTapped(int index) {
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
  }*/


  firstRegistration(int region) async{
    try{
      //проверяем, нет ли уже у пользователя ID т.к. он может захотеть поменять регион в процессе жизни
      if(userId == '') {
       // print('первая регистрация');
        var response = await http.post(
            'https://lgototvet.koldashev.ru/LgotOtvetAPI.php',
            headers: {"Accept": "application/json"},
            body: jsonEncode(<String, dynamic>{
              "region": "$region",
              "subject": "firstRegistration"
            })
        );
        //получили значение IDдля данного пользователя
        userId = response.body;
        //записали в файл номер пользователя, номер региона, имя региона
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/profileNew.txt');
        var profile = jsonEncode(<String, dynamic>{
          "userId": "$userId",
          "region": "$region",
          "regionName": "$regionName",
          "push" : 0
        });
        await file.writeAsString(profile);
        setState(() {

        });
        //print('$userId $region');
        getPayList();
      } else
        {
         // print('обновление регистрауии');
          //userId уже есть, надо отредактировать в БД на новый регион
          var response = await http.post(
              'https://lgototvet.koldashev.ru/LgotOtvetAPI.php',
              headers: {"Accept": "application/json"},
              body: jsonEncode(<String, dynamic>{
                "region": "$region",
                "userId": "$userId",
                "subject": "editRegionRegistration"
              })
          );
          //получили значение IDдля данного пользователя
          //userId = response.body;
          //записали в файл номер пользователя, номер региона, имя региона
          final Directory directory = await getApplicationDocumentsDirectory();
          final File file = File('${directory.path}/profileNew.txt');
          var profile = jsonEncode(<String, dynamic>{
            "userId": "$userId",
            "region": "$region",
            "regionName": "$regionName"
          });
          await file.writeAsString(profile);
          setState(() {

          });
          getPayList();
        }
    } catch (error) {
      print(error);
    }

  }

  getPayList()async{
    final DateTime now = DateTime.now();
    final DateFormat monthIs = DateFormat('MM');
    String monthIsString = monthIs.format(now);
    final DateFormat yearNow = DateFormat('yyyy');
    final String yearNowString = yearNow.format(now);
    try{
      var response = await http.post('https://lgototvet.koldashev.ru/LgotOtvetAPI.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "region" : "$region",
            "userId" : "$userId",
            "month" : "${int.parse(monthIsString)}",
            "year" : "${int.parse(yearNowString)}",
            "dayInMonth" : "${DateTime(int.parse(yearNowString), int.parse(monthIsString) + 1, 0).day}",
            "subject": "getGrants"
          })
      );
      var jsonStaffList = response.body;
      parsedJsonPaysList = json.decode(jsonStaffList);
      //print(response.body);
      listReady = true;
    } catch (error) {
      print(error);
    }

    setState(() {
    });
    Navigator.pushReplacement (context,
        CupertinoPageRoute(builder: (context) => MyHomePage()));
  }

}


