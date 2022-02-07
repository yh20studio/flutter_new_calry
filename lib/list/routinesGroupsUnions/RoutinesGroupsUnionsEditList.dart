import 'package:flutter/material.dart';

import '../../modalBottomSheet/routinesGroupsUnions/RoutinesGroupsUnionsInputModalBottomSheet.dart';
import '../../modalBottomSheet/routinesGroupsUnions/RoutinesGroupsUnionsDetailModalBottomSheet.dart';
import '../../domain/routinesGroupsUnions/RoutinesGroupsUnions.dart';
import '../../widgets/MultiLineTextForListItemWidget.dart';
import '../../widgets/ContainerWidget.dart';

class RoutinesGroupsUnionsEditList extends StatefulWidget {
  RoutinesGroupsUnionsEditList({Key? key, this.routinesGroupsUnionList, this.onRefreshChanged, this.onRoutinesGroupsUnionChanged}) : super(key: key);

  final List<RoutinesGroupsUnions>? routinesGroupsUnionList;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<RoutinesGroupsUnions>? onRoutinesGroupsUnionChanged;

  @override
  _RoutinesGroupsUnionsEditListstate createState() => _RoutinesGroupsUnionsEditListstate();
}

class _RoutinesGroupsUnionsEditListstate extends State<RoutinesGroupsUnionsEditList> {
  @override
  void initState() {
    super.initState();
    widget.onRefreshChanged!('');
    widget.onRoutinesGroupsUnionChanged!(RoutinesGroupsUnions());
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
            Expanded(child: Center(child: Text("나의 루틴그룹", style: TextStyle(fontWeight: FontWeight.w700)))),
            IconButton(onPressed: () => _awaitReturnValueFromRoutinesGroupsUnionsInput(), icon: Icon(Icons.add)),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        overlayContainerWidget(
          context: context,
          widget:
        Container(
            padding: EdgeInsets.all(10),
            child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List.generate(widget.routinesGroupsUnionList!.length,
                        (i) => listViewRoutinesGroupsUnion(index: i, routinesGroupsUnions: widget.routinesGroupsUnionList![i], width: _width, context: context))
                    .toList()))),
      ],
    )));
  }

  Widget listViewRoutinesGroupsUnion(
      {required int index, required RoutinesGroupsUnions routinesGroupsUnions, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () => _awaitReturnValueFromRoutinesGroupsUnionsDetail(routinesGroupsUnions, index),
        child: multiLineTextForListItemWidget(width: width, text: routinesGroupsUnions.title!, context: context));
  }

  void _awaitReturnValueFromRoutinesGroupsUnionsInput() async {
    var awaitResult = await routinesGroupsUnionsInputModalBottomSheet(context);
    if (awaitResult != null) {
      setState(() {
        widget.routinesGroupsUnionList!.add(awaitResult);
        widget.onRefreshChanged!('input');
        widget.onRoutinesGroupsUnionChanged!(awaitResult);
      });
    }
  }

  void _awaitReturnValueFromRoutinesGroupsUnionsDetail(RoutinesGroupsUnions routinesGroupsUnions, int index) async {
    var awaitResult = await routinesGroupsUnionsDetailModalBottomSheet(routinesGroupsUnions, context);

    if (awaitResult != null) {
      if (awaitResult[0] == "update") {
        setState(() {
          widget.routinesGroupsUnionList![index] = awaitResult[1];
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onRoutinesGroupsUnionChanged!(awaitResult[1]);
        });
      } else if (awaitResult[0] == "delete") {
        setState(() {
          widget.routinesGroupsUnionList!.removeAt(index);
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onRoutinesGroupsUnionChanged!(awaitResult[1]);
        });
      }
    }
  }
}
