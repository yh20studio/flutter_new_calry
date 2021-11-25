import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_new_calry/modalBottomSheet/routines/RoutinesEditListModalBottomSheet.dart';
import 'package:flutter_new_calry/domain/routines/Routines.dart';

class RoutinesListForRoutinesGroups extends StatefulWidget {
  RoutinesListForRoutinesGroups({Key? key, this.routinesList}) : super(key: key);

  final List<Routines>? routinesList;

  @override
  _RoutinesListForRoutinesGroupsstate createState() => _RoutinesListForRoutinesGroupsstate();
}

class _RoutinesListForRoutinesGroupsstate extends State<RoutinesListForRoutinesGroups> {
  List<Routines>? routinesList;

  @override
  void initState() {
    super.initState();
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
              "그룹에 넣을 나의 루틴",
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
            TextButton(
              onPressed: () => _awaitReturnValueFromRoutinesEditList(),
              child: Text("편집"),
            ),
          ],
        )),
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
    return InkWell(
        onTap: () => _selectRoutines(routines),
        child: Container(
            width: width,
            padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(routines.title!),
                  )
                ],
              ),
              routines.duration == 0
                  ? SizedBox()
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                              child: Icon(
                            Icons.timer_rounded,
                            size: 17,
                          )),
                          Text(":"),
                          routines.timeDuration!.hour == 0
                              ? SizedBox()
                              : Text(
                                  "${routines.timeDuration!.hour} 시간",
                                  style: TextStyle(fontSize: 17),
                                ),
                          routines.timeDuration!.min == 0
                              ? SizedBox()
                              : Text(
                                  "${routines.timeDuration!.min} 분",
                                  style: TextStyle(fontSize: 17),
                                ),
                          routines.timeDuration!.sec == 0
                              ? SizedBox()
                              : Text(
                                  "${routines.timeDuration!.sec} 초",
                                  style: TextStyle(fontSize: 17),
                                ),
                        ],
                      ),
                    )
            ])));
  }

  void _selectRoutines(Routines routines) async {
    Navigator.pop(context, ["add", routines]);
  }

  void _awaitReturnValueFromRoutinesEditList() async {
    var awaitResult = await routinesEditListModalBottomSheet(context, routinesList!);

    if (awaitResult != null) {
      if (awaitResult[0] == "update" || awaitResult[0] == "delete") {
        setState(() {});
      }
    }
  }
}
