import 'package:flutter/material.dart';

import '../../domain/schedules/Schedules.dart';
import '../../detail/schedules/SchedulesDetail.dart';

schedulesDetailModalBottomSheet(Schedules schedules, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
            padding: EdgeInsets.all(20),
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: DraggableScrollableSheet(
                  initialChildSize: 1,
                  builder: (_, controller) {
                    return SafeArea(
                        child: SingleChildScrollView(
                            child: Wrap(
                      children: [
                        SchedulesDetail(
                          schedules: schedules,
                        )
                      ],
                    )));
                  }),
            ));
      });

  if (result == null) {
    return null;
  } else {
    return result;
  }
}
