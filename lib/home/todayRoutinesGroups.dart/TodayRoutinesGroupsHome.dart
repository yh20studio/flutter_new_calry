import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_new_calry/modalBottomSheet/todayRoutines/TodayRoutinesEditListModalBottomSheet.dart';
import 'package:flutter_new_calry/modalBottomSheet/todayRoutines/TodayRoutinesDetailModalBottomSheet.dart';
import 'package:flutter_new_calry/widgets/ContainerWidget.dart';
import 'package:flutter_new_calry/controller/routinesGroupsUnion/RoutinesGroupsUnionsController.dart';
import 'package:flutter_new_calry/controller/routines/RoutinesController.dart';
import 'package:flutter_new_calry/domain/routines/Routines.dart';
import 'package:flutter_new_calry/domain/todayRoutines/TodayRoutines.dart';
import 'package:flutter_new_calry/domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';

class TodayRoutinesGroupsHome extends StatefulWidget {
  TodayRoutinesGroupsHome({Key? key, this.todayRoutinesGroups, this.onRefreshChanged, this.onTodayRoutinesGroupsChanged}) : super(key: key);

  final TodayRoutinesGroups? todayRoutinesGroups;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<TodayRoutinesGroups>? onTodayRoutinesGroupsChanged;

  @override
  _TodayRoutinesGroupsHomestate createState() => _TodayRoutinesGroupsHomestate();
}

class _TodayRoutinesGroupsHomestate extends State<TodayRoutinesGroupsHome> {
  TodayRoutinesGroups? todayRoutinesGroups;
  List<Routines>? routinesList;
  List<RoutinesGroupsUnions>? routinesGroupsUnionList;

  @override
  void initState() {
    super.initState();
    todayRoutinesGroups = widget.todayRoutinesGroups;

    widget.onRefreshChanged!('');
    widget.onTodayRoutinesGroupsChanged!(TodayRoutinesGroups());
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return borderPaddingTitleContainerWidget(
        title: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Center(
                      child: Text(
                    "남아있는 나의 루틴",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  )),
                ),
                IconButton(onPressed: () => _awaitReturnValueFromTodayRoutinesGroupsEditList(), icon: Icon(Icons.navigate_next_sharp)),
              ],
            )),
        widget: FutureBuilder<List<RoutinesGroupsUnions>>(
            future: getRoutinesGroupsUnions(),
            builder: (BuildContext context, AsyncSnapshot snapshotRoutinesGroup) {
              if (!snapshotRoutinesGroup.hasData) {
                print('no data');
                return Container();
              } else if (snapshotRoutinesGroup.hasError) {
                print('Error');
                return Text('Error');
              } else {
                routinesGroupsUnionList = snapshotRoutinesGroup.data!;
                return FutureBuilder<List<Routines>>(
                    future: getRoutines(),
                    builder: (BuildContext context, AsyncSnapshot snapshotRoutines) {
                      if (!snapshotRoutines.hasData) {
                        print('no data');
                        return Container();
                      } else if (snapshotRoutines.hasError) {
                        print('Error');
                        return Text('Error');
                      } else {
                        routinesList = snapshotRoutines.data!;
                        return Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            todayRoutinesGroups!.todayRoutinesList!.length == 0
                                ? Container(
                                    child: Center(
                                      child: Text("매일 진행하는 루틴을 추가해보세요!"),
                                    ),
                                  )
                                : Container(
                                    child: Wrap(
                                        spacing: 8.0, // gap between adjacent chips
                                        runSpacing: 4.0, // gap between lines
                                        children: List.generate(
                                            todayRoutinesGroups!.todayRoutinesList!.length,
                                            (i) => listViewTodayRoutines(
                                                index: i,
                                                todayRoutines: todayRoutinesGroups!.todayRoutinesList![i],
                                                width: _width,
                                                context: context)).toList())),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }
                    });
              }
            }),
        context: context);
  }

  Widget listViewTodayRoutines({required int index, required TodayRoutines todayRoutines, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _awaitReturnValueFromTodayRoutinesDetail() async {
            var awaitResult = await todayRoutinesDetailModalBottomSheet(todayRoutines, context);

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

          _awaitReturnValueFromTodayRoutinesDetail();
        },
        child: Container(
            width: width,
            padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(todayRoutines.routines!.title!),
                  ),
                ],
              )
            ])));
  }

  void _awaitReturnValueFromTodayRoutinesGroupsEditList() async {
    var awaitResult = await todayRoutinesEditListModalBottomSheet(context, todayRoutinesGroups, routinesGroupsUnionList!, routinesList!);
    print(awaitResult);
    if (awaitResult != null) {
      setState(() {
        if (awaitResult[0] == "input") {
          widget.onRefreshChanged!('input');
          widget.onTodayRoutinesGroupsChanged!(awaitResult[1]);
        } else if (awaitResult[0] == "refresh") {
          todayRoutinesGroups = awaitResult[1];
          widget.onRefreshChanged!('refresh');
          widget.onTodayRoutinesGroupsChanged!(awaitResult[1]);
        }
      });
    }
  }
}
