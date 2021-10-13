import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/widgets/TextInputFormWidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_webservice/auth/Login.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/detail/ArchivesDetail.dart';
import 'package:flutter_webservice/detail/RoutinesMemosDetail.dart';
import 'package:flutter_webservice/input/RoutinesGroupsInput.dart';
import 'package:flutter_webservice/list/ArchivesList.dart';
import 'package:flutter_webservice/list/CustomRoutinesList.dart';
import 'package:flutter_webservice/input/ArchivesInput.dart';
import 'package:flutter_webservice/input/CustomRoutinesInput.dart';

import 'package:flutter_webservice/auth/SignUp.dart';
import 'package:flutter_webservice/auth/MemberInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_webservice/calendar/CalendarTwoChoice.dart';

class MyPageHome extends StatefulWidget {
  MyPageHome({Key? key}) : super(key: key);

  @override
  _MyPageHomestate createState() => _MyPageHomestate();
}

class _MyPageHomestate extends State<MyPageHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      appBar: AppBar(
        title: Text("MyPageHome"),
        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.person), onPressed: _awaitReturnAuth),
      ),
      body: Center(child: Container()),
    );
  }

  void _awaitReturnAuth() async {
    try {
      var httpGetMyInfo = await getMyInfo();
      print(httpGetMyInfo);
      var awaitResult = await Navigator.push(context, MaterialPageRoute(builder: (context) => MemberInfo(member: httpGetMyInfo)));
      if (awaitResult == 'success') {}
    } catch (e) {
      print(e);
      var result = await authenticationUser();
      if (result == 'success') {
        var httpGetMyInfo = await getMyInfo();
        var awaitResult = await Navigator.push(context, MaterialPageRoute(builder: (context) => MemberInfo(member: httpGetMyInfo)));
        if (awaitResult == 'success') {}
      } else if (result == 'fail') {
        var awaitResult = await Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
        if (awaitResult == 'success') {}
      }
    }
  }
}
