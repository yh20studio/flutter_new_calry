import 'package:flutter/material.dart';

import 'home/RoutineHome.dart';
import 'home/CalendarNewHome.dart';
import 'home/MyPageHome.dart';
import 'auth/Login.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      title: 'Calry',
      initialRoute: '/',
      routes: {
        'index': (context) => Index(),
        "login": (BuildContext context) => Login(),
      },
      navigatorKey: navigatorKey,
      theme: ThemeData(
        brightness: Brightness.light,
        dialogBackgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        bottomAppBarColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
        primaryColor: Colors.blueAccent,
        accentColor: Colors.white,
        canvasColor: Colors.black,
        fontFamily: 'font',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'font',
            color: Colors.white,
          ),
          headline2: TextStyle(
            fontSize: 16.0,
            height: 2,
            color: Colors.black,
            fontFamily: 'font',
          ),
          subtitle1: TextStyle(fontSize: 13, fontFamily: 'font', color: Colors.white),
          subtitle2: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'font',
          ),
          bodyText1: TextStyle(
            fontSize: 15.0,
            height: 2,
            fontFamily: 'font',
          ),
          bodyText2: TextStyle(fontSize: 17.0, fontFamily: 'Sans serif'),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.white,
        bottomAppBarColor: Colors.black,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.black),
        backgroundColor: Colors.black,
        canvasColor: Colors.white,
        // 위젯을 위한 전경색상
        primaryColor: Colors.black,
        // 사용자와 상호작용하는 앨리먼트들의 기본 색상
        accentColor: Colors.white,
        snackBarTheme: SnackBarThemeData(backgroundColor: Colors.black),

        // 사용할 폰트
        fontFamily: 'font',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'font',
            color: Colors.white,
          ),
          headline2: TextStyle(
            fontSize: 16.0,
            height: 2,
            color: Colors.white,
            fontFamily: 'font',
          ),
          subtitle1: TextStyle(fontSize: 13, fontFamily: 'font', color: Colors.white),
          subtitle2: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'font',
          ),
          bodyText1: TextStyle(
            fontSize: 15.0,
            height: 2,
            fontFamily: 'font',
          ),
          bodyText2: TextStyle(fontSize: 17.0, fontFamily: 'Sans serif'),
        ),

        // additional settings go here
      ),
      home: Index(),
    );
  }
}

class Index extends StatefulWidget {
  Index({
    Key? key,
  }) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _currentIndex = 0;
  final key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    double bodyHeight = _height - MediaQuery.of(context).padding.top - 80;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SizedBox(
          height: 80,
          child: Center(
              child: BottomNavigationBar(
                  elevation: 0.0,
                  type: BottomNavigationBarType.fixed,
                  key: key,
                  onTap: _onTap,
                  currentIndex: _currentIndex,
                  selectedIconTheme: IconThemeData(color: Colors.black),
                  unselectedIconTheme: IconThemeData(color: Colors.black),
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  iconSize: 25,
                  items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
              ]))),
      body: SafeArea(child: IndexedStack(index: _currentIndex, children: <Widget>[RoutineHome(), CalendarNewHome(bodyHeight: bodyHeight), MyPageHome()])),
    );
  }
}
