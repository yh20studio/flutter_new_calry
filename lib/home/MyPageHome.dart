import 'package:flutter/material.dart';

import '../domain/quickSchedules/QuickSchedules.dart';
import '../auth/Login.dart';
import '../auth/MemberInfo.dart';
import '../modalBottomSheet/routines/RoutinesEditListModalBottomSheet.dart';
import '../modalBottomSheet/quickSchedules/QuickSchedulesEditListModalBottomSheet.dart';
import '../calendar/CalendarWithColors.dart';
import '../widgets/ContainerWidget.dart';
import '../controller/member/MemberController.dart';
import '../controller/todayRoutinesGroups/TodayRoutinesGroupsController.dart';
import '../controller/quickSchedules/QuickSchedulesController.dart';
import '../controller/routines/RoutinesController.dart';
import '../domain/routines/Routines.dart';
import '../domain/todayRoutinesGroups/TodayRoutinesGroups.dart';

class MyPageHome extends StatefulWidget {
  MyPageHome({
    Key? key,
  }) : super(key: key);
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
      await Navigator.push(context, MaterialPageRoute(builder: (context) => MemberInfo(member: httpGetMyInfo)));
    } catch (e) {
      print(e);
      var result = await authenticationUser();
      if (result == 'success') {
        var httpGetMyInfo = await getMyInfo();
        await Navigator.push(context, MaterialPageRoute(builder: (context) => MemberInfo(member: httpGetMyInfo)));
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
