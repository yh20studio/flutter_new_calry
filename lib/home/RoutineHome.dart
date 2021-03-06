import 'package:flutter/material.dart';

import 'todayRoutinesGroups.dart/TodayRoutinesGroupsHome.dart';
import '../controller/focusTodos/FocusTodosController.dart';
import '../domain/focusTodos/FocusTodos.dart';
import '../domain/schedules/Schedules.dart';
import '../list/schedules/SchedulesList.dart';
import '../widgets/DateWidget.dart';
import '../controller/todayRoutinesGroups/TodayRoutinesGroupsController.dart';
import '../controller/schedules/SchedulesController.dart';
import '../domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import '../list/focusTodos/FocusTodosList.dart';
import '../controller/jwt/JwtController.dart';

class RoutineHome extends StatefulWidget {
  RoutineHome({Key? key}) : super(key: key);

  @override
  _RoutineHomestate createState() => _RoutineHomestate();
}

class _RoutineHomestate extends State<RoutineHome> {
  Future<TodayRoutinesGroups>? futureTodayRoutinesGroups;

  TodayRoutinesGroups? todayRoutinesGroups;

  @override
  void initState() {
    super.initState();
    futureTodayRoutinesGroups = futureGetTodayRoutinesGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: appBarMonthDayWeekdayDateWidget(
              datetime: DateTime.now(), context: context),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<TodayRoutinesGroups>(
                      future: futureTodayRoutinesGroups,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          todayRoutinesGroups = snapshot.data!;
                          return TodayRoutinesGroupsHome(
                            todayRoutinesGroups: todayRoutinesGroups,
                            onRefreshChanged: (onRefreshChanged) {},
                            onTodayRoutinesGroupsChanged:
                                (onTodayRoutinesGroupsChanged) {
                              todayRoutinesGroups =
                                  onTodayRoutinesGroupsChanged;
                            },
                          );
                        }
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  FutureBuilder<List<FocusTodos>>(
                      future: futureGetFocusTodos(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          if (snapshot.data!.length != 0) {}
                          return FocusTodosList(
                            date: DateTime.now(),
                            focusTodosList: snapshot.data!,
                          );
                        }
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  FutureBuilder<List<Schedules>>(
                      future: futureGetDaySchedules(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          if (snapshot.data!.length != 0) {}
                          return SchedulesList(
                            date: DateTime.now(),
                            scheduleList: snapshot.data!,
                          );
                        }
                      }),
                ],
              )),
        ));
  }

  Future<TodayRoutinesGroups> futureGetTodayRoutinesGroups() async {
    String jwt = await getJwt(context);
    return getTodayRoutinesGroups(jwt, DateTime.now());
  }

  Future<List<FocusTodos>> futureGetFocusTodos() async {
    String jwt = await getJwt(context);
    return getFocusTodos(jwt);
  }

  Future<List<Schedules>> futureGetDaySchedules() async {
    String jwt = await getJwt(context);
    return getDaySchedules(jwt);
  }
}
