import 'package:flutter/material.dart';

import '../../list/routines/RoutinesEditList.dart';
import '../../domain/routines/Routines.dart';

routinesEditListModalBottomSheet(BuildContext context, List<Routines> routinesList) async {
  String action = '';

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
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: DraggableScrollableSheet(
                          initialChildSize: 1,
                          builder: (_, controller) {
                            return SingleChildScrollView(
                                child: Wrap(
                              children: [
                                RoutinesEditList(
                                  routinesList: routinesList,
                                  onRefreshChanged: (onRefreshChanged) {
                                    action = onRefreshChanged;
                                  },
                                  onRoutinesChanged: (onRoutinesChanged) {},
                                )
                              ],
                            ));
                          }))),
            );
          },
        );
      });

  return [action, routinesList];
}
