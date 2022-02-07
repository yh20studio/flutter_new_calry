import 'package:flutter/material.dart';

import '../../domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import '../../modalBottomSheet/todayRoutines/TodayRoutinesDetailModalBottomSheet.dart';
import '../../modalBottomSheet/todayRoutines/TodayRoutinesInputModalBottomSheet.dart';
import '../../domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';
import '../../domain/routines/Routines.dart';
import '../../domain/todayRoutines/TodayRoutines.dart';
import '../../widgets/MultiLineTextForListItemWidget.dart';
import '../../widgets/ContainerWidget.dart';

class TodayRoutinesEditList extends StatefulWidget {
  TodayRoutinesEditList(
      {Key? key,
      this.todayRoutinesGroups,
      this.routinesGroupsUnionList,
      this.routinesList,
      this.onRefreshChanged,
      this.onTodayRoutinesGroupsChanged})
      : super(key: key);

  final TodayRoutinesGroups? todayRoutinesGroups;
  final List<RoutinesGroupsUnions>? routinesGroupsUnionList;
  final List<Routines>? routinesList;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<TodayRoutinesGroups>? onTodayRoutinesGroupsChanged;

  @override
  _TodayRoutinesEditListstate createState() => _TodayRoutinesEditListstate();
}

class _TodayRoutinesEditListstate extends State<TodayRoutinesEditList> {
  TodayRoutinesGroups? todayRoutinesGroups;
  List<Routines>? routinesList;
  List<RoutinesGroupsUnions>? routinesGroupsUnionList;

  @override
  void initState() {
    super.initState();
    todayRoutinesGroups = widget.todayRoutinesGroups;
    routinesGroupsUnionList = widget.routinesGroupsUnionList;
    routinesList = widget.routinesList;
    widget.onRefreshChanged!('');
    widget.onTodayRoutinesGroupsChanged!(TodayRoutinesGroups());
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
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Theme.of(context).hoverColor)),
            Expanded(child: Center(child: Text("오늘 진행할 루틴", style: TextStyle(fontWeight: FontWeight.w700),))),
            IconButton(
                onPressed: () => _awaitReturnValueFromTodayRoutinesInput(),
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).hoverColor,
                )),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        overlayContainerWidget(
            widget: Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
                child: todayRoutinesGroups!.todayRoutinesList!.length == 0
                    ? Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text("매일 진행하는 루틴을 추가해 보세요!"),
                        ),
                      )
                    : Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: List.generate(
                            todayRoutinesGroups!.todayRoutinesList!.length,
                            (i) => listViewTodayRoutines(
                                index: i,
                                todayRoutines:
                                    todayRoutinesGroups!.todayRoutinesList![i],
                                width: _width,
                                context: context)).toList())),
            context: context),
        SizedBox(
          height: 30,
        ),
      ],
    )));
  }

  Widget listViewTodayRoutines(
      {required int index,
      required TodayRoutines todayRoutines,
      required double width,
      required BuildContext context}) {
    return InkWell(
        onTap: () =>
            _awaitReturnValueFromTodayRoutinesDetail(todayRoutines, index),
        child: multiLineTextForListItemWidget(
            width: width,
            text: todayRoutines.routines!.title!,
            context: context));
  }

  void _awaitReturnValueFromTodayRoutinesInput() async {
    var awaitResult = await todayRoutinesInputModalBottomSheet(context,
        widget.todayRoutinesGroups, routinesGroupsUnionList, routinesList!);
    print(awaitResult);
    if (awaitResult != null) {
      setState(() {
        if (awaitResult[0] == 'input') {
          todayRoutinesGroups = awaitResult[1];
          widget.onRefreshChanged!('input');
          widget.onTodayRoutinesGroupsChanged!(todayRoutinesGroups!);
        } else if (awaitResult[0] == 'delete') {
          widget.onRefreshChanged!('delete');
          widget.onTodayRoutinesGroupsChanged!(todayRoutinesGroups!);
        } else if (awaitResult[0] == 'refresh') {
          todayRoutinesGroups = awaitResult[1];
          widget.onRefreshChanged!('refresh');
          widget.onTodayRoutinesGroupsChanged!(todayRoutinesGroups!);
        }
      });
    }
  }

  void _awaitReturnValueFromTodayRoutinesDetail(
      TodayRoutines todayRoutines, int index) async {
    var awaitResult =
        await todayRoutinesDetailModalBottomSheet(todayRoutines, context);

    if (awaitResult != null) {
      if (awaitResult[0] == "update") {
        setState(() {
          todayRoutinesGroups!.todayRoutinesList![index] = awaitResult[1];
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onTodayRoutinesGroupsChanged!(awaitResult[1]);
        });
      } else if (awaitResult[0] == "delete") {
        setState(() {
          todayRoutinesGroups!.todayRoutinesList!.removeAt(index);
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onTodayRoutinesGroupsChanged!(todayRoutinesGroups!);
        });
      } else if (awaitResult[0] == "complete") {
        setState(() {
          todayRoutinesGroups!.todayRoutinesList!.removeAt(index);
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onTodayRoutinesGroupsChanged!(todayRoutinesGroups!);
        });
      }
    }
  }
}
