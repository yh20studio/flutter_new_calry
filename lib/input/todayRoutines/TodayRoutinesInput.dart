import 'package:flutter/material.dart';

import '../../domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import '../../list/routinesGroupsUnions/RoutinesGroupsUnionsList.dart';
import '../../list/routines/RoutinesListForTodayRoutines.dart';
import '../../domain/routines/Routines.dart';
import '../../domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';

class TodayRoutinesInput extends StatefulWidget {
  TodayRoutinesInput(
      {Key? key,
      this.todayRoutinesGroups,
      this.routinesGroupsUnionsList,
      this.routinesList,
      this.onTodayRoutinesGroupsChanged})
      : super(key: key);
  final TodayRoutinesGroups? todayRoutinesGroups;
  final List<RoutinesGroupsUnions>? routinesGroupsUnionsList;
  final List<Routines>? routinesList;
  final ValueChanged<TodayRoutinesGroups>? onTodayRoutinesGroupsChanged;

  @override
  _TodayRoutinesInputstate createState() => _TodayRoutinesInputstate();
}

class _TodayRoutinesInputstate extends State<TodayRoutinesInput> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Text("오늘 진행할 루틴 추가", style: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w700),),),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Theme.of(context).backgroundColor)),
              ],
            )),
        Container(
            padding: EdgeInsets.all(20),
            child: RoutinesGroupsUnionsList(
              todayRoutinesGroups: widget.todayRoutinesGroups,
              routinesGroupsUnionsList: widget.routinesGroupsUnionsList,
              onRefreshChanged: (refreshChanged) {
                if (refreshChanged == "input") {
                  setState(() {});
                }
              },
              onTodayRoutinesGroupsChanged: (todayRoutinesGroups) {
                if (todayRoutinesGroups != null) {
                  setState(() {
                    widget.onTodayRoutinesGroupsChanged!(todayRoutinesGroups);
                  });
                }
              },
            )),
        SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: RoutinesListForTodayRoutines(
          todayRoutinesGroups: widget.todayRoutinesGroups,
          routinesList: widget.routinesList,
          onRefreshChanged: (refreshChanged) {
            if (refreshChanged == "input") {
              setState(() {});
            }
          },
          onTodayRoutinesGroupsChanged: (todayRoutinesGroups) {
            if (todayRoutinesGroups != null) {
              setState(() {
                widget.onTodayRoutinesGroupsChanged!(todayRoutinesGroups);
              });
            }
          },
        )),
      ],
    )));
  }
}
