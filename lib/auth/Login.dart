import 'package:flutter/material.dart';
import 'package:flutter_webservice/auth/SignUp.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'package:flutter_webservice/auth/SignUp.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _Loginstate createState() => _Loginstate();
}

class _Loginstate extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            authTestInputForm(
                controller: _emailController,
                title: 'Email',
                width: _width,
                context: context),
            authTestInputForm(
                controller: _passwordController,
                title: 'Password',
                width: _width,
                context: context),
            TextButton(child: Text("Login"), onPressed: _httpPostLogin),
            TextButton(child: Text("Sign Up"), onPressed: _awaitFromSignUp),
          ],
        ))));
  }

  Widget authTestInputForm(
      {required TextEditingController controller,
      required String title,
      required double width,
      required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Text(title, style: Theme.of(context).textTheme.headline2),
        ),
        Container(
          width: width * 0.8,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.transparent),
          child: TextFormField(
            style: TextStyle(fontSize: 30),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: controller,
            decoration: InputDecoration(
                disabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.only(top: 0.0)),
          ),
        ),
      ],
    );
  }

  void _httpPostLogin() async {
    var httpResult =
        await postLogin(_emailController.text, _passwordController.text);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('grantType', jsonDecode(httpResult)['grantType']);
    prefs.setString('accessToken', jsonDecode(httpResult)['accessToken']);
    prefs.setInt(
        'accessTokenExpiresIn', jsonDecode(httpResult)['accessTokenExpiresIn']);
    prefs.setString('refreshToken', jsonDecode(httpResult)['refreshToken']);
    Navigator.pop(context, 'success');
  }

  void _awaitFromSignUp() async {
    var awaitResult = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUp()));
    if (awaitResult == 'delete') {
      setState(() {
        print('reload');
      });
    }
  }
}
