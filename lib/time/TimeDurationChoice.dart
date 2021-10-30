import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_new_calry/widgets/timeDurationWidget.dart';
import 'package:flutter_new_calry/domain/timeDuration/TimeDuration.dart';

class TimeDurationChoice extends StatefulWidget {
  TimeDurationChoice({Key? key, this.duration, this.onDurationChanged}) : super(key: key);
  final TimeDuration? duration;
  final ValueChanged<TimeDuration>? onDurationChanged;

  @override
  _TimeDurationChoiceState createState() => _TimeDurationChoiceState();
}

class _TimeDurationChoiceState extends State<TimeDurationChoice> {
  FixedExtentScrollController? _hourController;
  FixedExtentScrollController? _minController;
  FixedExtentScrollController? _secondController;

  TimeDuration? duration;

  int hourIndex = 0;
  int minuteIndex = 0;
  int secondIndex = 0;

  @override
  void initState() {
    super.initState();
    hourIndex += widget.duration!.hour!;
    minuteIndex += widget.duration!.min!;
    secondIndex += widget.duration!.sec!;

    duration = widget.duration!;

    _hourController = FixedExtentScrollController(initialItem: duration!.hour! + 3000);
    _minController = FixedExtentScrollController(initialItem: duration!.min! + 3000);
    _secondController = FixedExtentScrollController(initialItem: duration!.sec! + 3000);

    widget.onDurationChanged!(duration!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text("지속 시간 선택"),
          ),
        ),
        timeDurationWidget(timeDuration: duration!, context: context),
        SizedBox(
          height: 15,
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
                          duration!.hour = i % 12;
                          widget.onDurationChanged!(duration!);
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
                                '${index % 12}',
                                style: TextStyle(fontSize: 20, fontWeight: index % 12 == duration!.hour ? FontWeight.w700 : FontWeight.normal),
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
                          duration!.min = i % 60;
                          widget.onDurationChanged!(duration!);
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
                                      style: TextStyle(fontSize: 20, fontWeight: index % 60 == duration!.min ? FontWeight.w700 : FontWeight.normal))))),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 100,
                    child: ListWheelScrollView(
                      diameterRatio: 1.2,
                      itemExtent: 35,
                      controller: _secondController,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) {
                        setState(() {
                          duration!.sec = i % 60;
                          widget.onDurationChanged!(duration!);
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
                                      style: TextStyle(fontSize: 20, fontWeight: index % 60 == duration!.sec ? FontWeight.w700 : FontWeight.normal))))),
                    ),
                  ),
                ])))),
        Container(
          height: 20,
        )
      ],
    );
  }
}
