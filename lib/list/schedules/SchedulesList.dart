import 'package:flutter/material.dart';

import '../../domain/schedules/Schedules.dart';
import '../../functions.dart';
import '../../modalBottomSheet/Schedules/SchedulesDetailModalBottomSheet.dart';
import '../../widgets/ContainerWidget.dart';
import '../../modalBottomSheet/schedules/SchedulesInputModalBottomSheet.dart';

class SchedulesList extends StatefulWidget {
  SchedulesList({
    Key? key,
    this.date,
    this.scheduleList,
  }) : super(key: key);

  final DateTime? date;
  final List<Schedules>? scheduleList;

  @override
  _SchedulesListstate createState() => _SchedulesListstate();
}

class _SchedulesListstate extends State<SchedulesList> {
  @override
  void initState() {
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
        borderPaddingTitleContainerWidget(
            title: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Center(
                          child: Text(
                        "오늘의 일정",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                    ),
                    IconButton(onPressed: () => _awaitReturnValueFromSchedulesInput(), icon: Icon(Icons.navigate_next_sharp)),
                  ],
                )),
            widget: widget.scheduleList!.length == 0
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text("오늘은 일정이 없습니다."),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: List.generate(widget.scheduleList!.length,
                            (i) => listViewSchedules(index: i, schedules: widget.scheduleList![i], width: _width, context: context)).toList())),
            context: context)
      ],
    ))));
  }

  Widget listViewSchedules({required int index, required Schedules schedules, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () {
          _awaitReturnValueFromScheduleDetail(schedules, index);
        },
        child: Container(
            width: width,
            padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(
                Icons.circle,
                color: MyFunction.parseColor(schedules.labels!.label_colors!.code!),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(schedules.title!),
                ),
              )
            ])));
  }

  void _awaitReturnValueFromScheduleDetail(Schedules schedules, int index) async {
    var awaitResult = await schedulesDetailModalBottomSheet(schedules, context);

    if (awaitResult != null) {
      if (awaitResult[0] == "update") {
        setState(() {
          widget.scheduleList![index] = awaitResult[1];
        });
      } else if (awaitResult[0] == "delete") {
        setState(() {
          widget.scheduleList!.removeAt(index);
        });
      }
    }
  }

  void _awaitReturnValueFromSchedulesInput() async {
    var awaitResult = await schedulesInputModalBottomSheet(widget.date!, context);
    if (awaitResult != null) {
      setState(() {
        widget.scheduleList!.add(awaitResult);
      });
    }
  }
}
