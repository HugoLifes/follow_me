import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:follow_me/methods/datos.dart';
import 'package:follow_me/methods/responsive.dart';
import 'package:intl/intl.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:follow_me/main.dart';
import 'package:follow_me/methods/json2.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

// ignore: must_be_immutable
class GglMap extends StatefulWidget {
  GglMap({
    Key key,
    this.ubi,
    this.contador,
    this.token,
  }) : super(key: key);
  LatLng ubi;
  String token;
  var contador;

  @override
  _GglMapState createState() => _GglMapState();
}

class _GglMapState extends State<GglMap> {
  Welcome hi;
  NaviewResp naviewResp = new NaviewResp();
  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var unidad;
  var comp;
  var onlyDate;
  var fechaf;
  GoogleMapController _googleMapController;
  Map<MarkerId, Marker> marker2 = <MarkerId, Marker>{};
  // variable para setear varias ubicaciones
  List<LatLng> ubis = [];
  // variable para setear varios markadores
  List<Marker> marker = [];
  Timer timerCamera;
  Timer timer;
  var hora;
  var mins;
  var secs;
  Timer timer2;
  CustomTimerController controller = new CustomTimerController();

  getData2() async {
    final Welcome hello = await newPost();
    setState(() {
      hi = hello;
      comp = hi.data.compania;
      unidad = hi.data.idUnidad;
      fechaf = hi.fechaFinal;

      Future.delayed(
          Duration(seconds: 2),
          () => {
                onlyDate =
                    DateFormat("dd-MM-yyyy").format(DateTime.parse(fechaf)),
                hora = DateTime.parse(fechaf).hour,
                mins = DateTime.parse(fechaf).minute,
                secs = DateTime.parse(fechaf).second,
              });
    });
  }

