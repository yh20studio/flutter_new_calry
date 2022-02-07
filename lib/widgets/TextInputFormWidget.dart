import 'package:flutter/material.dart';

Widget textInputForm({required TextEditingController controller, required String title, required double width, required BuildContext context}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        child: Text(title, style: Theme.of(context).textTheme.headline2),
      ),
      Container(
        width: width * 0.8,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.transparent),
        child: TextFormField(
          style: TextStyle(fontSize: 24, color:Theme.of(context).hoverColor),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none, disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none), contentPadding: EdgeInsets.only(top: 0.0)),
        ),
      ),
    ],
  );
}

Widget textInputSimpleForm({required TextEditingController controller, required BuildContext context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.transparent),
        child: TextFormField(
          style: TextStyle(fontSize: 21, color:Theme.of(context).hoverColor),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 0.0)),
        ),
      ),
    ],
  );
}
