import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_new_calry/modalBottomSheet/routines/RoutinesEditListModalBottomSheet.dart';
import 'package:flutter_new_calry/widgets/TimeDurationWidget.dart';
import 'package:flutter_new_calry/controller/todayRoutines/TodayRoutinesController.dart';
import 'package:flutter_new_calry/controller/todayRoutinesGroups/TodayRoutinesGroupsController.dart';
import 'package:flutter_new_calry/domain/routines/Routines.dart';
import 'package:flutter_new_calry/domain/todayRoutines/TodayRoutines.dart';

class RoutinesListForTodayRoutines extends StatefulWidget {
  RoutinesListForTodayRoutines({Key? key, this.todayRoutinesGroups, this.routinesList, this.onRefreshChanged, this.onTodayRoutinesGroupsChanged})
      : super(key: key);

  final TodayRoutinesGroups? todayRoutinesGroups;
  final List<Routines>? routinesList;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<TodayRoutinesGroups>? onTodayRoutinesGroupsChanged;

  @override
  _RoutinesListForTodayRoutinesstate createState() => _RoutinesListForTodayRoutinesstate();
}

class _RoutinesListForTodayRoutinesstate extends State<RoutinesListForTodayRoutines> {
  TodayRoutinesGroups? todayRoutinesGroups;
  List<Routines>? routinesList;

  @override
  void initState() {
    super.initState();
    todayRoutinesGroups = widget.todayRoutinesGroups;
    routinesList = widget.routinesList;
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              "루틴",
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
            TextButton(
              onPressed: () => _awaitReturnValueFromRoutinesEditList(),
              child: Text("편집"),
            ),
          ],
        )),
        Divider(
          height: 5,
          color: Colors.black,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List.generate(routinesList!.length, (i) => listViewRoutines(index: i, routines: routinesList![i], width: _width, context: context))
                    .toList()))
      ],
    )));
  }

  Widget listViewRoutines({required int index, required Routines routines, required double width, required BuildContext context}) {
    return Container(
        width: width,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(routines.title!),
                ],
              ),
              simpleTimeDurationWidget(routines: routines, context: context),
            ])),
            IconButton(onPressed: () => _httpPostTodayRoutines(routines), icon: Icon(Icons.add)),
          ],
        ));
  }

  void _httpPostTodayRoutines(Routines routines) async {
    try {
      DateTime now = DateTime.now();
      TodayRoutines todayRoutines = TodayRoutines(
        finishTime: null,
        finish: false,
        routines: routines,
        date: "${now.year}-${now.month}-${now.day}",
      );
      TodayRoutines httpResult = await postTodayRoutines(todayRoutines);
      widget.todayRoutinesGroups!.todayRoutinesList!.add(httpResult);
      Navigator.pop(context, ["input", widget.todayRoutinesGroups]);
    } catch (e) {
      print(e);
    }
  }

  void _awaitReturnValueFromRoutinesEditList() async {
    var awaitResult = await routinesEditListModalBottomSheet(context, routinesList!);
    print(awaitResult);
    if (awaitResult != null) {
      if (awaitResult[0] == "update" || awaitResult[0] == "delete") {
        TodayRoutinesGroups newTodayRoutinesGroups = await getTodayRoutinesGroups(DateTime.now());

        setState(() {
          routinesList = awaitResult[1];
          todayRoutinesGroups = newTodayRoutinesGroups;
          widget.onRefreshChanged!("refresh");
          widget.onTodayRoutinesGroupsChanged!(newTodayRoutinesGroups);
        });
      } else if (awaitResult[0] == "input") {
        setState(() {
          routinesList = awaitResult[1];
        });
      }
    }
  }
}
