import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<List<dynamic>> getData() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2/no-banjir/login.php"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink(); //<---here
          } else {
            if (snapshot.hasData) {
              return Login(list: snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}

class Login extends StatefulWidget {
  final List<dynamic> list;
  const Login({super.key, required this.list});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textControllerUsername = TextEditingController();
  TextEditingController textControllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: textControllerUsername,
                decoration: InputDecoration(
                    hintText: 'Inputkan Username', icon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inputkan username';
                  }
                },
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: textControllerPassword,
                decoration: InputDecoration(
                    hintText: 'Inputkan Password', icon: Icon(Icons.lock)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inputkan password';
                  }
                },
              )),
          ElevatedButton(
              onPressed: () {
                for (int i = 0; i < widget.list.length; i++)
                  if ((widget.list[i]['username']) ==
                          textControllerUsername.text &&
                      (widget.list[i]['password']) ==
                          textControllerPassword.text) {
                    Navigator.pushNamed(context, '/dashboard',
                        arguments: widget.list[i]['username']);
                  } else {}
              },
              child: Text('Login')),
          Container(
            margin: EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: (() => Navigator.pushNamed(context, '/register')),
                child: Text('Registration Page')),
          )
        ],
      ),
    );
  }
}
