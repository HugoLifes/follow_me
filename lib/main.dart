import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_me/inicio.dart';

import 'package:http/http.dart' as http;
import 'map.dart';
import 'json.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicio(),
    routes: <String, WidgetBuilder>{
      '/screen1': (_) => Inicio(),
      '/screen2': (_) => MyApp()
    },
  ));
}

SharedPreferences prefs;

class MyApp extends StatefulWidget {
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
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(
          title: 'Rastreo',
          post: fetchPost(),
        ));
  }
}

dataOff(id) async {
  await MyApp.init();
  prefs.setString('id', id);

  /*  id = prefs.getString('id');
  print('aqui el id: $id'); */
}

Future<Post> fetchPost() async {
  prefs = await SharedPreferences.getInstance();
  var id = prefs.getString('id');

  Uri url = Uri.parse(
      'http://192.168.1.110:8080/FollowMeBackend/web/index.php?r=follow-me-access/info-unidad&unitId=$id');

  final response = await http.get(
    url,
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);

    return Post.formJson(data);
  } else {
    throw Exception('falied to load');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.post}) : super(key: key);
  final String title;
  final Future<Post> post;

  @override
  _MyHomePageState createState() => _MyHomePageState(post: fetchPost());
}

class _MyHomePageState extends State<MyHomePage> {
  static String greeting = "";

  Timer timer2;

  _MyHomePageState({Future<Post> post});

  @override
  void initState() {
    super.initState();

    timer2 = Timer.periodic(Duration(seconds: 1), (timer) => refresh());
  }

  void refresh() {
    setState(() {
      if (mounted) {
        fetchPost();
      }
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
                      } else if (snapshot.hasError) {
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
                          print('Hola aqui estoy: $unidad');
                          return Text('$unidad');
                        } else if (snapshot.hasError) {
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
                  children: [Text('$greeting')],
                )),
          ],
        ),
        body: Mapas(
          post: fetchPost(),
        ));
  }
}
