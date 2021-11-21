import 'package:flutter/material.dart';
import 'package:flutter_new_calry/controller/focusTodos/FocusTodosController.dart';
import 'package:flutter_new_calry/domain/focusTodos/FocusTodos.dart';
import 'package:flutter_new_calry/domain/schedules/Schedules.dart';
import 'package:flutter_new_calry/list/schedules/SchedulesList.dart';
import 'todayRoutinesGroups.dart/TodayRoutinesGroupsHome.dart';
import 'package:flutter_new_calry/widgets/DateWidget.dart';
import 'package:flutter_new_calry/controller/todayRoutinesGroups/TodayRoutinesGroupsController.dart';
import 'package:flutter_new_calry/controller/schedules/SchedulesController.dart';
import 'package:flutter_new_calry/domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import 'package:flutter_new_calry/list/focusTodos/FocusTodosList.dart';

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
    futureTodayRoutinesGroups = getTodayRoutinesGroups(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: monthDayWeekdayDateWidget(datetime: DateTime.now(), context: context),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<TodayRoutinesGroups>(
                      future: futureTodayRoutinesGroups,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          print('no data');
                          return Container();
                        } else if (snapshot.hasError) {
                          print('Error');
                          return Text('Error');
                        } else {
                          todayRoutinesGroups = snapshot.data!;
                          return TodayRoutinesGroupsHome(
                            todayRoutinesGroups: todayRoutinesGroups,
                            onRefreshChanged: (onRefreshChanged) {},
                            onTodayRoutinesGroupsChanged: (onTodayRoutinesGroupsChanged) {
                              todayRoutinesGroups = onTodayRoutinesGroupsChanged;
                            },
                          );
                        }
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  FutureBuilder<List<FocusTodos>>(
                      future: getFocusTodos(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          print('no data');
                          return Container();
                        } else if (snapshot.hasError) {
                          print('Error');
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
                      future: getDaySchedules(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          print('no data');
                          return Container();
                        } else if (snapshot.hasError) {
                          print('Error');
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
}
