import 'package:flutter/material.dart';

import '../../domain/quickSchedules/QuickSchedules.dart';
import '../../domain/schedules/Schedules.dart';
import '../../functions.dart';
import '../../modalBottomSheet/quickSchedules/QuickSchedulesEditListModalBottomSheet.dart';
import '../../widgets/TimeWidget.dart';
import '../../controller/schedules/SchedulesController.dart';

class QuickSchedulesList extends StatefulWidget {
  QuickSchedulesList({Key? key, this.date, this.quickScheduleList, this.onRefreshChanged, this.onScheduleChanged, this.onQuickScheduleChanged})
      : super(key: key);

  final DateTime? date;
  final List<QuickSchedules>? quickScheduleList;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<Schedules>? onScheduleChanged;
  final ValueChanged<QuickSchedules>? onQuickScheduleChanged;

  @override
  _QuickSchedulesListstate createState() => _QuickSchedulesListstate();
}

class _QuickSchedulesListstate extends State<QuickSchedulesList> {
  @override
  void initState() {
    super.initState();
    widget.onRefreshChanged!('');
    widget.onQuickScheduleChanged!(QuickSchedules());
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Center(child: Text("일정 빠르게 추가하기")),
            ),

            TextButton(onPressed: () => _awaitReturnValueFromQuickSchedulesEditList(), child: Center(child: Text("편집"))),
            //IconButton(onPressed: () => _awaitReturnValueFromQuickSchedulesInput(), icon: Icon(Icons.add)),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        Container(
            child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List.generate(widget.quickScheduleList!.length,
                    (i) => listViewQuickSchedules(index: i, quickSchedules: widget.quickScheduleList![i], width: _width, context: context)).toList())),
      ],
    )));
  }

  Widget listViewQuickSchedules({required int index, required QuickSchedules quickSchedules, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () => _httpPostSchedules(quickSchedules),
        child: Container(
            width: width,
            padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(
                Icons.circle,
                color: MyFunction.parseColor(quickSchedules.labels!.label_colors!.code!),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(quickSchedules.title!),
                      )),
                    ],
                  ),
                  quickSchedules.startTime == null && quickSchedules.endTime == null
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.timer,
                              size: 23,
                            ),
                            meridiemHourMinuteTimeSmallWidget(timeOfDay: quickSchedules.startTime, context: context),
                            Text("~"),
                            meridiemHourMinuteTimeSmallWidget(timeOfDay: quickSchedules.endTime, context: context)
                          ],
                        )
                ],
              ))
            ])));
  }

  void _awaitReturnValueFromQuickSchedulesEditList() async {
    var awaitResult = await quickSchedulesEditListModalBottomSheet(context, widget.quickScheduleList!);
    if (awaitResult != null) {
      setState(() {
        if (awaitResult[0] == "input") {
          widget.onRefreshChanged!('input');
          widget.onQuickScheduleChanged!(awaitResult[1]);
        }
      });
    }
  }

  void _httpPostSchedules(QuickSchedules quickSchedules) async {
    DateTime startDate;
    DateTime endDate;
    if (quickSchedules.startTime == null && quickSchedules.endTime == null) {
      startDate = DateTime.utc(widget.date!.year, widget.date!.month, widget.date!.day);
      endDate = DateTime.utc(widget.date!.year, widget.date!.month, widget.date!.day);
    } else {
      startDate = DateTime.utc(widget.date!.year, widget.date!.month, widget.date!.day, quickSchedules.startTime!.hour, quickSchedules.startTime!.minute);
      endDate = DateTime.utc(widget.date!.year, widget.date!.month, widget.date!.day, quickSchedules.endTime!.hour, quickSchedules.endTime!.minute);
    }

    Schedules schedules =
        Schedules(startDate: startDate, endDate: endDate, title: quickSchedules.title, content: quickSchedules.content, labels: quickSchedules.labels);

    try {
      var httpResult = await postSchedules(schedules);
      widget.onScheduleChanged!(httpResult);
    } catch (e) {
      print(e);
    }
  }
}
