import 'dart:async';
import 'dart:math' as math;
import 'package:follow_me/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as web;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'json.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

class Mapas extends StatefulWidget {
  Mapas({Key key, this.post}) : super(key: key);
  final Future<Post> post;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Mapas> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.post,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var lat = double.parse(snapshot.data.latitud);
            var lng = double.parse(snapshot.data.longitud);
            LatLng ubi = LatLng(lat, lng);
            return GglMap(
              ubi: ubi,
              post: fetchPost(context),
            );
          } else if (snapshot.hasData) {
            return GglMap(
              post: fetchPost(context),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

next(context) {
  return Navigator.pop(context);
}

// ignore: must_be_immutable
class GglMap extends StatefulWidget {
  GglMap({Key key, this.post, this.ubi}) : super(key: key);
  final Future<Post> post;
  LatLng ubi;

  @override
  _GglMapState createState() => _GglMapState();
}

class _GglMapState extends State<GglMap> {
  var left;
  var right;
  var top;
  var bottom;

  web.MarkerController _control;
  GoogleMapController _googleMapController;
  Map<MarkerId, Marker> marker2 = <MarkerId, Marker>{};
  // variable para setear varias ubicaciones
  List<LatLng> ubis = [];
  // variable para setear varios markadores
  List<Marker> marker = [];
  Timer timer;

  navView() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 1,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Soluciones Moviles',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 28, top: 10),
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Text(
                            'Status  de unidad',
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 90, top: 13),
                        alignment: Alignment.centerLeft,
                        child: Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Combustible',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 15),
                              speedO(0, 'Litros'),
                            ],
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 110, top: 13),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Velocidad',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 15),
                                FutureBuilder<Post>(
                                  future: widget.post,
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      // parseo los valores de la latitud
                                      var vel = snapshot.data.velocidad;
                                      // creo el objeto con la posicion

                                      // creo una vista inicial parametrando los valores anteriores
                                      // temp
                                      print(vel);
                                      return dbl(vel, 2);
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }

                                    return CircularProgressIndicator();
                                  },
                                )
                              ],
                            )
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 110, top: 13),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Text(
                              'Temperatura',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            FutureBuilder<Post>(
                              future: widget.post,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  // parseo los valores de la latitud
                                  var temp = snapshot.data.temperatura;
                                  // creo el objeto con la posicion
                                  //
                                  // creo una vista inicial parametrando los valores anteriores
                                  // temp
                                  print(temp);

                                  return dbl(temp, 1);
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.hasError}');
                                }

                                return CircularProgressIndicator();
                              },
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  dbl(var a, var b) {
    a = double.parse(a);
    a.round();
    switch (b) {
      case 1:
        {
          if (a != 0) {
            b = "°C";
          } else {
            b = "N/C";
          }
        }
        break;
      case 2:
        {
          b = "MPH";
        }
        break;
      case 3:
        {
          b = 'Litros';
        }
        break;
    }
    return speedO(a, b);
  }

  speedO(double val, var b) => Container(
        alignment: Alignment.bottomCenter,
        height: 170,
        width: 170,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Container(
                        child: Column(children: <Widget>[
                      Text(val.round().toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text(b.toString(),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold))
                    ])),
                    angle: 90,
                    positionFactor: 0.75)
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                    value: val,
                    needleLength: 0.95,
                    enableAnimation: true,
                    animationType: AnimationType.ease,
                    needleStartWidth: 1.5,
                    needleEndWidth: 6,
                    needleColor: Colors.red,
                    knobStyle: KnobStyle(knobRadius: 0.09))
              ],
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 200,
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.03,
                    endWidth: 0.03,
                    gradient: SweepGradient(colors: const <Color>[
                      Colors.green,
                      Colors.yellow,
                      Colors.red
                    ], stops: const <double>[
                      0.0,
                      0.5,
                      1
                    ]))
              ],
              minimum: 0,
              maximum: 200,
              labelOffset: 30,
              axisLineStyle: AxisLineStyle(
                  thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03),
              majorTickStyle:
                  MajorTickStyle(length: 6, thickness: 4, color: Colors.black),
              minorTickStyle:
                  MinorTickStyle(length: 3, thickness: 3, color: Colors.black),
              axisLabelStyle: GaugeTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14))
        ]),
      );
  @override

  // inicializa algunos estados como el seteo de las ubicaciones y seteo de markers
  void initState() {
    // contador para refrescar marcadores
    timer = Timer.periodic(
        Duration(seconds: 2), (timer) => {refresh(), addMarkers()});

    super.initState();
  }

  //se encarga de refrescar y añadir un nuevo elemento cuando se actualiza
  refresh() async {
    setState(() {
      addUbis();
    });
  }

  //funcion que añade nuevas posiciones al arreglo
  addUbis() {
    // si la la latitud es dif y la long tambien setea si no

    if (widget.ubi != widget.ubi) {
      setState(() {
        ubis.add(widget.ubi);
      });
    } else {
      ubis.add(widget.ubi);

      if (ubis.length <= 10) {
        ubis.removeRange(0, 8);
      }
      ubis.clear();
    }
  }

  // añade los markadores de la lista
  addMarkers() {
    //recorre el arreglo de las posiciones
    for (int i = 0; i < ubis.length; i++) {
      // setea el primer marcador con la primera posicion del arreglo
      Marker mark2 = Marker(
          markerId: MarkerId('$ubis'),
          position: ubis[i],
          infoWindow: InfoWindow(title: 'Unidad a rastrear'));
      marker.clear();

      //si el marcador es diferente al anterior setea
      if (mark2.position != mark2.position) {
        setState(() {
          marker.add(mark2.clone());
        });
      } else {
        // borra las posiciones mas alla del largo permitido
        marker.add(mark2.clone());
        if (marker.length > 2) {
          marker.removeRange(0, 1);
        }

        // saca los maximos y minimos para dar angulo

      }
    }
  }

  //cancela estados
  @override
  void dispose() {
    marker.clear();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // la Web view se basa mediante la data obtenida por la altura entre 2
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // el mapa y sus caracteristicas
          child: GoogleMap(
            myLocationEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(marker),
            initialCameraPosition: CameraPosition(target: widget.ubi, zoom: 15),
            //markers: markers,
            onMapCreated: _mapController,
          ),
        ),
        //bottom bar view, y sus elementos, tipos de vistas y alineaciones
        navView()
      ],
    );
  }

  _mapController(GoogleMapController controller) {
    setState(() {
      addMarkers();
      _googleMapController = controller;
    });
  }
}
