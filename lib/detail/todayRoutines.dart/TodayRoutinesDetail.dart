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
        Container(
            padding: EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.close,
                        color: Theme.of(context).backgroundColor),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Expanded(
                  child: Center(child:Text(
                    "남은 루틴",
                    style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontWeight: FontWeight.w700),
                  )),
                ),
                TextButton(
                    child: Text("완료",
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                        )),
                    onPressed: () => _httpUpdateTodayRoutines()),
              ],
            )),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Title",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: overlayPaddingContainerWidget(
              context: context,
              widget: Text(widget.todayRoutines!.routines!.title!)),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Duration",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 10,
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: overlayPaddingContainerWidget(
                context: context,
                widget: durationInputForm(
                  timeDuration: todayRoutines!.routines!.timeDuration!,
                  context: context,
                ))),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Memo",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () => _awaitReturnValueFromRoutinesMemosInput(),
                  child: Text("추가"),
                )
              ],
            )),
        Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: overlayPaddingContainerWidget(
                context: context,
                widget: routines_memosList.length == 0
                    ? Container(
                  padding: EdgeInsets.all(10),
                  child: Center(child: Text("메모를 추가해보세요!",),),)
                :Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: List.generate(
                        routines_memosList.length,
                        (i) => listViewRoutinesMemos(
                            index: i,
                            routinesMemos: routines_memosList[i],
                            width: _width,
                            context: context)).toList()))),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextButton(
              child: Text("다음에 하기", style: TextStyle(color: Colors.red)),
              onPressed: _httpDeleteTodayRoutines),
        ),
      ],
    ))));
  }

  Widget durationInputForm(
      {required TimeDuration timeDuration, required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        simpleTimeDurationWidget(
            routines: widget.todayRoutines!.routines!, context: context),
      ],
    );
  }

  Widget listViewRoutinesMemos(
      {required int? index,
      required RoutinesMemos? routinesMemos,
      required double? width,
      required BuildContext context}) {
    // widget layout for listview items
    return InkWell(
        onTap: () => _awaitReturnValueFromRoutinesMemosDetail(
            context, routinesMemos!, index!),
        child: Container(
            width: width! * 0.8,
            padding: EdgeInsets.only(right: 10, left: 10, bottom: 5, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      monthDayDateWidget(
                          datetime: routinesMemos!.created_date,
                          context: context),
                    ]),
                SizedBox(
                  height: 10,
                ),
                Text("${routinesMemos.content}")
              ],
            )));
  }

  void _awaitReturnValueFromRoutinesMemosDetail(
      BuildContext context, RoutinesMemos routinesMemos, int index) async {
    var awaitResult =
        await routinesMemosDetailModalBottomSheet(routinesMemos, context);
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
      var httpResult =
          await updateTodayRoutines(await getJwt(context), todayRoutines!);
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
    var awaitResult = await routinesMemosInputModalBottomSheet(
        todayRoutines!.routines!, context);
    if (awaitResult != null) {
      setState(() {
        widget.todayRoutines!.routines!.routines_memosList!.add(awaitResult);
      });
    }
  }
}
