import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/detail/RoutinesDetail.dart';
import 'package:flutter_webservice/detail/CustomRoutinesDetail.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'dart:io';

class CustomRoutinesList extends StatefulWidget {
  CustomRoutinesList({Key? key}) : super(key: key);

  @override
  _CustomRoutinesListstate createState() => _CustomRoutinesListstate();
}

class _CustomRoutinesListstate extends State<CustomRoutinesList> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: Text('Custom Routines List'),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Container(
                child: FutureBuilder<List<CustomRoutines>>(
                    future: getCustomRoutines(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                              child: Text("추가한 Custom Routines가 없습니다."),
                            ),
                          );
                        } else {
                          return Wrap(
                              spacing: 8.0, // gap between adjacent chips
                              runSpacing: 4.0, // gap between lines
                              children: List.generate(
                                  snapshot.data!.length,
                                  (i) => listViewCustomRoutines(
                                      index: i,
                                      customRoutines: snapshot.data![i],
                                      width: _width,
                                      context: context)).toList());
                        }
                      }
                    }))
          ],
        ))));
  }

  Widget listViewCustomRoutines(
      {required int index,
      required CustomRoutines customRoutines,
      required double width,
      required BuildContext context}) {
    return InkWell(
        onTap: () => _awaitReturnValueFromCustomRoutinesDetail(customRoutines),
        child: Container(
            width: width,
            padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
            child: Column(children: [
              //Text(routines.icon!),
              Text(customRoutines.title!),
              //Text("메모리스트"),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("${customRoutines.timeDuration!.hour}"),
                    Text("시간"),
                    Text("${customRoutines.timeDuration!.min}"),
                    Text("분"),
                    Text("${customRoutines.timeDuration!.sec}"),
                    Text("초"),
                  ],
                ),
              )
            ])));
  }

  void _awaitReturnValueFromCustomRoutinesDetail(
      CustomRoutines customRoutines) async {
    var awaitResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomRoutinesDetail(
                  customRoutines: customRoutines,
                )));
    if (awaitResult[0] == 'delete') {
      setState(() {
        print('reload');
      });
    } else if (awaitResult[0] == 'update') {
      setState(() {
        print('reload');
      });
    }
  }
}
