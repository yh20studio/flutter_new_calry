import 'package:flutter/material.dart';

import '../../widgets/TimeDurationWidget.dart';
import '../../widgets/ContainerWidget.dart';
import '../../widgets/DateWidget.dart';
import '../../modalBottomSheet/routinesMemos/RoutinesMemosInputModalBottomSheet.dart';
import '../../modalBottomSheet/routinesMemos/RoutinesMemosDetailModalBottomSheet.dart';
import '../../controller/todayRoutines/TodayRoutinesController.dart';
import '../../domain/routinesMemos/RoutinesMemos.dart';
import '../../domain/timeDuration/TimeDuration.dart';
import '../../domain/todayRoutines/TodayRoutines.dart';
import '../../controller/jwt/JwtController.dart';

class TodayRoutinesDetail extends StatefulWidget {
  TodayRoutinesDetail({Key? key, this.todayRoutines}) : super(key: key);

  final TodayRoutines? todayRoutines;

  @override
  _TodayRoutinesDetailstate createState() => _TodayRoutinesDetailstate();
}

class _TodayRoutinesDetailstate extends State<TodayRoutinesDetail> {
  TodayRoutines? todayRoutines;
  String? popResult = "";
  List<RoutinesMemos> routines_memosList = [];

  @override
  void initState() {
    todayRoutines = widget.todayRoutines!;
    routines_memosList = widget.todayRoutines!.routines!.routines_memosList!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Container(
                child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(child: Text("오늘 완료"), onPressed: () => _httpUpdateTodayRoutines()),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        borderPaddingContainerWidget(context: context, widget: Text(widget.todayRoutines!.routines!.title!)),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
            context: context,
            widget: durationInputForm(
              timeDuration: todayRoutines!.routines!.timeDuration!,
              context: context,
            )),
        SizedBox(
          height: 20,
        ),
        borderPaddingContainerWidget(
            context: context,
            widget: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("메모"),
                  TextButton(
                    onPressed: () => _awaitReturnValueFromRoutinesMemosInput(),
                    child: Text("추가"),
                  )
                ],
              ),
              Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: List.generate(routines_memosList.length,
                      (i) => listViewRoutinesMemos(index: i, routinesMemos: routines_memosList[i], width: _width, context: context)).toList())
            ])),
        SizedBox(
          height: 20,
        ),
        TextButton(child: Text("다음에 하기", style: TextStyle(color: Colors.red)), onPressed: _httpDeleteTodayRoutines),
      ],
    ))));
  }

  Widget durationInputForm({required TimeDuration timeDuration, required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        simpleTimeDurationWidget(routines: widget.todayRoutines!.routines!, context: context),
      ],
    );
  }

  Widget listViewRoutinesMemos({required int? index, required RoutinesMemos? routinesMemos, required double? width, required BuildContext context}) {
    // widget layout for listview items
    return InkWell(
        onTap: () => _awaitReturnValueFromRoutinesMemosDetail(context, routinesMemos!, index!),
        child: Container(
            decoration: new BoxDecoration(
                border: Border(
              top: BorderSide(width: 0.1, color: Theme.of(context).canvasColor),
            )),
            width: width! * 0.8,
            padding: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  monthDayDateWidget(datetime: routinesMemos!.created_date, context: context),
                ]),
                SizedBox(
                  height: 10,
                ),
                Text("${routinesMemos.content}")
              ],
            )));
  }

  void _awaitReturnValueFromRoutinesMemosDetail(BuildContext context, RoutinesMemos routinesMemos, int index) async {
    var awaitResult = await routinesMemosDetailModalBottomSheet(routinesMemos, context);
    if (awaitResult != null) {
      if (awaitResult[0] == "delete") {
        setState(() {
          routines_memosList.removeAt(index);
          popResult = "update";
        });
      } else if (awaitResult[0] == "update") {
        setState(() {
          routines_memosList[index] = awaitResult[1];
          popResult = "update";
        });
      }
    }
  }

  void _httpUpdateTodayRoutines() async {
    try {
      var httpResult = await updateTodayRoutines(await getJwt(context), todayRoutines!);
      Navigator.pop(context, ["complete", httpResult]);
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _httpDeleteTodayRoutines() async {
    try {
      await deleteTodayRoutines(await getJwt(context), todayRoutines!);
      Navigator.pop(context, ["delete", todayRoutines]);
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void _awaitReturnValueFromRoutinesMemosInput() async {
    var awaitResult = await routinesMemosInputModalBottomSheet(todayRoutines!.routines!, context);
    if (awaitResult != null) {
      setState(() {
        widget.todayRoutines!.routines!.routines_memosList!.add(awaitResult);
      });
    }
  }
}
