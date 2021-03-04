import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgototvet/regionSelect.dart';
import 'LaunchScreen.dart';
import 'jureHelp.dart';
import 'news.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


var parsedJsonPaysList;
bool listReady = false;
int countDayInMonth = 28;//количество дней в месяце по умолчанию
int dayToDay;
var sizeForLittleCircle;


//int monthNum = 1; // значение будем менять фильтром
final DateTime now = DateTime.now();
final DateFormat dayNum = DateFormat('d');
final int dayNumInt = int.parse(dayNum.format(now));
final DateFormat todayIs = DateFormat('dd');
final String todayIsString = todayIs.format(now);
final DateFormat monthIs = DateFormat('MM');
String monthIsString = monthIs.format(now);

int monthNum = int.parse(monthIs.format(now));

final DateFormat timeNow = DateFormat('HH:mm');
String timeNowString = timeNow.format(now);
final DateFormat yearNow = DateFormat('yyyy');
final String yearNowString = yearNow.format(now);
int lastDay = DateTime(now.year, now.month + 1, 0).day;
int firstDay = DateTime(now.year, now.month + 1, 0).day-lastDay+1;
int dayCount = 0;
int dayCountTo = 0;
int dayCountThree = 0;
int dayCountFore = 0;
int angleCount = 0;
int iWasTakeIt = 0;
int iWasTakeIt2 = int.parse(todayIs.format(now));
int scrollCount = 1;
int selectedIndex = 0;

bool check=true;

String tokenMy;

