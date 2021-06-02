import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_me/inicio.dart';
import 'package:follow_me/methods/json2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'map.dart';
import 'json.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicio(),
    // rutas de las paginas
    routes: <String, WidgetBuilder>{
      '/screen1': (_) => Inicio(),
      '/screen2': (_) => MyHomePage()
    },
  ));

  //añadidos especiales para performance chrome
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

// guardado en memoria
SharedPreferences prefs;

class MyApp extends StatefulWidget {
  //inicia el guardado de memoria
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Map',
        debugShowCheckedModeBanner: false,
        home: MyHomePage(
          title: 'Rastreo',
        ));
  }
}

//recibe el idUnit del metodo post
dataOff(id) async {
  await MyApp.init();
  prefs.setInt('id', id);
}

//hace el get al url de segun el id obtenido obtendra datos especificos

// con este future aplicas el nuevo json mas rapido

//cambia estado la clase
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.post}) : super(key: key);
  final String title;
  final Future<Post> post;
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var greeting;
  Welcome hi;
  var lat;
  var lng;
  LatLng ubi;
  var unidad;
  var comp;
  var fechaf;
  Timer timer;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<Welcome> newPost() async {
    prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    Uri url = Uri.parse(
        'http://192.168.1.110:8080/FollowMeBackend/web/index.php?r=follow-me-access/info-unidad&unitId=${id.toString()}');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      var data = resp.body;

      return welcomeFromJson(data);
    } else {
      return null;
    }
  }

  //obtiene los datos que quieres
  getData() async {
    final Welcome hello = await newPost();
    setState(() {
      if (mounted) {
        hi = hello;
        lat = double.parse(hi.data.latitud);
        lng = double.parse(hi.data.longitud);
        ubi = LatLng(lat, lng);
        comp = hi.data.compania;
        unidad = hi.data.idUnidad;
        fechaf = hi.fechaFinal;
      }
    });
  }

  dif() {
    var exp = DateTime.parse(fechaf).hour;
    var exp2 = DateTime.parse(fechaf).minute;
    var exp3 = DateTime.parse(fechaf).second;

    var dias = DateTime.now().day;
    var horaActual = DateTime.now().hour;
    var minActual = DateTime.now().minute;
    var secActual = DateTime.now().second;

    var diff = exp - horaActual;
    var diff2 = exp2 - minActual;
    var diff3 = exp3 - secActual;
    Duration start = Duration(
      hours: diff,
      minutes: diff2,
      seconds: diff3,
    ).abs();
    Duration end = Duration(hours: 0, minutes: 0, seconds: 0);

    return start != end ? start : end;
  }

  cuentaAtras() => SlideCountdownClock(
        duration: dif(),
        slideDirection: SlideDirection.Down,
        separator: ":",
        onDone: () {
          setState(() {
            if (mounted) {
              showAlertDialog();
            }
          });
        },
        textStyle: TextStyle(fontSize: 15, color: Colors.white),
      );

  Timer timer2;

  @override
  //estado inicializarod
  void initState() {
    //todo lo que este aqui se inicializa

    newPost();
    getData();
    //cuando la app abre
    super.initState();

    //refresh()

    timer2 = Timer.periodic(Duration(seconds: 1), (timer) => {refresh()});
  }

  // refresquea el url para obtener datos en vivo
  refresh() {
    setState(() {
      if (mounted) {
        getData();
        newPost();
      }
    });
  }

  //finaliza los estados
  @override
  void dispose() {
    newPost();
    getData();
    dif();
    timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

          //barra superior que muesta informacion obtenida del get
          appBar: AppBar(
            elevation: 4,
            backgroundColor: Colors.white,
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
            ),
            actions: [
              //elementos de la app bar

              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    unidad != null
                        ? Text(
                            '$unidad',
                            style: TextStyle(
                                color: Colors.lightBlue[900],
                                fontWeight: FontWeight.w500),
                          )
                        : Container(),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      comp != null
                          ? Text('$comp',
                              style: TextStyle(
                                  color: Colors.lightBlue[900],
                                  fontWeight: FontWeight.w500))
                          : Container()
                    ],
                  )),
            ],
          ),

          //llama al google map
          body: ubi != null
              ? GglMap(
                  ubi: ubi,
                  fechita: cuentaAtras(),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  showAlertDialog() {
    Widget okButton = FlatButton(
        onPressed: () {
          if (mounted) {
            Navigator.of(context)..pop()..pop();
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

  showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Su sesion ha expirado! Gracias.')));
  }
}
