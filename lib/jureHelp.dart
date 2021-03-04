import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:io';

import 'main.dart';
import 'news.dart';

String Url = 'https://lgototvet.koldashev.ru/lgototvet.html';
bool outApp = false;

WebViewController _myController;

var counter = 1;

class PlayWithComputer extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<PlayWithComputer> {
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;


  Timer timer;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    timer = new Timer.periodic(Duration(seconds: 10), (timer) {

    });

  }

  void onItemTapped(int index) {
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

  @override
  Widget build(BuildContext context) {

    String string = "";

    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "Отсутсвует связь!";
        return Scaffold(
          backgroundColor: Color(0xFFffffff),
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
          body: Center(child: Text("$string", style: TextStyle(fontSize: 36),textAlign: TextAlign.center,)),
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
            onTap: onItemTapped,
          ),
        );
        break;
      case ConnectivityResult.mobile:
        string = "Мобильные данные";
        return Scaffold(
          appBar: AppBar(
              title: Container(width: 200, height: 99, child: Stack( children: <Widget> [Positioned(left:0, top: 22, child: Image.asset('images/logo.png',  height: 44, width:99, ),),]),),
              centerTitle: false,
              backgroundColor: Color(0xFFFFFFFF),
              brightness: Brightness.light,
              actions: <Widget>[
                GestureDetector(
                    onTap: () {
                      callClient('88005113854');
                    },
                    child: Container(
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
          body: MyWebView(selectedUrl: Url),bottomNavigationBar: BottomNavigationBar(
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
          onTap: onItemTapped,
        ),
        );
        break;
      case ConnectivityResult.wifi:
        string = "Подключено к WiFi";
        return Scaffold(
            appBar: AppBar(
            title: Container(width: 200, height: 99, child: Stack( children: <Widget> [Positioned(left:0, top: 22, child: Image.asset('images/logo.png',  height: 44, width:99, ),),]),),
              centerTitle: false,
              backgroundColor: Color(0xFFFFFFFF),
              brightness: Brightness.light,
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    callClient('88005113854');
                  },
                  child: Container(
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
                body: MyWebView(selectedUrl: Url),bottomNavigationBar: BottomNavigationBar(
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
                  onTap: onItemTapped,
                ),
              );
        break;
    }
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }
}

callClient(url) async {
  if (await canLaunch('tel://$url')) {
    await launch('tel://$url');
  } else {
    throw 'Невозможно набрать номер $url';
  }
  print('пробуем позвонить');
}
//запускаем сайт
class MyConnectivity {
  MyConnectivity._internal();
  static final MyConnectivity _instance = MyConnectivity._internal();
  static MyConnectivity get instance => _instance;
  Connectivity connectivity = Connectivity();
  StreamController controller = StreamController.broadcast();
  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('https://lgototvet.koldashev.ru/lgototvet.html');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}

class MyWebView extends StatelessWidget {

  String selectedUrl;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();


  MyWebView({
    @required this.selectedUrl,
  });

  //создаем тело виджета
  @override
  Widget build(BuildContext context) {
    return WebView(
            initialUrl: selectedUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              _myController = webViewController;
            },
            onPageFinished: (url){
            }
        );
  }

}
