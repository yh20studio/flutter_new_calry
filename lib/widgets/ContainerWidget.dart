import 'package:flutter/material.dart';

Widget borderPaddingContainerWidget({required Widget widget, required BuildContext context}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: widget);
}

Widget borderPaddingTitleContainerWidget({required Widget title, required Widget widget, required BuildContext context}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    title,
    SizedBox(height: 5),
    Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black26,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: widget)
  ]);
}