  navView() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 1,
            child: Card(
              elevation: 4,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                      Colors.white,
                      Colors.lightBlue[300],
                      Colors.lightBlue[400]
                    ],
                        stops: [
                      0.2,
                      0.6,
                      0.7
                    ],
                        begin: FractionalOffset.topRight,
                        end: FractionalOffset.bottomLeft)),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // columna principal Transporte y Token
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // fila de texto token
                        Container(
                          width: 350,
                          child: Row(
                            children: [
                              Text(
                                'Token #',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  '${widget.token}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red[900]),
                                ),
                              )
                            ],
                          ),
                        ),

                        //Datos transportista
                        Container(
                          width: 350,
                          alignment: Alignment.centerLeft,
                          child: Text('Datos Transportista: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                        ),

                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 3.1,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid),
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // por alguna razon lo espacion cuentan
                                    // no borrar espacios
                                    comp != null
                                        ? Container(
                                            child: Text('Compañia: $comp    ',
                                                style: TextStyle(
                                                    color:
                                                        Colors.lightBlue[900],
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          )
                                        : Text(' '),

                                    //width: 100,
                                    Container(
                                      child: Text('Caja seca Num: 7823',
                                          style: TextStyle(
                                              color: Colors.lightBlue[900],
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600)),
                                    ),

                                    unidad != null
                                        ? Container(
                                            child: Text(
                                              'Unidad: $unidad             ',
                                              style: TextStyle(
                                                  color: Colors.lightBlue[900],
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        : Text(' '),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 500,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Datos del envío',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 18,
                            width: MediaQuery.of(context).size.width / 1.96,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid)),
                            child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Destino: Interceramic Chihuahua',
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600),
                                )),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 18,
                            width: MediaQuery.of(context).size.width / 1.96,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid)),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: onlyDate != null
                                  ? Text('Fecha de llegada: $onlyDate',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600))
                                  : Text('Fecha de llegada: Calculando...',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600)),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 18,
                            width: MediaQuery.of(context).size.width / 1.96,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid)),
                            child: Container(
                                padding: EdgeInsets.all(8),
                                child: hora != null &&
                                        mins != null &&
                                        secs != null
                                    ? Text(
                                        'Hora estimada: $hora:$mins:$secs  Hora Central',
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600))
                                    : Text('Hora estimada: Calculando.... ',
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  @override
  // inicializa algunos estados como el seteo de las ubicaciones y seteo de markers
  void initState() {
    newPost();
    getData2();
    // contador para refrescar marcadores
    timerCamera =
        Timer.periodic(Duration(seconds: 50), (timer) => {moveCamera()});

    timer = Timer.periodic(
        Duration(seconds: 1), (timer) => {addMarkers(), refresh()});

    super.initState();
  }

  //se encarga de refrescar y añadir un nuevo elemento cuando se actualiza
  refresh() async {
    setState(() {
      if (mounted) {
        addUbis();
      }
    });
  }

  //funcion que añade nuevas posiciones al arreglo
  addUbis() {
    // si la la latitud es dif y la long tambien setea si no
    ubis.add(widget.ubi);
    if (widget.ubi != widget.ubi) {
      setState(() {
        if (mounted) {
          ubis.add(widget.ubi);
        }
      });
    } else {
      ubis.add(widget.ubi);

      if (ubis.length <= 10) {
        ubis.removeRange(0, 8);
      }
      ubis.clear();
    }
  }

  //la camara hay que intentar moverla
  moveCamera() {
    var update = CameraPosition(
        target: LatLng(
            marker.first.position.latitude, marker.first.position.longitude),
        zoom: 15);
    var cameraUpdate = CameraUpdate.newCameraPosition(update);
    _googleMapController.animateCamera(cameraUpdate);
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
          if (mounted) {
            marker.add(mark2.clone());
          }
        });
      } else {
        // borra las posiciones mas alla del largo permitido
        marker.add(mark2.clone());
        if (marker.length > 2) {
          marker.removeRange(0, 1);
        }

        // saca los maximos y minimos para dar angulo
        //moveCamera();
      }
    }
  }

  //cancela estados
  @override
  void dispose() {
    super.dispose();
    newPost();
    getData2();
    timer2?.cancel();
    marker.clear();
    timerCamera?.cancel();
    timer?.cancel();
    _googleMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final List<Widget> _children = [
      googlemapa(screenWidth),
      DatosView(
        hora: hora,
        unidad: unidad,
        mins: mins,
        secs: secs,
        comp: comp,
        onlyDate: onlyDate,
        token: widget.token,
      )
    ];
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: screenWidth <= 880
            ? BottomNavigationBar(
                onTap: _onItemTapped,
                elevation: 5,
                currentIndex: _selectedIndex,
                items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.map), label: 'Mapa'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.data_usage), label: 'Info')
                  ])
            : null,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 880) {
              return Stack(
                children: [
                  Container(
                    // la Web view se basa mediante la data obtenida por la altura entre 2
                    height: MediaQuery.of(context).size.height / 1.65,
                    width: MediaQuery.of(context).size.width,
                    // el mapa y sus caracteristicas
                    child: GoogleMap(
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      //onCameraMoveStarted: moveCamera(),
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      markers: Set<Marker>.of(marker),
                      initialCameraPosition: CameraPosition(
                          target: widget.ubi != null
                              ? widget.ubi
                              : LatLng(28.6353, -106.089),
                          zoom: 15),
                      //markers: markers,
                      onMapCreated: _mapController,
                    ),
                  ),

                  //bottom bar view, y sus elementos, tipos de vistas y alineaciones

                  expire(screenWidth),
                  // funcion de la barra de estados inferioi
                  navView()
                ],
              );
            } else {
              return _children[_selectedIndex];
            }
          },
        ));
  }

  // nada mas muestra el tiempo que esta transcurriendo
  expire(screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          width: 209,
          height: 120,
          child: Card(
              color: Color(0xFF444444),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Tiempo de expiración',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: widget.contador)
                  ],
                ),
              )),
        ),
      ],
    );
  }

  googlemapa(screenWidth) {
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
            //onCameraMoveStarted: moveCamera(),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(marker),
            initialCameraPosition: CameraPosition(
                target:
                    widget.ubi != null ? widget.ubi : LatLng(28.6353, -106.089),
                zoom: 15),
            //markers: markers,
            onMapCreated: _mapController,
          ),
        ),

        //bottom bar view, y sus elementos, tipos de vistas y alineaciones

        expire(screenWidth),
        // funcion de la barra de estados inferioi
      ],
    );
  }

  //controlador de google maps, aqui se manejan estados del mapa
  _mapController(GoogleMapController controller) {
    setState(() {
      if (mounted) {
        addMarkers();
        _googleMapController = controller;
      }
    });
  }
}
