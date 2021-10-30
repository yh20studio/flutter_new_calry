import 'package:flutter/material.dart';
import 'package:flutter_new_calry/domain/labels/Labels.dart';
import 'package:flutter_new_calry/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LabelsEditModalBottomSheet.dart';

labelsModalBottomSheet(List<Labels> labelsList, BuildContext context) async {
  var result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width * 0.7 <= 300 ? MediaQuery.of(context).size.width * 0.7 : 300,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Wrap(
                        children: [
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: labelsList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      Navigator.pop(context, labelsList[index]);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            color: MyFunction.parseColor(labelsList[index].label_colors!.code!),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(child: Text("${labelsList[index].title}"))
                                        ],
                                      ),
                                    ));
                              }),
                          TextButton(
                              onPressed: () {
                                _awaitEdit() async {
                                  var result = await labelsEditModalBottomSheet(labelsList, context);
                                  if (result != null) {
                                    setModalState(() {
                                      labelsList = result;
                                    });
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    final String encodedData = Labels.encode(labelsList);
                                    await prefs.setString('labels', encodedData);
                                  }
                                }

                                _awaitEdit();
                              },
                              child: Text("라벨 관리"))
                        ],
                      ))),
            );
          },
        );
      });

  return result;
}
