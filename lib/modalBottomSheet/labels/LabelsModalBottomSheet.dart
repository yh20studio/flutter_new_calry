import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LabelsEditModalBottomSheet.dart';
import '../../domain/labels/Labels.dart';
import '../../functions.dart';
import '../../widgets/ContainerWidget.dart';

labelsModalBottomSheet(List<Labels> labelsList, BuildContext context) async {
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
                  color: Colors.transparent,
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
                                      child: Center(child:Text("라벨 선택",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .backgroundColor, fontWeight: FontWeight.w700)))),
                                  TextButton(
                                      onPressed: () {
                                        _awaitEdit() async {
                                          var result =
                                              await labelsEditModalBottomSheet(
                                                  labelsList, context);
                                          if (result != null) {
                                            setModalState(() {
                                              labelsList = result;
                                            });
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            final String encodedData =
                                                Labels.encode(labelsList);
                                            await prefs.setString(
                                                'labels', encodedData);
                                          }
                                        }

                                        _awaitEdit();
                                      },
                                      child: Text("편집",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .backgroundColor)))
                                ],
                              )),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: overlayContainerWidget(
                                context: context,
                                widget: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: labelsList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
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
                                                  color: MyFunction.parseColor(
                                                      labelsList[index]
                                                          .label_colors!
                                                          .code!),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        "${labelsList[index].title}"))
                                              ],
                                            ),
                                          ));
                                    })),
                          ),
                        ],
                      ))),
            );
          },
        );
      });

  return result;
}
