import 'package:flutter/material.dart';

Widget borderPaddingContainerWidget(
    {required Widget widget, required BuildContext context}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: widget);
}

Widget borderPaddingTitleContainerWidget(
    {required Widget title,
    required Widget widget,
    required BuildContext context}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    title,
    SizedBox(height: 5),
    Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: widget)
  ]);
}

Widget overlayContainerWidget(
    {required Widget widget, required BuildContext context}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: widget);
}

Widget overlayPaddingContainerWidget(
    {required Widget widget, required BuildContext context}) {
  return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: widget);
}

Widget topBorderPaddingTitleContainerWidget(
    {required Widget title,
    required Widget widget,
    required BuildContext context}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    title,
    SizedBox(height: 5),
    Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: widget)
  ]);
}

Widget overlayContainer(
    {required Widget widget, required BuildContext context}) {
  return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: widget);
}
