import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/detail/ArchivesDetail.dart';
import 'package:flutter_webservice/input/SchedulesInput.dart';
import 'package:flutter_webservice/widgets/DateWidget.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_webservice/functions.dart';
import 'package:flutter_webservice/modalBottomSheet/QuickSchedulesInputModalBottomSheet.dart';
import 'package:flutter_webservice/modalBottomSheet/QuickSchedulesDetailModalBottomSheet.dart';
import 'package:flutter_webservice/widgets/TimeWidget.dart';

class QuickSchedulesEditList extends StatefulWidget {
  QuickSchedulesEditList({Key? key, this.quickScheduleList, this.onRefreshChanged, this.onQuickScheduleChanged}) : super(key: key);

  final List<QuickSchedules>? quickScheduleList;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<QuickSchedules>? onQuickScheduleChanged;

  @override
  _QuickSchedulesEditListstate createState() => _QuickSchedulesEditListstate();
}

class _QuickSchedulesEditListstate extends State<QuickSchedulesEditList> {
  @override
  void initState() {
    super.initState();
    widget.onRefreshChanged!('');
    widget.onQuickScheduleChanged!(QuickSchedules());
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
            Expanded(child: Center(child: Text("일정 빠르게 추가하기"))),
            IconButton(onPressed: () => _awaitReturnValueFromQuickSchedulesInput(), icon: Icon(Icons.add)),
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
        onTap: () => _awaitReturnValueFromQuickScheduleDetail(quickSchedules, index),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(quickSchedules.title!),
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
              )
            ])));
  }

  void _awaitReturnValueFromQuickSchedulesInput() async {
    var awaitResult = await quickSchedulesInputModalBottomSheet(context);
    if (awaitResult != null) {
      setState(() {
        widget.quickScheduleList!.add(awaitResult);
        widget.onRefreshChanged!('input');
        widget.onQuickScheduleChanged!(awaitResult);
      });
    }
  }

  void _awaitReturnValueFromQuickScheduleDetail(QuickSchedules quickSchedules, int index) async {
    var awaitResult = await quickSchedulesDetailModalBottomSheet(quickSchedules, context);

    if (awaitResult != null) {
      if (awaitResult[0] == "update") {
        setState(() {
          widget.quickScheduleList![index] = awaitResult[1];
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onQuickScheduleChanged!(awaitResult[1]);
        });
      } else if (awaitResult[0] == "delete") {
        setState(() {
          widget.quickScheduleList!.removeAt(index);
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onQuickScheduleChanged!(awaitResult[1]);
        });
      }
    }
  }
}
