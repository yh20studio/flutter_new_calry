import 'package:flutter/material.dart';

Widget multiLineTextForListItemWidget({required double width, required String text, required BuildContext context}) {
  return Container(
      width: width,
      padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child: Container(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(text),
        )),
      ]));
}
