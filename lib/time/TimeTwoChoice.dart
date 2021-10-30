import 'package:flutter/material.dart';
import 'package:flutter_new_calry/widgets/TimeWidget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TimeTwoChoice extends StatefulWidget {
  TimeTwoChoice({Key? key, this.startTime, this.endTime, this.onStartTimeChanged, this.onEndTimeChanged}) : super(key: key);
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final ValueChanged<TimeOfDay>? onStartTimeChanged;
  final ValueChanged<TimeOfDay>? onEndTimeChanged;

  @override
  _TimeTwoChoiceState createState() => _TimeTwoChoiceState();
}

class _TimeTwoChoiceState extends State<TimeTwoChoice> {
  FixedExtentScrollController? _hourController;
  FixedExtentScrollController? _minController;
  FixedExtentScrollController? _meridiemController;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  int startHourIndex = 0;
  int startMinuteIndex = 0;
  int startMeridiemIndex = 0;

  int endHourIndex = 0;
  int endMinuteIndex = 0;
  int endMeridiemIndex = 0;

  String mode = "start";

  @override
  void initState() {
    super.initState();
    startMinuteIndex += widget.startTime!.minute;
    startMeridiemIndex += widget.startTime!.hour >= 12 ? 1 : 0;
    startHourIndex += widget.startTime!.hourOfPeriod;

    endMinuteIndex += widget.endTime!.minute;
    endMeridiemIndex += widget.endTime!.hour >= 12 ? 1 : 0;
    endHourIndex += widget.endTime!.hourOfPeriod;

    _hourController = FixedExtentScrollController(initialItem: startHourIndex + 3000 - 1);
    _minController = FixedExtentScrollController(initialItem: startMinuteIndex + 3000);
    _meridiemController = FixedExtentScrollController(initialItem: startMeridiemIndex + 3000);

    startTime = widget.startTime!;
    endTime = widget.endTime!;
    widget.onStartTimeChanged!(startTime!);
    widget.onEndTimeChanged!(endTime!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Container(
                      color: mode == "start" ? Colors.purple.withOpacity(0.2) : Colors.transparent,
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              mode = "jump";
                              double startTimeToDouble = toDouble(startTime!);
                              double endTimeToDouble = toDouble(endTime!);

                              if (startTimeToDouble > endTimeToDouble) {
                                startTime = endTime!;
                                startMinuteIndex = startTime!.minute;
                                startMeridiemIndex = startTime!.hour >= 12 ? 1 : 0;
                                startHourIndex = startTime!.hourOfPeriod;
                                widget.onStartTimeChanged!(startTime!);
                              }
                              _hourController!.jumpToItem(3000 + startHourIndex - 1);
                              _minController!.jumpToItem(3000 + startMinuteIndex);
                              _meridiemController!.jumpToItem(3000 + startMeridiemIndex);
                              mode = "start";
                            });
                          },
                          child: Column(
                            children: [
                              Text("시작"),
                              SizedBox(
                                height: 5,
                              ),
                              meridiemHourMinuteTimeWidget(timeOfDay: startTime, context: context),
                            ],
                          )))),
              Expanded(
                  child: Container(
                color: mode == "start" ? Colors.transparent : Colors.purple.withOpacity(0.2),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        mode = "jump";
                        double startTimeToDouble = toDouble(startTime!);
                        double endTimeToDouble = toDouble(endTime!);

                        if (startTimeToDouble > endTimeToDouble) {
                          endTime = startTime!;
                          endMinuteIndex = endTime!.minute;
                          endMeridiemIndex = endTime!.hour >= 12 ? 1 : 0;
                          endHourIndex = endTime!.hourOfPeriod;
                          widget.onEndTimeChanged!(endTime!);
                        }

                        _hourController!.jumpToItem(3000 + endHourIndex - 1);
                        _minController!.jumpToItem(3000 + endMinuteIndex);
                        _meridiemController!.jumpToItem(3000 + endMeridiemIndex);
                        mode = "end";
                      });
                    },
                    child: Column(
                      children: [
                        Text("종료"),
                        SizedBox(
                          height: 5,
                        ),
                        meridiemHourMinuteTimeWidget(timeOfDay: endTime, context: context),
                      ],
                    )),
              ))
            ],
          ),
        ),
        Neumorphic(
            style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)), depth: -3, lightSource: LightSource.topLeft, color: Colors.white54),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Container(
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Container(
                    width: 50,
                    height: 100,
                    child: ListWheelScrollView(
                      diameterRatio: 1.2,
                      itemExtent: 35,
                      controller: _hourController,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) {
                        setState(() {
                          if (mode == "start") {
                            startHourIndex = i % 12 + 1;
                            int meridiem = startMeridiemIndex == 0 ? 0 : 12;
                            startTime = TimeOfDay(hour: startHourIndex + meridiem, minute: startTime!.minute);
                            widget.onStartTimeChanged!(startTime!);
                          } else if (mode == "end") {
                            endHourIndex = i % 12 + 1;
                            int meridiem = endMeridiemIndex == 0 ? 0 : 12;
                            endTime = TimeOfDay(hour: endHourIndex + meridiem, minute: endTime!.minute);
                            widget.onEndTimeChanged!(endTime!);
                          }
                        });
                      },
                      children: List<Widget>.generate(
                          6000,
                          (index) => Container(
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                  child: Text(
                                '${index % 12 + 1}',
                                style: mode == "start"
                                    ? TextStyle(fontSize: 20, fontWeight: index % 12 + 1 == startHourIndex ? FontWeight.w700 : FontWeight.normal)
                                    : TextStyle(fontSize: 20, fontWeight: index % 12 + 1 == endHourIndex ? FontWeight.w700 : FontWeight.normal),
                              )))),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 100,
                    child: ListWheelScrollView(
                      diameterRatio: 1.2,
                      itemExtent: 35,
                      controller: _minController,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) {
                        setState(() {
                          if (mode == "start") {
                            startMinuteIndex = i % 60;
                            startTime = TimeOfDay(hour: startTime!.hour, minute: startMinuteIndex);
                            widget.onStartTimeChanged!(startTime!);
                          } else if (mode == "end") {
                            endMinuteIndex = i % 60;
                            endTime = TimeOfDay(hour: endTime!.hour, minute: endMinuteIndex);
                            widget.onEndTimeChanged!(endTime!);
                          }
                        });
                      },
                      children: List<Widget>.generate(
                          6000,
                          (index) => Container(
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                  child: Text('${index % 60}',
                                      style: mode == "start"
                                          ? TextStyle(fontSize: 20, fontWeight: index % 60 == startMinuteIndex ? FontWeight.w700 : FontWeight.normal)
                                          : TextStyle(fontSize: 20, fontWeight: index % 60 == endMinuteIndex ? FontWeight.w700 : FontWeight.normal))))),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 100,
                    child: ListWheelScrollView(
                      diameterRatio: 1.2,
                      itemExtent: 35,
                      controller: _meridiemController,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) {
                        setState(() {
                          if (mode == "start") {
                            startMeridiemIndex = i % 2;
                            if (startMeridiemIndex == 0) {
                              startTime = TimeOfDay(hour: startTime!.hour - 12, minute: startTime!.minute);
                            } else {
                              startTime = TimeOfDay(hour: startTime!.hour + 12, minute: startTime!.minute);
                            }
                            widget.onStartTimeChanged!(startTime!);
                          } else if (mode == "end") {
                            endMeridiemIndex = i % 2;
                            if (endMeridiemIndex == 0) {
                              endTime = TimeOfDay(hour: endTime!.hour - 12, minute: endTime!.minute);
                            } else {
                              endTime = TimeOfDay(hour: endTime!.hour + 12, minute: endTime!.minute);
                            }
                            widget.onEndTimeChanged!(endTime!);
                          }
                        });
                      },
                      children: List<Widget>.generate(
                          6000,
                          (index) => Container(
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                  child: Text(index % 2 == 0 ? "오전" : "오후",
                                      style: mode == "start"
                                          ? TextStyle(fontSize: 20, fontWeight: index % 2 == startMeridiemIndex ? FontWeight.w700 : FontWeight.normal)
                                          : TextStyle(fontSize: 20, fontWeight: index % 2 == endMeridiemIndex ? FontWeight.w700 : FontWeight.normal))))),
                    ),
                  ),
                ])))),
        Container(
          height: 20,
        )
      ],
    );
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}
