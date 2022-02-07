import 'package:flutter/material.dart';

import '../../domain/labels/Labels.dart';
import '../../functions.dart';
import '../../controller/labels/LabelsController.dart';
import '../../controller/jwt/JwtController.dart';

labelsEditModalBottomSheet(
    List<Labels> labelsList, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return SafeArea(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.7 <= 300
                    ? MediaQuery.of(context).size.width * 0.7
                    : 300,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Wrap(
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            color: Theme.of(context).primaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () =>
                                        Navigator.pop(context, null),
                                    icon: Icon(Icons.close,
                                        color:
                                            Theme.of(context).backgroundColor)),
                                Expanded(
                                    child: Center(child:Text("라벨 관리",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .backgroundColor, fontWeight: FontWeight.w700)))),
                                TextButton(
                                    onPressed: () {
                                      _awaitHttpFunction() async {
                                        var result = await updateLabels(
                                            await getJwt(context), labelsList);
                                        Navigator.pop(context, result);
                                      }

                                      _awaitHttpFunction();
                                    },
                                    child: Text("저장",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .backgroundColor)))
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: ReorderableListView(
                                onReorder: (int oldIndex, int newIndex) {
                                  setModalState(() {
                                    if (newIndex > oldIndex) {
                                      newIndex -= 1;
                                    }
                                    final Labels item =
                                        labelsList.removeAt(oldIndex);
                                    labelsList.insert(newIndex, item);
                                  });
                                },
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: List.generate(
                                    labelsList.length,
                                    (index) => Container(
                                        color: Theme.of(context)
                                            .dialogBackgroundColor,
                                        key: ValueKey("value$index"),
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.pop(
                                                  context, labelsList[index]);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 30,
                                                      height: 30,
                                                      color:
                                                          MyFunction.parseColor(
                                                              labelsList[index]
                                                                  .label_colors!
                                                                  .code!)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          "${labelsList[index].title}")),
                                                  Icon(Icons.menu_rounded)
                                                ],
                                              ),
                                            )))

                                    // TextButton(onPressed: () {}, child: Text("라벨 관리"))
                                    )))
                      ],
                    ))),
          );
        });
      });

  return result;
}
