import 'package:flutter/material.dart';

import '../../domain/focusTodos/FocusTodos.dart';
import '../../detail/focusTodos/FocusTodosDetail.dart';

focusTodosDetailModalBottomSheet(FocusTodos focusTodos, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (BuildContext context) {
        return Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: DraggableScrollableSheet(
                  initialChildSize: 1,
                  builder: (_, controller) {
                    return  SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                            child: Wrap(
                      children: [
                        FocusTodosDetail(
                          focusTodos: focusTodos,
                        )
                      ],
                    ));
                  }),
            ));
      });

  if (result == null) {
    return null;
  } else {
    return result;
  }
}
