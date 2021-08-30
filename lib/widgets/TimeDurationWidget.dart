import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';

Widget timeDurationWidget(
    {required TimeDuration timeDuration, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("${timeDuration.hour}"),
        Text("시간"),
        Text("${timeDuration.min}"),
        Text("분"),
        Text("${timeDuration.sec}"),
        Text("초"),
      ],
    ),
  );
}
