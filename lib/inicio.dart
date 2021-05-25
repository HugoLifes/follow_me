import 'dart:convert';
import 'package:flip_card/flip_card.dart';
import 'package:follow_me/json.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:follow_me/main.dart';
import 'package:follow_me/methods/textForms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:follow_me/methods/json2.dart';
import 'package:slimy_card/slimy_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.lightBlue[300],
                        Colors.lightBlue[400]
                      ],
                      stops: [
                        0.1,
                        0.6,
                        0.7
                      ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // aqui esta la imagen
                    imageContainer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // aqui va el textBox
                        Container(child: flip())
                      ],
                    )
                  ],
                ),
              ),
            )));
  }

  errorLog() => Container(
      height: 250,
      width: 350,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.red[100], Colors.red[400], Colors.red[500]],
              stops: [0.1, 0.6, 0.7],
              begin: FractionalOffset.topRight,
              end: FractionalOffset.bottomLeft)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Opss!',
            style: TextStyle(),
          ),
          Text('No haz introducido un token :(')
        ],
      ));

  flip() => FlipCard(
        front: textBox(),
        back: errorLog(),
      );
  slimyCard() => Container(
        child: SlimyCard(
          color: Colors.lightBlue[300],
          width: 400,
          topCardHeight: 250,
          bottomCardHeight: 200,
          borderRadius: 15,
          topCardWidget: textBox(),
          bottomCardWidget: errorLog(),
          slimeEnabled: true,
        ),
      );

  imageContainer() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenido',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 51,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 2,
            decoration: new BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/fm.png'),
                  fit: BoxFit.fitHeight),
            ),
          ),
        ],
      );

  textBox() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.lightBlue[300],
                    Colors.lightBlue[400]
                  ],
                  stops: [
                    0.2,
                    0.7,
                    0.8
                  ],
                  begin: FractionalOffset.topRight,
                  end: FractionalOffset.bottomLeft),
              borderRadius: BorderRadius.circular(25)),
          alignment: Alignment.center,
          height: 250,
          width: 350,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextField(
                  controller: tk,
                  icon: Icon(Icons.vpn_key),
                  hint: 'Introduce llave de rastreo',
                  validator: (nameValidator) {
                    if (nameValidator == null || nameValidator.isEmpty) {
                      return 'Porfa';
                    }
                    return null;
                  },
                ),
                botonCheck()
              ],
            ),
          ),
        ),
      );

  botonCheck() => Container(
        width: 140,
        height: 80,
        padding: EdgeInsets.only(bottom: 30),
        child: MaterialButton(
          elevation: 5,
          color: Color(0xFF444444),
          onPressed: () async {
            final String token = tk.text;
            if (_formKey.currentState.validate()) {
              final Posting posting = await newMethod(token);
              setState(() {
                post = posting;
                dataOff(post.unitId);

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MyApp()));
              });
            }
          },
          child: Text(
            'Buscar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
}
