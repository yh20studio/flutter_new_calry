import 'package:flutter/material.dart';

import '../../domain/todayRoutinesGroups/TodayRoutinesGroups.dart';
import '../../modalBottomSheet/todayRoutines/TodayRoutinesEditListModalBottomSheet.dart';
import '../../modalBottomSheet/todayRoutines/TodayRoutinesDetailModalBottomSheet.dart';
import '../../widgets/ContainerWidget.dart';
import '../../controller/routinesGroupsUnion/RoutinesGroupsUnionsController.dart';
import '../../controller/routines/RoutinesController.dart';
import '../../domain/routines/Routines.dart';
import '../../domain/todayRoutines/TodayRoutines.dart';
import '../../domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';
import '../../widgets/MultiLineTextForListItemWidget.dart';
import '../../controller/jwt/JwtController.dart';

class TodayRoutinesGroupsHome extends StatefulWidget {
  TodayRoutinesGroupsHome(
      {Key? key,
      this.todayRoutinesGroups,
      this.onRefreshChanged,
      this.onTodayRoutinesGroupsChanged})
      : super(key: key);

  final TodayRoutinesGroups? todayRoutinesGroups;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<TodayRoutinesGroups>? onTodayRoutinesGroupsChanged;

  @override
  _TodayRoutinesGroupsHomestate createState() =>
      _TodayRoutinesGroupsHomestate();
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
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
              IconButton(
                  onPressed: () =>
                      _awaitReturnValueFromTodayRoutinesGroupsEditList(),
                  icon: Icon(Icons.navigate_next_sharp)),
            ],
          )),
      SizedBox(height: 5),
      overlayContainerWidget(
          widget: FutureBuilder<List<RoutinesGroupsUnions>>(
              future: futureGetRoutinesGroupsUnions(),
              builder:
                  (BuildContext context, AsyncSnapshot snapshotRoutinesGroup) {
                if (!snapshotRoutinesGroup.hasData) {
                  return Container();
                } else if (snapshotRoutinesGroup.hasError) {
                  return Text('Error');
                } else {
                  routinesGroupsUnionList = snapshotRoutinesGroup.data!;
                  return FutureBuilder<List<Routines>>(
                      future: futureGetRoutines(),
                      builder: (BuildContext context,
                          AsyncSnapshot snapshotRoutines) {
                        if (!snapshotRoutines.hasData) {
                          return Container();
                        } else if (snapshotRoutines.hasError) {
                          return Text('Error');
                        } else {
                          routinesList = snapshotRoutines.data!;
                          return Column(
                            children: [
                              todayRoutinesGroups!.todayRoutinesList!.length ==
                                      0
                                  ? Container(
                                      padding: EdgeInsets.all(20),
                                      child: Center(
                                        child: Text("매일 진행하는 루틴을 추가해 보세요!"),
                                      ),
                                    )
                                  : Container(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Wrap(
                                          spacing: 8.0,
                                          // gap between adjacent chips
                                          runSpacing: 4.0,
                                          // gap between lines
                                          children: List.generate(
                                              todayRoutinesGroups!
                                                  .todayRoutinesList!.length,
                                              (i) => listViewTodayRoutines(
                                                  index: i,
                                                  todayRoutines:
                                                      todayRoutinesGroups!
                                                          .todayRoutinesList![i],
                                                  width: _width,
                                                  context: context)).toList())),
                            ],
                          );
                        }
                      });
                }
              }),
          context: context),
    ]);
  }

  Future<List<RoutinesGroupsUnions>> futureGetRoutinesGroupsUnions() async {
    String jwt = await getJwt(context);
    return getRoutinesGroupsUnions(jwt);
  }

  Future<List<Routines>> futureGetRoutines() async {
    String jwt = await getJwt(context);
    return getRoutines(jwt);
  }

  Widget listViewTodayRoutines(
      {required int index,
      required TodayRoutines todayRoutines,
      required double width,
      required BuildContext context}) {
    return InkWell(
        onTap: () {
          void _awaitReturnValueFromTodayRoutinesDetail() async {
            var awaitResult = await todayRoutinesDetailModalBottomSheet(
                todayRoutines, context);

            if (awaitResult != null) {
              if (awaitResult[0] == "update") {
                setState(() {
                  todayRoutinesGroups!.todayRoutinesList![index] =
                      awaitResult[1];
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
        child: multiLineTextForListItemWidget(
            width: width,
            text: todayRoutines.routines!.title!,
            context: context));
  }

  void _awaitReturnValueFromTodayRoutinesGroupsEditList() async {
    var awaitResult = await todayRoutinesEditListModalBottomSheet(
        context, todayRoutinesGroups, routinesGroupsUnionList!, routinesList!);
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
