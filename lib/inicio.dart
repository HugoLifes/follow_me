import 'dart:convert';
import 'package:follow_me/json.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:follow_me/main.dart';
import 'package:follow_me/methods/textForms.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map.dart';

SharedPreferences prefs;

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController tk = TextEditingController();
  bool _autovalidate = false;

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
        body: sendData == null
            ? SafeArea(
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
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  Future.delayed(Duration(seconds: 1),
                                      () async {
                                    setState(() {
                                      sendData = post(tk.text).whenComplete(
                                          () => {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyApp()))
                                              });
                                    });
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
              )
            : nexty(sendData),
      ),
    );
  }

  FutureBuilder<Send> nexty(sendData) {
    return FutureBuilder<Send>(
      future: Future.delayed(Duration(seconds: 1), () => (sendData)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var id = snapshot.data.idU;
          return dataOff(id);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.pink,
        ));
      },
    );
  }

  Future<Send> post(String tokn) async {
    Uri url = Uri.parse(
        'http://192.168.1.110:8080/FollowMeBackend/web/index.php?r=follow-me-access/validate-token');
    var res = await http.post(url, body: {
      "params": json.encode({'token': tokn})
    });
    print('${res.body}');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      return Send.fromJson(data);
    } else {
      throw Exception('Falies to load data');
    }
  }
}
