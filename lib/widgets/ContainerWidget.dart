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
