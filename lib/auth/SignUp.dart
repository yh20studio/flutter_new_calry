import 'package:flutter/material.dart';
import 'package:flutter_webservice/class.dart';
import 'package:flutter_webservice/httpFunction.dart';
import 'dart:convert';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpstate createState() => _SignUpstate();
}

class _SignUpstate extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

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
            authTestInputForm(
                controller: _passwordConfirmController,
                title: 'Password Confirm',
                width: _width,
                context: context),
            authTestInputForm(
                controller: _nameController,
                title: 'Name',
                width: _width,
                context: context),
            FlatButton(child: Text("Sign Up"), onPressed: _httpPostSignUp),
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

  void _httpPostSignUp() async {
    var httpResult = await postSignUp(
        _emailController.text, _passwordController.text, _nameController.text);

    Navigator.pop(context, 'success');
  }
}
