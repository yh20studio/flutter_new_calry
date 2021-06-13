import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/detail/ArchivesDetail.dart';

class ArchivesList extends StatefulWidget {
  ArchivesList({Key? key}) : super(key: key);

  @override
  _ArchivesListstate createState() => _ArchivesListstate();
}

class _ArchivesListstate extends State<ArchivesList> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: Text('Archives List'),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Container(
                child: FutureBuilder<List<Archives>>(
                    future: getArchives(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        print('no data');
                        return Container();
                      } else if (snapshot.hasError) {
                        print('Error');
                        return Text('Error');
                      } else {
                        return Wrap(
                            spacing: 8.0, // gap between adjacent chips
                            runSpacing: 4.0, // gap between lines
                            children: List.generate(
                                snapshot.data!.length,
                                (i) => listViewArchives(
                                    index: i,
                                    archives: snapshot.data![i],
                                    width: _width,
                                    context: context)).toList());
                      }
                    }))
          ],
        ))));
  }

  Widget listViewArchives(
      {required int index,
      required Archives archives,
      required double width,
      required BuildContext context}) {
    return InkWell(
        onTap: () => _awaitReturnValueFromArchivesDetail(archives),
        child: Container(
            width: width,
            padding: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
            child: Column(children: [
              Text(archives.title!),
              Text(archives.content!),
              Text(archives.url!),
              Text(archives.author!),
            ])));
  }

  void _awaitReturnValueFromArchivesDetail(Archives archives) async {
    var awaitResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArchivesDetail(
                  archives: archives,
                )));
    if (awaitResult == 'delete') {
      setState(() {
        print('reload');
      });
    }
  }
}
