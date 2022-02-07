import 'package:flutter/material.dart';

import '../../modalBottomSheet/routines/RoutinesDetailModalBottomSheet.dart';
import '../../modalBottomSheet/routines/RoutinesInputModalBottomSheet.dart';
import '../../domain/routines/Routines.dart';
import '../../widgets/MultiLineTextForListItemWidget.dart';
import '../../widgets/ContainerWidget.dart';

class RoutinesEditList extends StatefulWidget {
  RoutinesEditList(
      {Key? key,
      this.routinesList,
      this.onRefreshChanged,
      this.onRoutinesChanged})
      : super(key: key);

  final List<Routines>? routinesList;
  final ValueChanged<String>? onRefreshChanged;
  final ValueChanged<Routines>? onRoutinesChanged;

  @override
  _RoutinesEditListstate createState() => _RoutinesEditListstate();
}

class _RoutinesEditListstate extends State<RoutinesEditList> {
  @override
  void initState() {
    super.initState();
    widget.onRefreshChanged!('');
    widget.onRoutinesChanged!(Routines());
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
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close)),
            Expanded(child: Center(child: Text("나의 루틴", style: TextStyle(fontWeight: FontWeight.w700),))),
            IconButton(
                onPressed: () => _awaitReturnValueFromRoutinesInput(),
                icon: Icon(Icons.add)),
          ],
        )),
        SizedBox(
          height: 10,
        ),
        overlayContainerWidget(
            context: context,
            widget: Container(
                padding: EdgeInsets.all(10),
                child: Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: List.generate(
                        widget.routinesList!.length,
                        (i) => listViewRoutines(
                            index: i,
                            routines: widget.routinesList![i],
                            width: _width,
                            context: context)).toList()))),
      ],
    )));
  }

  Widget listViewRoutines(
      {required int index,
      required Routines routines,
      required double width,
      required BuildContext context}) {
    return InkWell(
        onTap: () => _awaitReturnValueFromRoutinesDetail(routines, index),
        child: multiLineTextForListItemWidget(
            width: width, text: routines.title!, context: context));
  }

  void _awaitReturnValueFromRoutinesInput() async {
    var awaitResult = await routinesInputModalBottomSheet(context);
    if (awaitResult != null) {
      setState(() {
        widget.routinesList!.add(awaitResult);
        widget.onRefreshChanged!('input');
        widget.onRoutinesChanged!(awaitResult);
      });
    }
  }

  void _awaitReturnValueFromRoutinesDetail(Routines routines, int index) async {
    var awaitResult = await routinesDetailModalBottomSheet(routines, context);

    if (awaitResult != null) {
      if (awaitResult[0] == "update") {
        setState(() {
          widget.routinesList![index] = awaitResult[1];
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onRoutinesChanged!(awaitResult[1]);
        });
      } else if (awaitResult[0] == "delete") {
        setState(() {
          widget.routinesList!.removeAt(index);
          widget.onRefreshChanged!(awaitResult[0]);
          widget.onRoutinesChanged!(awaitResult[1]);
        });
      }
    }
  }
}
