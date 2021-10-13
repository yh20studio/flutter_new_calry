import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/listItems.dart';
import 'package:flutter_webservice/widgets/TimeDurationWidget.dart';

Future<List<Routines>> routinesListInputDialog(
    BuildContext context, List<Routines> routinesList) async {
  var result = await showDialog(
    barrierDismissible: true,
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7 <= 300
                    ? MediaQuery.of(context).size.width * 0.7
                    : 300,
                height: MediaQuery.of(context).size.height * 0.5,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(onPressed: () {}, child: Text("추천")),
                                TextButton(
                                    onPressed: () {}, child: Text("내 루틴"))
                              ],
                            ))),
                    Container(
                        child: FutureBuilder<List<CustomRoutines>>(
                            future: getCustomRoutines(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                print('no data');
                                return Container();
                              } else if (snapshot.hasError) {
                                print('Error');
                                return Text('Error');
                              } else {
                                if (snapshot.data!.length == 0) {
                                  return Container(
                                    child: Center(
                                      child: Text("추가한 Archives가 없습니다."),
                                    ),
                                  );
                                } else {
                                  return Wrap(
                                      spacing:
                                          8.0, // gap between adjacent chips
                                      runSpacing: 4.0, // gap between lines
                                      children: List.generate(
                                          snapshot.data!.length,
                                          (i) => listViewCustomRoutines(
                                              index: i,
                                              customRoutines: snapshot.data![i],
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              context: context)).toList());
                                }
                              }
                            })),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      width: 0.2, color: Colors.black))),
                          child: TextButton(
                            child: Text('OK',
                                style: Theme.of(context).textTheme.subtitle1),
                            onPressed: () {
                              Navigator.pop(context, routinesList);
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
  if (result == null) {
    return routinesList;
  } else {
    return result;
  }
}

Widget listViewCustomRoutines(
    {required int index,
    required CustomRoutines customRoutines,
    required double width,
    required BuildContext context}) {
  return InkWell(
      onTap: () {},
      child: Container(
          width: width,
          padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
          child: Column(children: [
            Text(customRoutines.title!),
            timeDurationWidget(
                timeDuration: customRoutines.timeDuration!, context: context)
          ])));
}