List monthCalendar = ["январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: launchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  final _controller = ScrollController();
  final _controllerTwo = ScrollController();

  getPayList(String month, year )async{
    //listReady = false;
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
      //print(response.body);
      var jsonStaffList = response.body;
      parsedJsonPaysList = json.decode(jsonStaffList);
      listReady = true;
    } catch (error) {
      print(error);
    }

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    print('Номер месяца $monthNum');
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
        controller: _controller,
        physics: ScrollPhysics(),
          child:Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                //выбиралка региона
                Container(
                    width:MediaQuery.of(context).size.width,
                    height:40,
                    child: Stack(
                        children: <Widget>[
                          Positioned(
                              top:0,
                              right: 10,
                              child: GestureDetector(
                                  onTap: () {
                                    infoWidget();
                                  },
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,

                                      child: Image.asset('images/i.png',  height: 30, width:30, )
                                  )
                              )
                          ),
                        Container(
                            margin: EdgeInsets.fromLTRB(40,0,0,0),
                            padding: EdgeInsets.fromLTRB(0,0,0,0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                listReady?Text('${regionName == '' ? 'Выберите регион' : regionName} ',style: TextStyle(fontSize: 16.0, color: Color(0xFF444444), /*decoration: TextDecoration.underline, decorationColor: Color(0xFF444444), decorationThickness: 2,*/ fontFamily: 'Open Sans'),textAlign: TextAlign.left,):Text('Выбрать регион',style: TextStyle(fontSize: 20.0, color: Color(0xFF444444), /*decoration: TextDecoration.underline, decorationColor: Color(0xFF444444), decorationThickness: 1,*/ fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                FlatButton.icon(
                                  minWidth: 16,
                                    onPressed: (){
                                      Navigator.pushReplacement(context,
                                          CupertinoPageRoute(builder: (context) => RegionSelectPage()));
                                    },
                                    icon: Icon(Icons.edit_outlined, size: 18.0, color: Color(0xFFFF2A24)),
                                    label: Container())
                              ]
                          )
                        ),
                      ]
                    )),
                //список выплат
                listReady?ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                            ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: <Widget>[

                              ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: parsedJsonPaysList.length,
                                  itemBuilder: (BuildContext context, int index2) {
                                    countDayInMonth = parsedJsonPaysList[index2]['dayValues'].length; //узнаем сколько дней взагруженом месяце
                                    sizeForLittleCircle =  3.1458*2*(320/2)/countDayInMonth-15; //настройка размера внешних кружков
                                    var angleForLittleCircle = 3.1458*2/countDayInMonth;
                                    angleCount = 1;
                                    dayCount = 0;
                                    dayCountTo = 1;
                                    dayCountThree = 1;
                                    dayCountFore = 0;
                                    iWasTakeIt = 0;
                                    var summAllHowTakePay=0;
                                    for(int i=1; i < parsedJsonPaysList[index2]['dayValues'].length; i++){
                                      summAllHowTakePay = summAllHowTakePay + parsedJsonPaysList[index2]['dayValues']['${i.toString()}'];
                                    }
                                    if(parsedJsonPaysList[index2]['status'] > 0){
                                      iWasTakeIt = parsedJsonPaysList[index2]['status'];
                                      //print('Я уже получил выплату $iWasTakeIt числа');
                                    }

                                    return ListView(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          Center(
                                              child: Container(
                                                width:MediaQuery.of(context).size.width - 80,
                                                child:Text('${parsedJsonPaysList[index2]['payName']}',style: TextStyle(fontSize: 20.0, color: Color(0xFF000000),fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                              )
                                          ),
                                          SizedBox(height: 10.0),
                                          //выбиралка календаря
                                          Center(
                                              child: SizedBox(
                                                  width:300,
                                                  height: 64,
                                                  child:Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      color: Color(0xFFFFFFFF),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.withOpacity(0.5),
                                                          spreadRadius: 1,
                                                          blurRadius: 3,
                                                          offset: Offset(0, 0), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child:listReady?ListView.builder(
                                                        controller: _controllerTwo,
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: 12,
                                                        itemBuilder: (BuildContext context, int index000) {
                                                          index000 == 1 ?_controllerTwo.animateTo((monthNum.toDouble() * 75)-74, duration: Duration(seconds: 2), curve: Curves.ease): true;
                                                          return GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  index000 < 10? monthIsString='0${index000+1}': monthIsString='${index000+1}';
                                                                  monthNum = index000+1;
                                                                  getPayList(monthIsString, yearNowString);
                                                                });
                                                              },
                                                              child: Container(
                                                                width: monthIsString == (index000 < 10? '0${index000+1}': '${index000+1}')?160:75,
                                                                  alignment: Alignment.center,
                                                                  child: Text('${monthCalendar[index000]} ${monthIsString == (index000 < 10? '0${index000+1}': '${index000+1}')? yearNowString : ''}',style: TextStyle(fontSize: monthIsString == (index000 < 10? '0${index000+1}': '${index000+1}')? 20.0 : 16.0, color: monthIsString == (index000 < 10? '0${index000+1}': '${index000+1}')? Color(0xFF000000): Color(0xFF444444), /*decoration: monthIsString == (index000 < 10? '0${index000+1}': '${index000+1}')? TextDecoration.underline:TextDecoration.none, decorationColor: Colors.red, decorationThickness: 1,*/ fontFamily: 'Open Sans'),textAlign: TextAlign.center,),

                                                              )
                                                          );
                                                        }):Container(),
                                                  ))),
                                          //выбиралка даты
                                          SizedBox(height: 10.0),
                                          Center(
                                              child: Container(
                                                width:MediaQuery.of(context).size.width - 80,
                                                child: monthIsString==monthIs.format(now)  ? Text('На $todayIsString ${monthIsString=='01'?
                                                'января':
                                                (monthIsString=='02'?'февраля':
                                                (monthIsString=='03'?'марта':
                                                (monthIsString=='04'?'апреля':
                                                (monthIsString=='05'?'мая':
                                                (monthIsString=='06'?'июня':
                                                (monthIsString=='07'?'июля':
                                                (monthIsString=='08'?'августа':
                                                (monthIsString=='09'?'сентября':
                                                (monthIsString=='10'?'октября':
                                                (monthIsString=='11'?'ноября':'декабря'))))))))))} $timeNowString отметили: $summAllHowTakePay человек${summAllHowTakePay.toString()[summAllHowTakePay.toString().length-1] == '2'?'а':summAllHowTakePay.toString()[summAllHowTakePay.toString().length-1] == '3'?'а':summAllHowTakePay.toString()[summAllHowTakePay.toString().length-1] == '4'?'а\n':'\n'}',style: TextStyle(fontSize: 18.0, color: Color(0xFF444444),fontFamily: 'Open Sans'),textAlign: TextAlign.left,)
                                                :Text('На ${monthIsString=='01'?
                                                'январь':
                                                (monthIsString=='02'?'февраль':
                                                (monthIsString=='03'?'март':
                                                (monthIsString=='04'?'апрель':
                                                (monthIsString=='05'?'май':
                                                (monthIsString=='06'?'июнь':
                                                (monthIsString=='07'?'июль':
                                                (monthIsString=='08'?'август':
                                                (monthIsString=='09'?'сентябрь':
                                                (monthIsString=='10'?'октябрь':
                                                (monthIsString=='11'?'ноябрь':'декабрь'))))))))))} отметили: $summAllHowTakePay человек${summAllHowTakePay.toString()[summAllHowTakePay.toString().length-1] == '2'?'а':summAllHowTakePay.toString()[summAllHowTakePay.toString().length-1] == '3'?'а':summAllHowTakePay.toString()[summAllHowTakePay.toString().length-1] == '4'?'а\n':'\n'}',style: TextStyle(fontSize: 18.0, color: Color(0xFF444444),fontFamily: 'Open Sans'),textAlign: TextAlign.left,),
                                              )
                                          ),// сколько отметило
                                          //SizedBox(height: 20.0),
                                          Container(
                                            //width: 310 ,
                                            height: 280 ,
                                          child: Stack(
                                            alignment: Alignment.center,
                                              children: <Widget>[

                                                //стрелочка сегодняшнего дня
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(dayNumInt-1),
                                                    child:SizedBox(
                                                        height: 10,
                                                        width: 290,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Container(
                                                                width: 10,
                                                                height: 10,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  border: Border.all(color: Color(0xFF6A6A6A)),
                                                                  color: Color(0xFF6A6A6A),//цвет кружка меняем в зависимости от наличия выплаты
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors.grey.withOpacity(0.5),
                                                                      spreadRadius: 3,
                                                                      blurRadius: 5,
                                                                      offset: Offset(0, 0), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                ),
                                                             )
                                                        )
                                                    ),
                                                  ),),


                                                //рисуем сегмент
                                                    Positioned(
                                                      child:Transform.rotate(
                                                  angle: 1.5729, //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                  child:SizedBox(
                                                    height: sizeForLittleCircle,
                                                    width: 260,
                                                       child: Align(
                                                        alignment: Alignment.topLeft,
                                                           child: GestureDetector(
                                                               onTap: () {
                                                                 if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                   setState(() {
                                                                     iWasTakeIt =
                                                                     1;
                                                                   });
                                                                   yesPay(
                                                                       parsedJsonPaysList[index2]['grantId'],
                                                                       monthNum
                                                                           .toString(),
                                                                       iWasTakeIt);
                                                                 } else {
                                                                   setState(() {
                                                                     iWasTakeIt =
                                                                     1;
                                                                   });
                                                                   editPay(
                                                                       parsedJsonPaysList[index2]['grantId'],
                                                                       monthNum
                                                                           .toString(),
                                                                       iWasTakeIt);
                                                                 }
                                                               },
                                                          child: Container(
                                                              width: sizeForLittleCircle,
                                                              height: sizeForLittleCircle,
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                color: iWasTakeIt == 1 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['1'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24) , //цвет кружка меняем в зависимости от наличия выплаты

                                                              ),
                                                                child:Transform.rotate(
                                                                  angle: -1.57,
                                                                  child: Text('1', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                          )
                                                        )
                                                  ),
                                                 ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                                child: GestureDetector(
                                                                onTap: () {
                                                                  if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      2;
                                                                    });
                                                                    yesPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  } else {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      2;
                                                                    });
                                                                    editPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 2 ? Color(0xFFFF8A00):  parsedJsonPaysList[index2]['dayValues']['2'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('2', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  3;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  3;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }
                                                              },
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 3 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['3'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('3', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    4;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    4;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color:  iWasTakeIt == 4 ? Color(0xFFFF8A00) :  parsedJsonPaysList[index2]['dayValues']['4'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('4', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    5;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    5;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 5 ? Color(0xFFFF8A00) :  parsedJsonPaysList[index2]['dayValues']['5'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('5', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                                child: GestureDetector(
                                                                onTap: () {
                                                                  if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      6;
                                                                    });
                                                                    yesPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  } else {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      6;
                                                                    });
                                                                    editPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 6 ? Color(0xFFFF8A00) :  parsedJsonPaysList[index2]['dayValues']['6'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('6', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  7;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  7;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color:  iWasTakeIt == 7 ? Color(0xFFFF8A00) :  parsedJsonPaysList[index2]['dayValues']['7'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('7', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    8;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    8;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 8 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['8'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('8', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  9;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  9;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color:  iWasTakeIt == 9 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['9'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('9', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  10;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  10;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color:  iWasTakeIt == 10 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['10'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('10', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  11;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  11;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 11 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['11'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('11', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  12;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  12;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 12 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['12'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('12', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  13;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  13;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 13 ? Color(0xFFFF8A00) :  parsedJsonPaysList[index2]['dayValues']['13'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('13', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  14;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  14;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color:  iWasTakeIt == 14 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['14'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('14', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    15;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    15;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color:  iWasTakeIt == 15 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['15'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('15', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  16;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  16;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 16 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['16'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('16', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    17;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    17;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: dayNumInt == 17 ? Color(0xFF6A6A6A) : parsedJsonPaysList[index2]['dayValues']['17'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('17', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    18;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    18;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 18 ? Color(0xFFFF8A00):  parsedJsonPaysList[index2]['dayValues']['18'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('18', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    19;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    19;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 19 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['19'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('19', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    20;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    20;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 20 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['20'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('20', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    21;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    21;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 21 ? Color(0xFFFF8A00) :  parsedJsonPaysList[index2]['dayValues']['21'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('21', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                            onTap: () {
                                                              if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  22;
                                                                });
                                                                yesPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              } else {
                                                                setState(() {
                                                                  iWasTakeIt =
                                                                  22;
                                                                });
                                                                editPay(
                                                                    parsedJsonPaysList[index2]['grantId'],
                                                                    monthNum
                                                                        .toString(),
                                                                    iWasTakeIt);
                                                              }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 22 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['22'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('22', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    23;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    23;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color:  iWasTakeIt == 23 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['23'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('23', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    24;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    24;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 24 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['24'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('24', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    25;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    25;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 25 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['25'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('25', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    26;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    26;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 26 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['26'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('26', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    27;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    27;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color:  iWasTakeIt == 27 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['27'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('27', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child: GestureDetector(
                                                              onTap: () {
                                                                if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    28;
                                                                  });
                                                                  yesPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                } else {
                                                                  setState(() {
                                                                    iWasTakeIt =
                                                                    28;
                                                                  });
                                                                  editPay(
                                                                      parsedJsonPaysList[index2]['grantId'],
                                                                      monthNum
                                                                          .toString(),
                                                                      iWasTakeIt);
                                                                }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 28 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['28'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('28', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),),
                                                countDayInMonth >= 29 ? Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                  if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      29;
                                                                    });
                                                                    yesPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  } else {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      29;
                                                                    });
                                                                    editPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color:  iWasTakeIt == 29 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['29'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('29', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),):Container(),
                                                countDayInMonth >= 30 ? Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                  if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      30;
                                                                    });
                                                                    yesPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  } else {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      30;
                                                                    });
                                                                    editPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 30 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['30'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('30', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),):Container(),
                                                countDayInMonth == 31 ? Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*angleCount,
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle,
                                                        width: 260,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                  if(parsedJsonPaysList[index2]['status'] == 0) {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      31;
                                                                    });
                                                                    yesPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  } else {
                                                                    setState(() {
                                                                      iWasTakeIt =
                                                                      31;
                                                                    });
                                                                    editPay(
                                                                        parsedJsonPaysList[index2]['grantId'],
                                                                        monthNum
                                                                            .toString(),
                                                                        iWasTakeIt);
                                                                  }},
                                                            child: Container(
                                                                width: sizeForLittleCircle,
                                                                height: sizeForLittleCircle,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(sizeForLittleCircle/2),
                                                                  color: iWasTakeIt == 31 ? Color(0xFFFF8A00) : parsedJsonPaysList[index2]['dayValues']['31'] > 0 ? Color.fromRGBO(73, 168, 29, 1) : Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                                                                ),
                                                                child:Transform.rotate(
                                                                  angle: -1.5729-angleForLittleCircle*angleCount++,
                                                                  child: Text('31', style: TextStyle(fontSize: 12.0, color: Colors.white,fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),),):Container(),

                                                //завершили рисовать сегмент


                                                //рисуем треугольнички
                                                parsedJsonPaysList[index2]['dayValues']['1'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729, //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                              child:Transform.rotate(
                                                                angle: -1.57,
                                                                  child: Container(
                                                                    width: sizeForLittleCircle,
                                                                    height: sizeForLittleCircle+10,
                                                                    alignment: Alignment.center,
                                                                      decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image: AssetImage("images/triangle.png"),
                                                                            fit:BoxFit.fitWidth,
                                                                            alignment: Alignment(0.0, 0.0)
                                                                        ),
                                                                ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['1'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['1']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                              )
                                                            )
                                                          ),
                                                        ),
                                                      ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['2'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(1), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png", ),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0),

                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['2'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['2']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans', height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['3'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(2), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['3'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['3']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['4'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(3), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['4'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['4']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['5'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(4), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['5'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['5']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['6'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(5), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['6'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['6']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['7'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(6), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['7'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['7']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['8'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(7), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.5729,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    //border: Border.all(color: Color(0xFF6A6A6A)),
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child:Transform.rotate(
                                                                    angle: countDayInMonth < 30 ? 3.1459 : 0,
                                                                  child: Text('${countDayInMonth > 29 ? '\n\n' : ''}${parsedJsonPaysList[index2]['dayValues']['8'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['8']}'}\nчел${countDayInMonth < 30 ? '\n\n' : ''}', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                  )
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['9'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(8), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child:Transform.rotate(
                                                                  angle: 3.1459,
                                                                    child: Text('${parsedJsonPaysList[index2]['dayValues']['9'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['9']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                              )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['10'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(9), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                    angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['10'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['10']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                              )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['11'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(10), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['11'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['11']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    ),
                                                                  )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['12'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(11), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['12'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['12']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                    )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['13'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(12), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child:Transform.rotate(
                                                                    angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['13'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['13']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                  )
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['14'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(13), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['14'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['14']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                    )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['15'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(14), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['15'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['15']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                    )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['16'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(15), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['16'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['16']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                    )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['17'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(16), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['17'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['17']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                    )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['18'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(17), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['18'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['18']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                    )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['19'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(18), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['19'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['19']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['20'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(19), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['20'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['20']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['21'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(20), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['21'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['21']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['22'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(21), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: 3.1459,
                                                                  child: Text('${parsedJsonPaysList[index2]['dayValues']['22'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['22']}'}\nчел\n\n', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['23'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(22), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: countDayInMonth > 28 ? 3.1459 : 0,
                                                                  child: Text('${countDayInMonth < 29 ? '\n\n' : ''}${parsedJsonPaysList[index2]['dayValues']['23'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['23']}'}\nчел${countDayInMonth >28 ? '\n\n' : ''}', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['24'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(23), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                    child:Transform.rotate(
                                                                      angle: countDayInMonth > 28 ? 3.1459 : 0,
                                                                  child: Text('${countDayInMonth < 29 ? '\n\n' : ''}${parsedJsonPaysList[index2]['dayValues']['24'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['24']}'}\nчел${countDayInMonth >28 ? '\n\n' : ''}', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['25'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(24), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),

                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['25'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['25']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),

                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['26'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(25), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),

                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['26'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['26']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),

                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['27'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(26), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['27'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['27']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                parsedJsonPaysList[index2]['dayValues']['28'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(27), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['28'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['28']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container(),
                                                countDayInMonth >= 29 ? parsedJsonPaysList[index2]['dayValues']['29'] > 0 ? Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(28), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['29'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['29']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container():Container(),
                                                countDayInMonth >= 30 ? parsedJsonPaysList[index2]['dayValues']['30'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(29), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['30'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['30']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container():Container(),
                                                countDayInMonth >= 31 ? parsedJsonPaysList[index2]['dayValues']['31'] > 0 ?Positioned(
                                                  child:Transform.rotate(
                                                    angle: 1.5729+angleForLittleCircle*(30), //делаем так, чтоб сегодняшний день всегда смотрел вверх
                                                    child:SizedBox(
                                                        height: sizeForLittleCircle+10,
                                                        width: 220,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Transform.rotate(
                                                                angle: -1.57,
                                                                child: Container(
                                                                  width: sizeForLittleCircle,
                                                                  height: sizeForLittleCircle+10,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage("images/triangle.png"),
                                                                        fit:BoxFit.fitWidth,
                                                                        alignment: Alignment(0.0, 0.0)
                                                                    ),
                                                                  ),
                                                                  child: Text('\n\n${parsedJsonPaysList[index2]['dayValues']['31'] > 99 ? '99+' : '${parsedJsonPaysList[index2]['dayValues']['31']}'}\nчел', style: TextStyle(fontSize: 8.0, color: Colors.black,fontFamily: 'Open Sans',height: 0.8),textAlign: TextAlign.center,),
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                ):Container():Container(),

                                                //конец рисуем треугольнички

                                                Positioned(
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      width: 150,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(75),
                                                        color: Color.fromRGBO(229, 229, 229, 1),),
                                                      child: iWasTakeIt == 0 ? Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            monthIsString==monthIs.format(now)  ? Text('$todayIsString ${monthIsString=='01'?
                                                            'января':
                                                            (monthIsString=='02'?'февраля':
                                                                (monthIsString=='03'?'марта':
                                                                  (monthIsString=='04'?'апреля':
                                                                    (monthIsString=='05'?'мая':
                                                                      (monthIsString=='06'?'июня':
                                                                        (monthIsString=='07'?'июля':
                                                                          (monthIsString=='08'?'августа':
                                                                            (monthIsString=='09'?'сентября':
                                                                              (monthIsString=='10'?'октября':
                                                                                (monthIsString=='11'?'ноября':'декабря'))))))))))}', style: TextStyle(fontSize: 16.0, color: Color(0xFF6A6A6A),fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                                            : Text('${monthIsString=='01'?
                                                            'Январь':
                                                            (monthIsString=='02'?'Февраль':
                                                            (monthIsString=='03'?'Март':
                                                            (monthIsString=='04'?'Апрель':
                                                            (monthIsString=='05'?'Май':
                                                            (monthIsString=='06'?'Июнь':
                                                            (monthIsString=='07'?'Июль':
                                                            (monthIsString=='08'?'Август':
                                                            (monthIsString=='09'?'Сентябрь':
                                                            (monthIsString=='10'?'Октябрь':
                                                            (monthIsString=='11'?'Ноябрь':'Декабрь'))))))))))}', style: TextStyle(fontSize: 16.0, color: Color(0xFF6A6A6A),fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                                            SizedBox(height: 7.0),
                                                            Text('Пришли ли вам\nпособия?', style: TextStyle(fontSize: 16.0, color: Color(0xFFFF0000),fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                                            SizedBox(height: 7.0),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                GestureDetector(
                                                                onTap: () {
                                                                  iWasTakeIt2 = int.parse(todayIs.format(now));
                                                                  showDialog(
                                                                      context: context,
                                                                      barrierDismissible: false,
                                                                      builder: (context) {
                                                                        return AlertDialog(
                                                                          title: Text("", style: TextStyle(fontSize: 17.0,color: Colors.black87),textAlign: TextAlign.center,),
                                                                          content: Text(
                                                                                        '\nОтметьте на круговом календаре число, когда вам пришло пособие в этом месяце'),

                                                                          actions: <Widget>[
                                                                                      RaisedButton.icon(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                                        },
                                                                                        icon: Icon(Icons.check),
                                                                                        label: Text("OK"),
                                                                                        color: Colors.blue,
                                                                                        textColor: Colors.white,
                                                                                        disabledColor: Colors.blue,
                                                                                        disabledTextColor: Colors.white,
                                                                                        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                                                                        splashColor: Colors.blueAccent,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(7.0),
                                                                                        ),
                                                                                      ),
                                                                          ],
                                                                        );
                                                                      }
                                                                  );
                                                                  //parsedJsonPaysList[index2]['status'] = iWasTakeIt;
                                                                //print('отметили день $iWasTakeIt');
                                                                },
                                                                child: Container(
                                                                      width: 40,
                                                                      height: 28,
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(width: 0.5, color: Color(0xFF6A6A6A)),
                                                                        /*border: Border(top: BorderSide(width: 1.0, color: Color(0xFF6A6A6A)),bottom: BorderSide(width: 1.0, color: Color(0xFF6A6A6A)),left: BorderSide(width: 1.0, color: Color(0xFF6A6A6A)),),*/
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(14.0),
                                                                              bottomLeft: Radius.circular(14.0)),
                                                                        color: Color(0xFFF8F8F8),
                                                                      ),
                                                                      child: Text('Да', style: TextStyle(fontSize: 13.0, color: Color(0xFF6A6A6A),fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                                                  ),),
                                                                  GestureDetector(
                                                                      onTap: () {
                                                                        showDialog(
                                                                            context: context,
                                                                            barrierDismissible: false,
                                                                            builder: (context) {
                                                                              return AlertDialog(
                                                                                title: Text("Благодарим за ответ!", style: TextStyle(fontSize: 17.0,color: Colors.black87),textAlign: TextAlign.center,),
                                                                                content: Container(
                                                                                    height: push == 0 ? 100 : 20,
                                                                                    child:Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: <Widget>[
                                                                                          push == 0 ? Text(
                                                                                              'Разрешите присылать вам уведомления: мы будем оповещать, когда начнутся выплаты пособий в вашем регионе, и сообщать о положенных льготах.'):Container(),
                                                                                        ]
                                                                                    )),
                                                                                actions: <Widget>[
                                                                                  Container(
                                                                                      alignment: Alignment.center,
                                                                                      margin: EdgeInsets.fromLTRB(20,10,20,10),
                                                                                      child: push == 0 ? Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: <Widget>[
                                                                                            RaisedButton.icon(
                                                                                              onPressed: () {
                                                                                                //запускаем установку пушей
                                                                                                pushInstall();
                                                                                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                                              },
                                                                                              icon: Icon(Icons.check),
                                                                                              label: Text("Да"),
                                                                                              color: Colors.blue,
                                                                                              textColor: Colors.white,
                                                                                              disabledColor: Colors.blue,
                                                                                              disabledTextColor: Colors.white,
                                                                                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                                                                              splashColor: Colors.blueAccent,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(7.0),
                                                                                              ),
                                                                                            ),
                                                                                            Text("  "),
                                                                                            RaisedButton.icon(
                                                                                              onPressed: () {
                                                                                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                                              },
                                                                                              icon: Icon(Icons.cancel),
                                                                                              label: Text("Нет"),
                                                                                              color: Colors.blue,
                                                                                              textColor: Colors.white,
                                                                                              disabledColor: Colors.blue,
                                                                                              disabledTextColor: Colors.white,
                                                                                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                                                                              splashColor: Colors.blueAccent,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(7.0),
                                                                                              ),
                                                                                            ),


                                                                                          ]) : RaisedButton.icon(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                                        },
                                                                                        icon: Icon(Icons.cancel),
                                                                                        label: Text("OK"),
                                                                                        color: Colors.blue,
                                                                                        textColor: Colors.white,
                                                                                        disabledColor: Colors.blue,
                                                                                        disabledTextColor: Colors.white,
                                                                                        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                                                                        splashColor: Colors.blueAccent,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(7.0),
                                                                                        ),
                                                                                      ),),
                                                                                ],
                                                                              );
                                                                            }
                                                                        );

                                                                      },
                                                                  child: Container(
                                                                      width: 40,
                                                                      height: 28,
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(width: 0.5, color: Color(0xFF6A6A6A)),
                                                                        borderRadius: BorderRadius.only(
                                                                            topRight: Radius.circular(14.0),
                                                                            bottomRight: Radius.circular(14.0)),
                                                                        color: Color(0xFFF8F8F8),
                                                                      ),
                                                                      child: Text('Нет', style: TextStyle(fontSize: 13.0, color: Color(0xFF6A6A6A),fontFamily: 'Open Sans'),textAlign: TextAlign.center,)
                                                                  ),),
                                                                ]
                                                            )
                                                          ]
                                                      ):Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Text('Спасибо, ваш ответ записан, вы получили пособие', style: TextStyle(fontSize: 14.0, color: Color(0xFF49A81D),fontFamily: 'Open Sans'),textAlign: TextAlign.center,),
                                                            Text('$iWasTakeIt ${monthIsString=='01'?
                                                            'января':
                                                            (monthIsString=='02'?'февраля':
                                                            (monthIsString=='03'?'марта':
                                                            (monthIsString=='04'?'апреля':
                                                            (monthIsString=='05'?'мая':
                                                            (monthIsString=='06'?'июня':
                                                            (monthIsString=='07'?'июля':
                                                            (monthIsString=='08'?'августа':
                                                            (monthIsString=='09'?'сентября':
                                                            (monthIsString=='10'?'октября':
                                                            (monthIsString=='11'?'ноября':'декабря'))))))))))}', style: TextStyle(fontSize: 14.0, color: Color(0xFF6A6A6A),fontFamily: 'Open Sans'),textAlign: TextAlign.center,),

                                                          ]
                                                      )
                                                  ),
                                                ),
                                              ]
                                            )
                                          ),
                                          SizedBox(height: 60.0),
                                        ]);/////////
                                  }),
                              ]),
                    ]
                  ):Container(),


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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: new FloatingActionButton(

        onPressed:(){
          _controller.animateTo((MediaQuery.of(context).size.height) * scrollCount, duration: Duration(seconds: 2), curve: Curves.ease);
        scrollCount++;
        },
        tooltip: 'Increment',
        child: new Icon(Icons.keyboard_arrow_down_rounded, size: 50,color:Color(0xFF6A6A6A),), //cчитаем вниз, потом меняем на направление вверх и считаем вверх
        backgroundColor: Color(0xFFFFFFFF),
      ),
    );
  }

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
  void onBirthdayChange(DateTime birthday) {
    setState(() {
      //_selectedDateTime = birthday;
      final DateFormat todayIs = DateFormat('dd');
      iWasTakeIt2 = int.parse(todayIs.format(birthday));
      print(iWasTakeIt2);
      //parsedJsonPaysList[index2]['status'] = iWasTakeIt;

    });
  }

  void infoWidget(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Информация", style: TextStyle(fontSize: 17.0,color: Colors.black87),textAlign: TextAlign.center,),
            content: Container(
                height:330,
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('На круговом календаре:\n', style: TextStyle(fontSize: 13.5,color: Colors.black87)),
                      Row(
                        children: <Widget>[
                          Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:Color(0xFFFF2A24), //цвет кружка меняем в зависимости от наличия выплаты
                              ),
                          ),
                          Expanded(
                              child: Text('красным цветом отмечены дни, когда никто из вашего региона не отметил поступление пособий\n', style: TextStyle(fontSize: 13.5,color: Colors.black87)),
                          )
                        ],
                      ),
                      Row(

                        children: <Widget>[
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(10,10,10,10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:Color.fromRGBO(73, 168, 29, 1), //цвет кружка меняем в зависимости от наличия выплаты
                            ),
                          ),
                          Expanded(
                            child: Text('зеленым цветом отмечены дни, когда приходили пособия\n', style: TextStyle(fontSize: 13.5,color: Colors.black87)),
                          )
                        ]),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(10,10,10,10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFF8A00), //цвет кружка меняем в зависимости от наличия выплаты
                            ),
                          ),
                          Expanded(
                            child: Text('оранжевым цветом отмечается день, когда вы получили пособие\n', style: TextStyle(fontSize: 13.5,color: Colors.black87)),
                          ),
                          ]),
                          Row(
                            children: <Widget>[
                              Container(
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(10,10,10,10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("images/triangle.png"),
                                        fit:BoxFit.fitWidth,
                                        alignment: Alignment(0.0, 0.0)
                                    ),
                                  ),
                              ),
                              Expanded(
                                child: Text('на сером указателе количество людей, которые получили пособие в этот день\n', style: TextStyle(fontSize: 13.5,color: Colors.black87)),
                              )
                        ],
                      )

                    ]
                )),
            actions: <Widget>[
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(20,10,20,10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        RaisedButton.icon(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop('dialog');
                          },
                          icon: Icon(Icons.cancel),
                          label: Text("OK"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.blue,
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),


                      ])),
            ],
          );
        });
  }


  void editPay(int grantId, String monthNum, takeDay)async {
      try {
        var response = await http.post(
            'https://lgototvet.koldashev.ru/LgotOtvetAPI.php',
            headers: {"Accept": "application/json"},
            body: jsonEncode(<String, dynamic>{
              "region": "$region",
              "userId": "$userId",
              "grantId": "$grantId",
              "month": "${int.parse(monthNum)}",
              "year": "$yearNowString",
              "takeDay": "$takeDay",
              "subject": "editPay"
            })
        );
        print(response.body);
      } catch (error) {
        print(error);      }
      getPayList(monthNum, yearNowString);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Благодарим за ответ!",
                style: TextStyle(fontSize: 17.0, color: Colors.black87),
                textAlign: TextAlign.center,),
              content: Container(
                  height: push == 0 ? 100 : 70,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Дата получения выплаты изменена на $takeDay.$monthNum.$yearNowStringг.'),

                      ]
                  )),
              actions: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    alignment: Alignment.center, child: RaisedButton.icon(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    icon: Icon(Icons.cancel),
                    label: Text("OK"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.blue,
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),),
                ),
              ],
            );
          });

  }


  void yesPay(int grantId, String monthNum, takeDay)async{

    final DateFormat monthIs = DateFormat('MM');
    String monthIsString = monthIs.format(now);

    print('месяц переданый: $monthNum месяц реальный ${int.parse(monthIsString)}');
    if(int.parse(monthNum) <= int.parse(monthIsString)) {

      try {
        var response = await http.post(
            'https://lgototvet.koldashev.ru/LgotOtvetAPI.php',
            headers: {"Accept": "application/json"},
            body: jsonEncode(<String, dynamic>{
              "region": "$region",
              "userId": "$userId",
              "grantId": "$grantId",
              "month": "${int.parse(monthNum)}",
              "year": "$yearNowString",
              "takeDay": "$takeDay",
              "subject": "takeIt"
            })
        );
        print(response.body);
      } catch (error) {
        print(error);
      }

      getPayList(monthNum, yearNowString);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Благодарим за ответ!",
                style: TextStyle(fontSize: 17.0, color: Colors.black87),
                textAlign: TextAlign.center,),
              content: Container(
                  height: push == 0 ? 100 : 70,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        push == 0
                            ? Text(
                            'Разрешите присылать вам уведомления: мы будем оповещать, когда начнутся выплаты пособий в вашем регионе, и сообщать о положенных льготах.')
                            : Text('Ваша информация очень важна.'),

                      ]
                  )),
              actions: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: push == 0 ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton.icon(
                          onPressed: () {
                            //запускаем установку пушей
                            pushInstall();
                            Navigator.of(context, rootNavigator: true).pop(
                                'dialog');
                          },
                          icon: Icon(Icons.check),
                          label: Text("Да"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.blue,
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),
                        Text("  "),
                        RaisedButton.icon(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop(
                                'dialog');
                          },
                          icon: Icon(Icons.cancel),
                          label: Text("Нет"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.blue,
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),


                      ]) : Container(
                    alignment: Alignment.center, child: RaisedButton.icon(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    icon: Icon(Icons.cancel),
                    label: Text("OK"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.blue,
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),),
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Благодарим за ответ!",
                style: TextStyle(fontSize: 17.0, color: Colors.black87),
                textAlign: TextAlign.center,),
              content: Container(
                  height: push == 0? 100 : 80,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        push == 0
                            ? Text(
                            'Однако вы не сможете получить выплату за неначавшийся месяц!\nРазрешите присылать вам уведомления: мы будем оповещать, когда начнутся выплаты пособий в вашем регионе, и сообщать о положенных льготах.')
                            : Text('Однако вы не сможете получить выплату за неначавшийся месяц!\n'),
                      ]
                  )),
              actions: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: push == 0 ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton.icon(

                          onPressed: () {
                            //запускаем установку пушей
                            pushInstall();
                            Navigator.of(context, rootNavigator: true).pop(
                                'dialog');
                          },
                          icon: Icon(Icons.check),
                          label: Text("Да"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.blue,
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),
                        Text("  "),
                        RaisedButton.icon(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop(
                                'dialog');
                          },
                          icon: Icon(Icons.cancel),
                          label: Text("Нет"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.blue,
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),


                      ]) : Container(
                    alignment: Alignment.center, child: RaisedButton.icon(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    icon: Icon(Icons.cancel),
                    label: Text("OK"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.blue,
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),),
                ),
              ],
            );
          });

    }


    }

  pushInstall()async{

    //установили пуши и получисли токен
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((token) async{
      assert(token != null);
      setState(() {
        tokenMy = "$token"; // получили токен и отправили его в переменную
      });
      print(tokenMy);

      //пишем токен в бд
      try{
        var response = await http.post('https://lgototvet.koldashev.ru/LgotOtvetAPI.php',
            headers: {"Accept": "application/json"},
            body: jsonEncode(<String, dynamic>{
              "userId" : "$userId",
              "token" : "$tokenMy",
              "subject": "reguser"
            })
        );
        //print(response.body);
      } catch (error) {
        print(error);
      }

      //записали в файл номер пользователя, номер региона, имя региона и согласие на пуши
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/profileNew.txt');
      var profile = jsonEncode(<String, dynamic>{
        "userId": "$userId",
        "region": "$region",
        "regionName": "$regionName",
        "push" : 1
      });
      await file.writeAsString(profile);
      push = 1;
      setState(() {

      });


    });


  }
}
