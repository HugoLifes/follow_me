import 'dart:async';
import 'dart:convert';
import 'dart:js';
import 'package:flutter/material.dart';
import 'package:follow_me/inicio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'map.dart';
import 'json.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicio(),
  ));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  var date;
  static Future init() async {
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
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(
          title: 'Rastreo',
          post: fetchPost(context),
        ));
  }
}

dataOff(id) async {
  await MyApp.init();
  prefs.setString('id', id);
}

Future<Post> fetchPost(context) async {
  var id = prefs.getString('id');
  Uri url = Uri.parse(
      'http://192.168.1.110:8080/FollowMeBackend/web/index.php?r=follow-me-access/info-unidad&unitId=$id');
  final response = await http.get(
    url,
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);

    var fecha = data['fechaFinal'];
    //print('$fecha');
    

    return Post.formJson(data['data']);
  } else {
    throw Exception('falied to load');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.post}) : super(key: key);
  final String title;
  final Future<Post> post;
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  var date;

  fecha(fecha) async {
    await MyHomePage.init();
    prefs.setString('fecha', fecha);
    //print('aqui la fecha : $date');
    date = prefs.getString('fecha');
    //print('Esta es la fecha final: $date');
  }

  @override
  _MyHomePageState createState() => _MyHomePageState(post: fetchPost(context));
}

open(value) async {
  await MyHomePage.init();
  prefs.setInt('val', value);

  //print('aqui: $val');
}




class _MyHomePageState extends State<MyHomePage> {
  static String greeting = "";
  Timer timer;
  Timer timer2;
  //var val = prefs.getInt('val');

  _MyHomePageState({Future<Post> post});

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic((Duration(seconds: 1)), (timer) {
      setState(() {
        greeting = "Time: ${DateTime.now().second}";
      });
    });

    timer2 = Timer.periodic(Duration(seconds: 2), (timer) => refresh());
  }


  void starTime(){
  
}

  void refresh() {
    setState(() {
      fetchPost(context);
    });
  }

  @override
  void dispose() {
    timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<Post>(
                    future: widget.post,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        var unidad = snapshot.data.idUnidad;
                        return Text('$unidad');
                      } else if (snapshot.hasData) {
                        return Text('Algo ha fallado');
                      }
                      return Container(
                        height: 0.0,
                        width: 0.0,
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<Post>(
                      future: widget.post,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          var unidad = snapshot.data.compania;
                          return Text('$unidad');
                        } else if (snapshot.hasData) {
                          return Text('Halgo ha fallado');
                        }
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      },
                    )
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('${widget.date}')],
                )),
          ],
        ),
        body: Mapas(
          post: fetchPost(context),
        ));
  }
}
