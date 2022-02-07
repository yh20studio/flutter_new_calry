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
import '../controller/jwt/JwtController.dart';

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
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.person),
                color: Theme.of(context).hoverColor,
                onPressed: _awaitReturnAuth)
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "루틴 지킴 현황",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                overlayContainerWidget(
                  context: context,
                  widget: FutureBuilder<Map<String, TodayRoutinesGroups>>(
                      future: futureGetAllTodayRoutinesGroups(),
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
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "빠른 일정 목록 보기",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                overlayPaddingContainerWidget(
                  context: context,
                  widget: FutureBuilder<List<QuickSchedules>>(
                      future: futureGetQuickSchedules(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          print('no data');
                          return Container();
                        } else if (snapshot.hasError) {
                          print('Error');
                          return Text('Error');
                        } else {
                          List<QuickSchedules> quickSchedulesList = snapshot.data;
                          return Row(
                            children: [
                              Expanded(child:Text(
                                  "${quickSchedulesList.length}", style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                              )),
                              IconButton(
                                onPressed: () => _awaitReturnValueFromQuickSchedulesEditList(quickSchedulesList),
                                icon: Icon(Icons.navigate_next_rounded),)
                            ],
                          );
                        }
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          "나의 루틴 목록 보기",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                overlayPaddingContainerWidget(
                  context: context,
                  widget: FutureBuilder<List<Routines>>(
                      future: futureGetRoutines(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          print('no data');
                          return Container();
                        } else if (snapshot.hasError) {
                          print('Error');
                          return Text('Error');
                        } else {
                          List<Routines> routinesList = snapshot.data;
                          return Row(
                            children: [
                              Expanded(child:Text(
                                "${routinesList.length}", style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                              )),
                              IconButton(
                                onPressed: () => _awaitReturnValueFromRoutinesEditList(routinesList),
                                icon: Icon(Icons.navigate_next_rounded),)
                            ],
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  Future<Map<String, TodayRoutinesGroups>>
      futureGetAllTodayRoutinesGroups() async {
    String jwt = await getJwt(context);
    return getAllTodayRoutinesGroups(jwt);
  }

  Future<List<QuickSchedules>> futureGetQuickSchedules() async {
    String jwt = await getJwt(context);
    return getQuickSchedules(jwt);
  }

  Future<List<Routines>> futureGetRoutines() async {
    String jwt = await getJwt(context);
    return getRoutines(jwt);
  }

  void _awaitReturnAuth() async {
    try {
      var httpGetMyInfo = await getMyInfo(await getJwt(context));
      print(httpGetMyInfo);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MemberInfo(member: httpGetMyInfo)));
    } catch (e) {
      print(e);
      var result = await authenticationUser();
      if (result == 'success') {
        var httpGetMyInfo = await getMyInfo(await getJwt(context));
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MemberInfo(member: httpGetMyInfo)));
      } else if (result == 'fail') {
        var awaitResult = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        if (awaitResult == 'success') {}
      }
    }
  }

  void _awaitReturnValueFromQuickSchedulesEditList(List<QuickSchedules> quickSchedulesList) async {
    await quickSchedulesEditListModalBottomSheet(context, quickSchedulesList);
  }

  void _awaitReturnValueFromRoutinesEditList(List<Routines> customRoutinesList) async {
    await routinesEditListModalBottomSheet(context, customRoutinesList);
  }
}
