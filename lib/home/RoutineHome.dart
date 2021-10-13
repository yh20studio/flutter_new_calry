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

class RoutineHome extends StatefulWidget {
  RoutineHome({Key? key}) : super(key: key);

  @override
  _RoutineHomestate createState() => _RoutineHomestate();
}

class _RoutineHomestate extends State<RoutineHome> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

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
        title: Text('Input'),
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        children: [
          TextButton(onPressed: _toArchivesList, child: Text('Archives 리스트')),
          TextButton(
              child: Text("루틴그룹 추가"),
              onPressed: _awaitReturnValueFromRoutinesGroupsInput),
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

  void _awaitReturnValueFromRoutinesGroupsInput() async {
    var awaitResult = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => RoutinesGroupsInput()));
    if (awaitResult != 'success') {
      setState(() {});
    }
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
}
