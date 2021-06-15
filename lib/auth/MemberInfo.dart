import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MemberInfo extends StatefulWidget {
  MemberInfo({Key? key, this.member}) : super(key: key);

  final Member? member;
  @override
  _MemberInfostate createState() => _MemberInfostate();
}

class _MemberInfostate extends State<MemberInfo> {
  Member? member;

  @override
  void initState() {
    member = widget.member!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: Text("Member Info"),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Text(member!.email!),
            Text(member!.name!),
            TextButton(onPressed: _httpPostLogout, child: Text('Logout'))
          ],
        ))));
  }

  void _httpPostLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var httpResult = await postLogout(
        prefs.getString('grantType'),
        prefs.getString('accessToken'),
        prefs.getInt('accessTokenExpiresIn'),
        prefs.getString('refreshToken'));
    if (httpResult.statusCode == 200) {
      prefs.remove('grantType');
      prefs.remove('accessToken');
      prefs.remove('accessTokenExpiresIn');
      prefs.remove('refreshToken');
    }

    Navigator.pop(context, 'Logout');
  }
}
