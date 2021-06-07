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

  //alerta que se muestra cuando el token ha expirado o no
  showAlertDialog() {
    // ignore: deprecated_member_use

    // se activa el boton cuando
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
      content: Text('El token es incorrecto o ha expirado!'),
      actions: [okButton],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Image.asset(
                        'assets/images/fmc.png',
                        fit: BoxFit.fitHeight,
                        height: 50,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: Text(
                        'FollowMe',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.lightBlue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    )
                  ],
                )),
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 600) {
                  return SafeArea(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // aqui esta la imagen
                          imageContainer(screenWidth, screenHeight),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // aqui va el textBox
                              Container(child: flip(screenWidth, screenHeight))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return SafeArea(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: ListView(
                        children: [
                          // aqui esta la imagen
                          //imageContainer(screenWidth, screenHeight),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              'Comencemos!',
                              style: TextStyle(
                                  color: Colors.lightBlue[900],
                                  fontSize: 35,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              'Introduce aqui tu token!',
                              style: TextStyle(
                                  color: Color(0xFF444444),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // aqui va el textBox
                              Container(child: flip(screenWidth, screenHeight))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            )));
  }

  // la parte trasera del funcion flip
  // si se desea agregar otro añdido, checar aqui y checar pub dev flip
  errorLog(screenWidth, screenHeight) => screenWidth >= 600
      ? Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Color(0xFF444444), style: BorderStyle.solid),
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
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 3.6,
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
            ),
          ))
      // parte responsiva
      : Container(
          height: 250,
          width: 300,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Color(0xFF444444), style: BorderStyle.solid),
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
          child: Container(
            height: 500,
            width: 500,
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
            ),
          ));

  // estado que voltea la tarketa
  flip(screenWidth, screenHeight) => FlipCard(
        key: cardKey,
        flipOnTouch: validate,
        front: textBox(screenWidth, screenHeight),
        back: errorLog(screenWidth, screenHeight),
      );

//dimensiones de las imagenes
  imageContainer(screenWidth, screenHeight) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          screenWidth >= 600
              ? Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/fm.png'),
                        fit: BoxFit.fitHeight),
                  ),
                )
              // desde aqui
              //Parte responsiva
              : Container(
                  height: 200,
                  width: 200,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/fm.png'),
                        fit: BoxFit.cover),
                  ),
                ),
        ],
      );

  textBox(screenWidth, screenHeight) => screenWidth >= 600
      ? Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 3.5,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 3,
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
              child: Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width / 3,
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

                      //definicion del text box
                      Container(
                        child: CustomTextField(
                          controller: tk,
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                          ),
                          hint: 'Introducir llave aqui',

                          //validaciones para no entrar con cualquier cosa
                          validator: (nameValidator) {
                            if (nameValidator == null ||
                                nameValidator.isEmpty) {
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
                      ),
                      botonCheck(screenWidth, screenHeight)
                    ],
                  ),
                ),
              ),
            ),
          ),
        )

      //version responva de la imagen
      : Container(
          height: 250,
          width: 250,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Container(
              height: 200,
              width: 300,
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
              child: Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //definicion del text box
                      Container(
                        child: CustomTextField(
                          controller: tk,
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                          ),
                          hint: 'Introducir llave aqui',

                          //validaciones para no entrar con cualquier cosa
                          validator: (nameValidator) {
                            if (nameValidator == null ||
                                nameValidator.isEmpty) {
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
                      ),
                      botonCheck(screenWidth, screenHeight)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

  // boton que maneja el estado y hace la solicitud post
  botonCheck(screenWidth, screenHeight) => screenWidth >= 600
      ? Container(
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 10.3,
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
                  // llama a la funcion que guarda en memoria para
                  dataOff(post.unitId);

                  // confirmacion si el token aun es valido
                  if (post.value == 0) {
                    showAlertDialog();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MyHomePage(
                                token: token,
                              )),
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
        )
      // parte responsiva
      : Container(
          height: 80,
          width: 100,
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
                  // llama a la funcion que guarda en memoria para
                  dataOff(post.unitId);

                  // confirmacion si el token aun es valido
                  if (post.value == 0) {
                    showAlertDialog();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MyHomePage(
                                token: token,
                              )),
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
