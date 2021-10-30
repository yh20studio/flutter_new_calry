import 'package:flutter/material.dart';
import 'package:flutter_new_calry/time/TimeDurationChoice.dart';
import 'package:flutter_new_calry/domain/timeDuration/TimeDuration.dart';

timeDurationChoiceModalBottomSheet(TimeDuration duration, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Wrap(
                  children: [
                    TimeDurationChoice(
                      duration: duration,
                      onDurationChanged: (onDurationChanged) {
                        duration = onDurationChanged;
                      },
                    ),
                  ],
                ))),
      );
    },
  );
  if (result == null) {
    return duration;
  } else {
    return result;
  }
}
