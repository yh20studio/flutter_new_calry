import 'package:flutter/material.dart';

import '../../detail/routines/RoutinesDetail.dart';
import '../../domain/routines/Routines.dart';

routinesDetailModalBottomSheet(
  Routines routines,
  BuildContext context,
) async {
  var result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: DraggableScrollableSheet(
                          initialChildSize: 1,
                          builder: (_, controller) {
                            return SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                                child: Wrap(
                              children: [
                                RoutinesDetail(
                                  routines: routines,
                                )
                              ],
                            ));
                          }))),
            );
          },
        );
      });

  return result;
}
