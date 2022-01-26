import 'package:flutter/material.dart';

import '../domain/routines/Routines.dart';
import '../domain/timeDuration/TimeDuration.dart';

Widget timeDurationWidget({required TimeDuration timeDuration, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${timeDuration.hour} "),
        Text("시간"),
        Text(" ${timeDuration.min} "),
        Text("분"),
        Text(" ${timeDuration.sec} "),
        Text("초"),
      ],
    ),
  );
}

Widget simpleTimeDurationWidget({required Routines routines, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
  );
}
