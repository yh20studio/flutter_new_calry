import 'package:flutter/material.dart';

import '../../domain/focusTodos/FocusTodos.dart';
import '../../modalBottomSheet/focusTodos/FocusTodosDetailModalBottomSheet.dart';
import '../../widgets/ContainerWidget.dart';
import '../../modalBottomSheet/focusTodos/FocusTodosInputModalBottomSheet.dart';
import '../../widgets/MultiLineTextForListItemWidget.dart';

class FocusTodosList extends StatefulWidget {
  FocusTodosList({
    Key? key,
    this.date,
    this.focusTodosList,
  }) : super(key: key);

  final DateTime? date;
  final List<FocusTodos>? focusTodosList;

  @override
  _FocusTodosListstate createState() => _FocusTodosListstate();
}

class _FocusTodosListstate extends State<FocusTodosList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Container(
                child: Column(
      children: [
        borderPaddingTitleContainerWidget(
            title: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Center(
                          child: Text(
                        "집중해야 할일",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                    ),
                    IconButton(onPressed: () => _awaitReturnValueFromFocusTodosInput(), icon: Icon(Icons.add)),
                  ],
                )),
            widget: widget.focusTodosList!.length == 0
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text("오늘은 집중할 일이 없습니다."),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: List.generate(widget.focusTodosList!.length,
                            (i) => listViewFocusTodos(index: i, focusTodos: widget.focusTodosList![i], width: _width, context: context)).toList())),
            context: context)
      ],
    ))));
  }

  Widget listViewFocusTodos({required int index, required FocusTodos focusTodos, required double width, required BuildContext context}) {
    return InkWell(
        onTap: () {
          _awaitReturnValueFromFocusTodosDetail(focusTodos, index);
        },
        child: multiLineTextForListItemWidget(width: width, text: focusTodos.content!, context: context));
  }

  void _awaitReturnValueFromFocusTodosDetail(FocusTodos focusTodos, int index) async {
    var awaitResult = await focusTodosDetailModalBottomSheet(focusTodos, context);

    if (awaitResult != null) {
      if (awaitResult[0] == "update") {
        setState(() {
          widget.focusTodosList![index] = awaitResult[1];
        });
      } else if (awaitResult[0] == "delete") {
        setState(() {
          widget.focusTodosList!.removeAt(index);
        });
      }
    }
  }

  void _awaitReturnValueFromFocusTodosInput() async {
    var awaitResult = await focusTodosInputModalBottomSheet(widget.date!, context);
    if (awaitResult != null) {
      setState(() {
        widget.focusTodosList!.add(awaitResult);
      });
    }
  }
}
