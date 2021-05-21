import 'dart:convert';
import 'package:follow_me/json.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:follow_me/main.dart';
import 'package:follow_me/methods/textForms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:follow_me/methods/json2.dart';

SharedPreferences prefs;

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController tk = TextEditingController();
  bool _autovalidate = false;
  Posting post;
  var idUnida;
  bool press = false;
  bool nameValidator;
  String token;
  String name;
  Future<Send> sendData;
  Future<Send> send;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.pink,
              centerTitle: true,
              elevation: 3,
              title: Text('Soluciones Moviles'),
            ),
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/rastreo-gps.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 200,
                          width: 300,
                          child: Form(
                            key: _formKey,
                            child: Card(
                              elevation: 3,
                              color: Colors.white,
                              child: CustomTextField(
                                controller: tk,
                                icon: Icon(Icons.vpn_key),
                                hint: 'Introduce tu llave',
                                validator: (nameValidator) {
                                  if (nameValidator == null ||
                                      nameValidator.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 30),
                          child: MaterialButton(
                            elevation: 3,
                            color: Colors.pink,
                            onPressed: () async {
                              final String token = tk.text;
                              if (_formKey.currentState.validate()) {
                                final Posting posting = await newMethod(token);
                                setState(() {
                                  post = posting;
                                  dataOff(post.unitId);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => MyApp()));
                                });
                              }
                            },
                            child: Text(
                              'Check',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }

  Future<Posting> newMethod(String tokn) async {
    final Uri url = Uri.parse(
        'http://192.168.1.110:8080/FollowMeBackend/web/index.php?r=follow-me-access/validate-token');
    final response = await http.post(url, body: {
      "params": json.encode({'token': tokn})
    });

    if (response.statusCode == 200) {
      final String data = response.body;

      return postingFromJson(data);
    } else {
      return null;
    }
  }
}
