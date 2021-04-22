import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:follow_me/main.dart';
import 'package:follow_me/methods/textForms.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'map.dart' as mp;

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController tk = TextEditingController();
  bool _autovalidate = false;
  bool _success;
  String token;
  String name;
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
            decoration: new BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/rastreo-gps.jpg'),
                    fit: BoxFit.cover)),
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
                            onSaved: (input) {
                              token = input;
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
                          await acceptTk();
                          if (_formKey.currentState.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Token Validado",
                            )));
                          }
                        },
                        child: Text(
                          'Check',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tk.dispose();
  }

  Future<void> acceptTk() async {
    Map<String, dynamic> decodeToken = JwtDecoder.decode(tk.text);
    bool isTokenExpired = JwtDecoder.isExpired(tk.text);
    if (isTokenExpired == false) {
      setState(() {
        _success = true;
        token = decodeToken["name"];
        print('$token');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      });
    } else {
      _success = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Token expirado')));
    }
  }
}
