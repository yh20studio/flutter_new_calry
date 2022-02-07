import 'package:flutter/material.dart';

import '../../domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import '../../modalBottomSheet/routinesGroupsUnions/RoutinesGroupsUnionsEditListModalBottomSheet.dart';
import '../../controller/todayRoutines/TodayRoutinesController.dart';
import '../../controller/todayRoutinesGroups/TodayRoutinesGroupsController.dart';
import '../../domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';
import '../../domain/routinesGroups/RoutinesGroups.dart';
import '../../domain/todayRoutines/TodayRoutines.dart';
import '../../controller/jwt/JwtController.dart';
import '../../widgets/ContainerWidget.dart';

class RoutinesGroupsUnionsList extends StatefulWidget {
  RoutinesGroupsUnionsList(
      {Key? key,
      this.todayRoutinesGroups,
      this.routinesGroupsUnionsList,
      this.onRefreshChanged,
      this.onRoutinesGroupsChanged,
      this.onTodayRoutinesGroupsChanged})
      : super(key: key);

  final TodayRoutinesGroups? todayRoutinesGroups;
  final List<RoutinesGroupsUnions>? routinesGroupsUnionsList;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<RoutinesGroups>? onRoutinesGroupsChanged;
  final ValueChanged<TodayRoutinesGroups>? onTodayRoutinesGroupsChanged;

  @override
  _RoutinesGroupsUnionsListstate createState() =>
      _RoutinesGroupsUnionsListstate();
}

class _RoutinesGroupsUnionsListstate extends State<RoutinesGroupsUnionsList> {
  TodayRoutinesGroups? todayRoutinesGroups;
  List<RoutinesGroupsUnions>? routinesGroupsUnionsList;

  @override
  void initState() {
    super.initState();
    todayRoutinesGroups = widget.todayRoutinesGroups;
    routinesGroupsUnionsList = widget.routinesGroupsUnionsList;
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
              "루틴 그룹",
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
            TextButton(
              onPressed: () =>
                  _awaitReturnValueFromRoutinesGroupsUnionsEditList(),
              child: Text("편집"),
            ),
          ],
        )),
        SizedBox(height: 10,),
        overlayContainerWidget(
            context: context,
            widget: Container(
              padding: EdgeInsets.only(left: 10, right:10),
                child:Wrap(
                children: List.generate(
                    routinesGroupsUnionsList!.length,
                    (i) => listViewRoutinesGroupsUnion(
                        index: i,
                        routinesGroupsUnions: routinesGroupsUnionsList![i],
                        width: _width,
                        context: context)).toList()))),
      ],
    )));
  }

  Widget listViewRoutinesGroupsUnion(
      {required int index,
      required RoutinesGroupsUnions routinesGroupsUnions,
      required double width,
      required BuildContext context}) {
    return Container(
      width: width,
      padding: EdgeInsets.only(bottom: 5, top: 5),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(child: Text(routinesGroupsUnions.title!)),
            ],
          )),
          IconButton(
              onPressed: () => _httpPostTodayRoutinesList(routinesGroupsUnions),
              icon: Icon(Icons.add))
        ],
      ),
    );
  }

  void _httpPostTodayRoutinesList(
      RoutinesGroupsUnions routinesGroupsUnions) async {
    try {
      DateTime now = DateTime.now();
      List<TodayRoutines> todayRoutinesList = [];
      routinesGroupsUnions.routinesGroupsList!.forEach((routinesGroups) {
        TodayRoutines todayRoutines = TodayRoutines(
          finishTime: null,
          finish: false,
          routines: routinesGroups.routines!,
        );
        todayRoutinesList.add(todayRoutines);
      });
      List<TodayRoutines> httpResult = await postTodayRoutinesList(
          await getJwt(context),
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
          todayRoutinesList);

      setState(() {
        httpResult.forEach((element) {
          todayRoutinesGroups!.todayRoutinesList!.add(element);
        });

        widget.onRefreshChanged!("input");
        widget.onTodayRoutinesGroupsChanged!(todayRoutinesGroups!);
      });

      Navigator.pop(context, ["input", todayRoutinesGroups]);
    } catch (e) {
      print(e);
    }
  }

  void _awaitReturnValueFromRoutinesGroupsUnionsEditList() async {
    var awaitResult = await routinesGroupsUnionsEditListModalBottomSheet(
        context, routinesGroupsUnionsList!);

    if (awaitResult != null) {
      if (awaitResult[0] == "update" || awaitResult[0] == "delete") {
        TodayRoutinesGroups newTodayRoutinesGroups =
            await getTodayRoutinesGroups(await getJwt(context), DateTime.now());
        setState(() {
          todayRoutinesGroups = newTodayRoutinesGroups;
          widget.onRefreshChanged!("refresh");

          widget.onTodayRoutinesGroupsChanged!(todayRoutinesGroups!);
        });
      } else if (awaitResult[0] == "input") {
        setState(() {
          print("input");
        });
      }
    }
  }
}
