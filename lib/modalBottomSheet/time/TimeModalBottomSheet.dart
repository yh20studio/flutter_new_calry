import 'package:flutter/material.dart';

import '../../time/TimeTwoChoice.dart';

timeTwoChoiceModalBottomSheet(TimeOfDay startTime, TimeOfDay endTime, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: Theme.of(context).backgroundColor,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
            padding: EdgeInsets.only(top:10, left: 10, right: 10),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Wrap(
                  children: [
                    TimeTwoChoice(
                      startTime: startTime,
                      endTime: endTime,
                      onStartTimeChanged: (onStartTimeChanged) {
                        startTime = onStartTimeChanged;
                      },
                      onEndTimeChanged: (onEndTimeChanged) {
                        endTime = onEndTimeChanged;
                      },
                    ),
                  ],
                ))),
      );
    },
  );
  if (result == null) {
    return [startTime, endTime];
  } else {
    return result;
  }
}
