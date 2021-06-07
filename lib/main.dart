import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_me/inicio.dart';
import 'package:follow_me/methods/json2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'map.dart';
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

// simple consumo de web service por metodo get
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

//hace el get al url de segun el id obtenido obtendra datos especificos

// con este future aplicas el nuevo json mas rapido

//cambia estado la clase
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.token}) : super(key: key);
  final token;
  final String title;

  // inicia el guardado en memoria
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // revisar muy bien donde se usan las variables si se desea cambiar alguna
  var greeting;
  Welcome hi;
  var lat;
  var lng;
  LatLng ubi;
  var unidad;
  var comp;
  var fechaf;
  Timer timer;
  Duration refreshT = Duration(seconds: 1);

  AnimationController animationController;

  //obtiene los datos que quieras segun el modelo de datos
  // revisar jsno2.dart
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

  // saca la diferencia de fechas
  dif() {
    var exp0 = DateTime.parse(fechaf).day;
    var exp = DateTime.parse(fechaf).hour;
    var exp2 = DateTime.parse(fechaf).minute;
    var exp3 = DateTime.parse(fechaf).second;

    var dias = DateTime.now().day;
    var horaActual = DateTime.now().hour;
    var minActual = DateTime.now().minute;
    var secActual = DateTime.now().second;

    var diff0 = exp0 - dias;
    var diff = exp - horaActual;
    var diff2 = exp2 - minActual;
    var diff3 = exp3 - secActual;
    Duration start = Duration(
      days: diff0 != null ? diff0 : 0,
      hours: diff,
      minutes: diff2,
      seconds: diff3,
    ).abs();
    Duration end = Duration(hours: 0, minutes: 0, seconds: 0);

    return start != end ? start : end;
  }

  cuentaAtras() => SlideCountdownClock(
        shouldShowDays: true,
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
    animationController =
        AnimationController(duration: Duration(seconds: 8), vsync: this);
    newPost();
    getData();

    animationController.repeat();
    //cuando la app abre
    super.initState();

    //refresh()

    timer2 = Timer.periodic(Duration(seconds: 60), (timer) => {refresh()});
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
    animationController.dispose();
    newPost();
    getData();
    dif();
    timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: true,
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
              actions: [],
            ),

            //llama al google map
            body: ubi != null
                ? GglMap(
                    token: widget.token,
                    ubi: ubi != null ? ubi : LatLng(28.6353, -106.089),
                    contador: cuentaAtras(),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: animationController.drive(ColorTween(
                          begin: Colors.lightBlue[400],
                          end: Colors.green[400])),
                    ),
                  ))

        // parte responsiva

        );
  }

  showAlertDialog() {
    // ignore: deprecated_member_use
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
}
