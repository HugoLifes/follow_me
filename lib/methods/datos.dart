import 'package:flutter/material.dart';

class DatosView extends StatefulWidget {
  final screenWidth;
  final comp;
  final token;
  final unidad;
  final onlyDate;
  final hora;
  final mins;
  final secs;

  DatosView(
      {this.hora,
      this.unidad,
      this.mins,
      this.secs,
      this.comp,
      this.onlyDate,
      this.token,
      this.screenWidth});

  @override
  _DatosViewState createState() => _DatosViewState();
}

class _DatosViewState extends State<DatosView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // columna principal Transporte y Token
                        Container(
                          //alignment: Alignment.centerRight,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // fila de texto token
                              Container(
                                alignment: Alignment.topRight,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Text(
                                      'Token #',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: 15,
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
                              SizedBox(
                                height: 15,
                              ),

                              //Datos transportista
                              Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerLeft,
                                child: Text('Datos Transportista: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 200,
                                    width: 200,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid),
                                    ),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // por alguna razon lo espacion cuentan
                                          // no borrar espacios
                                          widget.comp != null
                                              ? Container(
                                                  child: Text(
                                                      'Compañia: ${widget.comp}    ',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .lightBlue[900],
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                )
                                              : Text(' '),

                                          //width: 100,
                                          Container(
                                            child: Text('Caja seca Num: 7823',
                                                style: TextStyle(
                                                    color:
                                                        Colors.lightBlue[900],
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),

                                          widget.unidad != null
                                              ? Container(
                                                  child: Text(
                                                    'Unidad: ${widget.unidad}             ',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .lightBlue[900],
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w600),
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
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                width: 500,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Datos del envío',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height / 18,
                                width: 500,
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
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height / 18,
                                width: 500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid)),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: widget.onlyDate != null
                                      ? Text(
                                          'Fecha de llegada: ${widget.onlyDate}',
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600))
                                      : Text('Fecha de llegada: Calculando...',
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600)),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height / 18,
                                width: 500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid)),
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: widget.hora != null &&
                                            widget.mins != null &&
                                            widget.secs != null
                                        ? Text(
                                            'Hora estimada: ${widget.hora}:${widget.mins}:${widget.secs}  Hora Central',
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
          )
        ],
      ),
    );
  }
}
