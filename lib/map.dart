import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter_platform_interface/src/types/marker_updates.dart'
    as markerUpdate;
import 'package:follow_me/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as web;
import 'package:location/location.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'json.dart';

class Map extends StatefulWidget {
  Map({Key key, this.post}) : super(key: key);
  final Future<Post> post;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  // initialView(context, widget, widget.ubi)
  // @override

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GglMap(
      post: fetchPost(),
    ));
  }
}

// ignore: must_be_immutable
class GglMap extends StatefulWidget {
  GglMap({Key key, this.post}) : super(key: key);
  final Future<Post> post;

  @override
  _GglMapState createState() => _GglMapState();
}

class _GglMapState extends State<GglMap> {
  GoogleMapController _googleMapController;
  var markers = Set<Marker>();
  var newMarker = Set<Marker>();
  var lat, lng;
  LatLng ubi;
  var oldLat;
  var oldLng;
  LatLng newUbi;
  Timer time;
  web.MarkerController control;

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Post>(
      future: widget.post,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          lat = double.parse(snapshot.data.latitud);
          lng = double.parse(snapshot.data.longitud);

          ubi = LatLng(lat, lng);
          markers.add(Marker(
              markerId: MarkerId(''),
              position: ubi,
              infoWindow: InfoWindow(title: 'first marker')));

          if (ubi != ubi) {
            newUbi = ubi;
            newMarker.add(Marker(
                markerId: MarkerId(''),
                position: newUbi,
                infoWindow: InfoWindow(title: 'Im scnd marker')));

            markerUpdate.MarkerUpdates.from(markers, newMarker);
          }

          print('$ubi');

          return Stack(
            children: [
              Container(
                // la Web view se basa mediante la data obtenida por la altura entre 2
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // el mapa y sus caracteristicas
                child: GoogleMap(
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(target: ubi, zoom: 15),
                  markers: markers,
                  onMapCreated: (
                    GoogleMapController controller,
                  ) {
                    _googleMapController = controller;

                    markerUpdate.MarkerUpdates.from(markers, newMarker);
                  },
                ),
              ),
              //bottom bar view, y sus elementos, tipos de vistas y alineaciones
              navView()
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
