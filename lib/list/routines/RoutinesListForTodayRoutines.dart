import 'package:flutter/material.dart';

import '../../domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import '../../modalBottomSheet/routines/RoutinesEditListModalBottomSheet.dart';
import '../../widgets/TimeDurationWidget.dart';
import '../../controller/todayRoutines/TodayRoutinesController.dart';
import '../../controller/todayRoutinesGroups/TodayRoutinesGroupsController.dart';
import '../../domain/routines/Routines.dart';
import '../../domain/todayRoutines/TodayRoutines.dart';
import '../../controller/jwt/JwtController.dart';
import '../../widgets/ContainerWidget.dart';

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
        SizedBox(height: 10,),
        overlayContainerWidget(
          context: context,
          widget: Container(
              padding: EdgeInsets.only(top:5, bottom:5, left: 10, right:10),
              child: Wrap(
                children: List.generate(routinesList!.length, (i) => listViewRoutines(index: i, routines: routinesList![i], width: _width, context: context))
                    .toList()))),
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
                  Expanded(child: Text(routines.title!)),
                ],
              ),
              routines.duration == 0 ? SizedBox() : simpleTimeDurationWidget(routines: routines, context: context),
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
        date: "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      );
      TodayRoutines httpResult = await postTodayRoutines(await getJwt(context), todayRoutines);
      widget.todayRoutinesGroups!.todayRoutinesList!.add(httpResult);
      Navigator.pop(context, ["input", widget.todayRoutinesGroups]);
    } catch (e) {
      print(e);
    }
  }

  void _awaitReturnValueFromRoutinesEditList() async {
    var awaitResult = await routinesEditListModalBottomSheet(context, routinesList!);
    if (awaitResult != null) {
      if (awaitResult[0] == "update" || awaitResult[0] == "delete") {
        TodayRoutinesGroups newTodayRoutinesGroups = await getTodayRoutinesGroups(await getJwt(context), DateTime.now());

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
