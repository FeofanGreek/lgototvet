import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lgototvet/regionSelect.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';
import 'news.dart';


String messageTest = '';
String userId = '';
int push = 0;
int region = 0; //значение берется из профиля
String regionName = '';

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    ..status = data['status'];
  return item;
}

class Item {
  Item({this.itemId});
  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }

}




class launchScreen extends StatefulWidget {

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}


class _LaunchScreenState extends State<launchScreen> {


  readProfile() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File fileL = File('${directory.path}/profileNew.txt');
      var UfromFile = await fileL.readAsString();
      var nameUs = json.decode(UfromFile);
      userId = nameUs['userId'];
      region = int.parse(nameUs['region']);
      //int.parse(nameUs['region']) == null ? region=0 : region = int.parse(nameUs['region']);
      regionName = nameUs['regionName'];
      push = nameUs['push'];
      //если согласие на пуши записано, тогда настраиваем прием сообщений и дейчтвия по ним
      if(push == 1){
      //настраиваем прием уведолмлений в адрес
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          final Item item = _itemForMessage(message);
          if(item._status == 'news'){
            messageTest = item._status;
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => NewsPage()));
          } else if (item._status == 'grant'){
            messageTest = item._status;
            getPayList();
          } else {getPayList();}
          setState(() {
          });
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          final Item item = _itemForMessage(message);
          if(item._status == 'news'){
            messageTest = item._status;
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => NewsPage()));
          } else if (item._status == 'grant'){
            messageTest = item._status;
            getPayList();
          } else {getPayList();}
          setState(() {
          });
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          final Item item = _itemForMessage(message);
          if(item._status == 'news'){
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => NewsPage()));
          } else if (item._status == 'grant'){
            getPayList();
          } else {getPayList();}
          setState(() {
          });
        },
      ); }
      messageTest == '' ? getPayList() : null;
    } catch (error) {
      print(error);
      print('Первый вход');
      //редиректимся в выбор региона
      const twentyMillis = const Duration(seconds:2);
      new Timer(twentyMillis, () => Navigator.pushReplacement (context,
          CupertinoPageRoute(builder: (context) => RegionSelectPage())));
    }
    //загружаем данные по льготам с сервера
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

    const twentyMillis = const Duration(seconds:2);
    new Timer(twentyMillis, () => Navigator.pushReplacement (context,
        CupertinoPageRoute(builder: (context) => MyHomePage())));
      }

  @override
  void initState() {
    super.initState();
    //считывам профиль и формируем запрос на список льгот если нет профиля редиректим в выбор региона
    readProfile();
  }//initState


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body:Container(
        height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color.fromRGBO(229, 229, 229, 1),),

        child:Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height / 2 - 120, width: MediaQuery.of(context).size.width,

              ),
            Container(
              height: 100, width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/logo.png"),
                    fit:BoxFit.fitWidth, alignment: Alignment(0.0, 0.0)
                ),
              ),),
            /*Center(
                child:Text('ЛьготОтвет\n', style: TextStyle(fontSize: 20.0, color: Colors.grey, fontFamily: 'Open Sans',fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),*/
            Center(
              child:Text('Когда придут пособия\n', style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Open Sans',fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
            Center(
                child:Text('Версия: 1.0.0\n', style: TextStyle(fontSize: 15.0, color: Colors.black, fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
            ),
            Center(
              child:Container(
                  width: 15.0,
                  height: 15.0,
                  margin: EdgeInsets.fromLTRB(10,0,0,0),
                  child:CircularProgressIndicator(strokeWidth: 2.0,
                    valueColor : AlwaysStoppedAnimation(Colors.red),)),
            ),
        ]),
      ),
    );
  }
}
