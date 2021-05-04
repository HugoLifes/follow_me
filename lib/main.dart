import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:follow_me/inicio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'map.dart';
import 'json.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
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
      ),
    );
  }
}

Future<Post> fetchPost() async {
  String user = 'GSFWEB';
  String pass = 'a123456b';
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('$user:$pass'));

  Uri url = Uri.parse(
      'https://nd.trackcms.com:8080/http://b.trackcms.com/webservice/custom/followmewebservice.php?format=json&unidadId=13224');
  final response = await http.get(
    url,
    headers: <String, String>{
      'Authorization': basicAuth,
      'x-content-type-options':
          'followmewebservice.php?format=json&unidadId=13574',
    },
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
  Timer timer;
  Timer timer2;

  var stream;

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

  void refresh() {
    setState(() {
      stream = fetchPost();
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
              child: GestureDetector(
                  onTap: () {},
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
                            return Text('Algo ha fallado');
                          }
                          return Container(
                            height: 0.0,
                            width: 0.0,
                          );
                        },
                      )
                    ],
                  ))),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {},
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
                            return Text('Halgo ha fallado');
                          }
                          return Container(
                            height: 0.0,
                            width: 0.0,
                          );
                        },
                      )
                    ],
                  ))),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('$greeting')],
                  ))),
        ],
      ),
      body: Map(
        post: fetchPost(),
      ),
    );
  }
}
