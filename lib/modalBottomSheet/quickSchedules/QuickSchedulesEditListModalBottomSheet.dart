import 'package:flutter/material.dart';

import '../../domain/quickSchedules/QuickSchedules.dart';
import '../../list/quickSchedules/QuickSchedulesEditList.dart';

quickSchedulesEditListModalBottomSheet(BuildContext context, List<QuickSchedules> quickScheduleList) async {
  String action = '';
  QuickSchedules quickSchedules = QuickSchedules();
  await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: DraggableScrollableSheet(
                          initialChildSize: 1,
                          builder: (_, controller) {
                            return SingleChildScrollView(
                                child: Wrap(
                              children: [
                                QuickSchedulesEditList(
                                  quickScheduleList: quickScheduleList,
                                  onRefreshChanged: (onRefreshChanged) {
                                    action = onRefreshChanged;
                                  },
                                  onQuickScheduleChanged: (onQuickScheduleChanged) {
                                    quickSchedules = onQuickScheduleChanged;
                                  },
                                )
                              ],
                            ));
                          }))),
            );
          },
        );
      });

  return [action, quickSchedules];
}
