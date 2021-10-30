import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/quickSchedules/QuickSchedules.dart';
import 'package:flutter_new_calry/auth/Login.dart';
import 'package:flutter_new_calry/auth/MemberInfo.dart';
import 'package:flutter_new_calry/modalBottomSheet/routines/RoutinesEditListModalBottomSheet.dart';
import 'package:flutter_new_calry/modalBottomSheet/quickSchedules/QuickSchedulesEditListModalBottomSheet.dart';
import 'package:flutter_new_calry/calendar/CalendarWithColors.dart';
import 'package:flutter_new_calry/widgets/ContainerWidget.dart';
import 'package:flutter_new_calry/controller/member/MemberController.dart';
import 'package:flutter_new_calry/controller/todayRoutinesGroups/TodayRoutinesGroupsController.dart';
import 'package:flutter_new_calry/controller/quickSchedules/QuickSchedulesController.dart';
import 'package:flutter_new_calry/controller/routines/RoutinesController.dart';
import 'package:flutter_new_calry/domain/routines/Routines.dart';
import 'package:flutter_new_calry/domain/todayRoutinesGroups/TodayRoutinesGroups.dart';

class MyPageHome extends StatefulWidget {
  MyPageHome({Key? key, this.onLoginChanged}) : super(key: key);

  final ValueChanged<bool>? onLoginChanged;
  @override
  _MyPageHomestate createState() => _MyPageHomestate();
}

class _MyPageHomestate extends State<MyPageHome> {
  Map<String, TodayRoutinesGroups> todayRoutinesGroupsMap = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: Text(
            "Calry",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [IconButton(icon: Icon(Icons.person), color: Colors.black, onPressed: _awaitReturnAuth)],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                borderPaddingTitleContainerWidget(
                    title: Text(
                      "루틴 지킴 현황",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    widget: FutureBuilder<Map<String, TodayRoutinesGroups>>(
                        future: getAllTodayRoutinesGroups(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            print('no data');
                            return Container();
                          } else if (snapshot.hasError) {
                            print('Error');
                            return Text('Error');
                          } else {
                            todayRoutinesGroupsMap = snapshot.data;
                            return CalendarWithColors(
                              selectedDateTime: DateTime.now(),
                              todayRoutinesGroupsMap: todayRoutinesGroupsMap,
                            );
                          }
                        }),
                    context: context),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: _awaitReturnValueFromQuickSchedulesEditList,
                  child: Row(
                    children: [
                      Text(
                        "빠른 일정 목록 보기",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.navigate_next_rounded)
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: _awaitReturnValueFromRoutinesEditList,
                  child: Row(
                    children: [
                      Text(
                        "나의 루틴 목록 보기",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.navigate_next_rounded)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _awaitReturnAuth() async {
    try {
      var httpGetMyInfo = await getMyInfo();
      print(httpGetMyInfo);
      var awaitResult = await Navigator.push(context, MaterialPageRoute(builder: (context) => MemberInfo(member: httpGetMyInfo)));
      if (awaitResult == 'logout') {
        setState(() {
          widget.onLoginChanged!(false);
        });
      }
    } catch (e) {
      print(e);
      var result = await authenticationUser();
      if (result == 'success') {
        var httpGetMyInfo = await getMyInfo();
        var awaitResult = await Navigator.push(context, MaterialPageRoute(builder: (context) => MemberInfo(member: httpGetMyInfo)));
        if (awaitResult == 'logout') {
          setState(() {
            widget.onLoginChanged!(false);
          });
        }
      } else if (result == 'fail') {
        var awaitResult = await Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
        if (awaitResult == 'success') {}
      }
    }
  }

  void _awaitReturnValueFromQuickSchedulesEditList() async {
    List<QuickSchedules> quickSchedulesList = await getQuickSchedules();
    await quickSchedulesEditListModalBottomSheet(context, quickSchedulesList);
  }

  void _awaitReturnValueFromRoutinesEditList() async {
    List<Routines> customRoutinesList = await getRoutines();
    await routinesEditListModalBottomSheet(context, customRoutinesList);
  }
}
