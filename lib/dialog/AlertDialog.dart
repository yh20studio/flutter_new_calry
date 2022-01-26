import 'dart:async';

import 'package:flutter/material.dart';

Future<String> alertDialog(BuildContext context, String title) async {
  String result = await showDialog(
    barrierDismissible: false,
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
          elevation: 0.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(width: 0.4, color: Colors.black),
                        )),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "$title",
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(border: Border(left: BorderSide(width: 0.2, color: Colors.black))),
                          child: TextButton(
                            child: Text(
                              'OK',
                            ),
                            onPressed: () {
                              Navigator.pop(context, 'ok');
                            },
                          ),
                        ))
                      ],
                    )
                  ],
                )),
          ));
    },
  );
  return result;
}
