import 'package:flutter/material.dart';
import 'package:flutter_webservice/auth/Login.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/detail/ArchivesDetail.dart';
import 'package:flutter_webservice/detail/RoutinesMemosDetail.dart';
import 'package:flutter_webservice/list/ArchivesList.dart';
import 'package:flutter_webservice/list/CustomRoutinesList.dart';
import 'package:flutter_webservice/input/ArchivesInput.dart';
import 'package:flutter_webservice/input/CustomRoutinesInput.dart';

import 'package:flutter_webservice/auth/SignUp.dart';
import 'package:flutter_webservice/auth/MemberInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Webservice',
      initialRoute: '/',
      routes: {
        '/index': (context) => Index(),
        '/archives/input': (context) => ArchivesInput(),
        '/archives/list': (context) => ArchivesList(),
        '/archives/detail': (context) => ArchivesDetail(),
        '/customRoutines/input': (context) => CustomRoutinesInput(),
        '/customRoutines/list': (context) => CustomRoutinesList(),
        '/routines/memo/detail': (context) => RoutinesMemosDetail(),
      },
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
          subtitle1: TextStyle(
            fontSize: 16.0,
            fontFamily: 'font',
          ),
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
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Colors.black),
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
          subtitle1: TextStyle(
            fontSize: 16.0,
            fontFamily: 'font',
          ),
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
      home: Index(title: 'Flutter Webservice'),
    );
  }
}

class Index extends StatefulWidget {
  Index({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      appBar: AppBar(
        title: Text("Buy the Time"),
        automaticallyImplyLeading: false,
        leading:
            IconButton(icon: Icon(Icons.person), onPressed: _awaitReturnAuth),
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        children: [
          TextButton(onPressed: _toArchivesList, child: Text('Archives 리스트')),
          TextButton(
              onPressed: _toCustomRoutinesList,
              child: Text('Custom Routines 리스트')),
          IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: _awaitReturnValueFromArchivesInput),
          TextButton(
              child: Text("Custom 루틴 추가"),
              onPressed: _awaitReturnValueFromCustomRoutinesInput),
        ],
      ))),
    );
  }

  void _awaitReturnValueFromArchivesInput() async {
    var awaitResult = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ArchivesInput()));
    if (awaitResult != 'success') {
      setState(() {});
    }
  }

  void _awaitReturnValueFromCustomRoutinesInput() async {
    var awaitResult = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CustomRoutinesInput()));
    if (awaitResult != 'success') {
      setState(() {});
    }
  }

  void _toArchivesList() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ArchivesList()));
  }

  void _toCustomRoutinesList() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CustomRoutinesList()));
  }

  void _awaitReturnAuth() async {
    try {
      var httpGetMyInfo = await getMyInfo();
      print(httpGetMyInfo);
      var awaitResult = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MemberInfo(member: httpGetMyInfo)));
      if (awaitResult == 'success') {}
    } catch (e) {
      print(e);
      var result = await authenticationUser();
      if (result == 'success') {
        var httpGetMyInfo = await getMyInfo();
        var awaitResult = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MemberInfo(member: httpGetMyInfo)));
        if (awaitResult == 'success') {}
      } else if (result == 'fail') {
        var awaitResult = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        if (awaitResult == 'success') {}
      }
    }
  }
}
