import 'package:flutter/material.dart';

import '../../domain/labels/Labels.dart';
import '../../functions.dart';
import '../../controller/labels/LabelsController.dart';

labelsEditModalBottomSheet(List<Labels> labelsList, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState) {
          return SafeArea(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Wrap(
                      children: [
                        Row(
                          children: [
                            IconButton(onPressed: () => Navigator.pop(context, null), icon: Icon(Icons.close)),
                            Expanded(
                              child: Center(child: Text("Label 관리")),
                            ),
                            TextButton(
                                onPressed: () {
                                  _awaitHttpFunction() async {
                                    var result = await updateLabels(labelsList);

                                    Navigator.pop(context, result);
                                  }

                                  _awaitHttpFunction();
                                },
                                child: Text("저장"))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ReorderableListView(
                            onReorder: (int oldIndex, int newIndex) {
                              setModalState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final Labels item = labelsList.removeAt(oldIndex);
                                labelsList.insert(newIndex, item);
                              });
                            },
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                labelsList.length,
                                (index) => Container(
                                    color: Colors.white,
                                    key: ValueKey("value$index"),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context, labelsList[index]);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Container(width: 30, height: 30, color: MyFunction.parseColor(labelsList[index].label_colors!.code!)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(child: Text("${labelsList[index].title}")),
                                              Icon(Icons.menu_rounded)
                                            ],
                                          ),
                                        )))

                                // TextButton(onPressed: () {}, child: Text("라벨 관리"))
                                ))
                      ],
                    ))),
          );
        });
      });

  return result;
}
