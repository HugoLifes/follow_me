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

SharedPreferences prefs;

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController tk = TextEditingController();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  Posting post;
  var idUnida;
  bool press = false;
  bool nameValidator;
  String token;
  String name;
  Future<Send> sendData;
  Future<Send> send;
  bool validate = false;

  Future<Posting> newMethod(String tokn) async {
    final Uri url = Uri.parse(
        'http://192.168.1.110:8080/FollowMeBackend/web/index.php?r=follow-me-access/validate-token');
    final response = await http.post(url, body: {
      "params": json.encode({'token': tokn})
    });

    if (response.statusCode == 200) {
      var data = response.body;

      return postingFromJson(data);
    } else {
      return null;
    }
  }

  showAlertDialog() {
    // ignore: deprecated_member_use
    Widget okButton = FlatButton(
        onPressed: () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Text('OK'));

    AlertDialog alert = AlertDialog(
      title: Text('Atención!'),
      content: Text('Ha finalizado el tiempo de rastreo, gracias!'),
      actions: [okButton],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                '¡Bienvenido!',
                style: TextStyle(
                    color: Color(0xFF444444),
                    fontSize: 35,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
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
          border:
              Border.all(color: Color(0xFF444444), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(25),
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
              begin: FractionalOffset.topRight,
              end: FractionalOffset.bottomLeft)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Opss!',
            style: TextStyle(
                fontSize: 30,
                fontFamily: 'Roboto',
                color: Colors.red,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'No has introducido un token :(',
            style: TextStyle(
                fontSize: 19,
                fontFamily: 'Roboto',
                color: Colors.red,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Volver a intoducir',
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Roboto',
                color: Colors.red,
                fontWeight: FontWeight.w800),
          )
        ],
      ));

  flip() => FlipCard(
        key: cardKey,
        flipOnTouch: validate,
        front: textBox(),
        back: errorLog(),
      );

  imageContainer() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
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
              border: Border.all(
                  color: Color(0xFF444444), style: BorderStyle.solid),
              gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.lightBlue[600],
                    Colors.lightBlue[700]
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
          height: 260,
          width: 350,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Introduce aqui tu token!',
                  style: TextStyle(
                      color: Color(0xFF444444),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Montserrat'),
                ),
                CustomTextField(
                  controller: tk,
                  icon: Icon(
                    Icons.vpn_key,
                    color: Colors.white,
                  ),
                  hint: 'Introducir llave aqui',
                  validator: (nameValidator) {
                    if (nameValidator == null || nameValidator.isEmpty) {
                      setState(() {
                        if (mounted) {
                          if (cardKey.currentState.isFront == true) {
                            cardKey.currentState.toggleCard();
                            validate = true;
                          }
                        }
                      });
                      return ' ';
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

                if (post.value == 0) {
                  showAlertDialog();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyHomePage()),
                  );
                }
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
