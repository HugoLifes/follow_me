import 'package:flutter/material.dart';

class NaviewResp extends StatefulWidget {
  final screenWidth;
  final comp;
  final token;
  final unidad;
  final onlyDate;
  final hora;
  final mins;
  final secs;

  NaviewResp(
      {this.hora,
      this.unidad,
      this.mins,
      this.secs,
      this.comp,
      this.onlyDate,
      this.token,
      this.screenWidth});

  @override
  _NaviewResp createState() => _NaviewResp();
}

class _NaviewResp extends State<NaviewResp>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: Duration(milliseconds: 100), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
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
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // columna principal Transporte y Token
                      Container(
                        child: Column(
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
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700),
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
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  width:
                                      MediaQuery.of(context).size.width / 3.1,
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
                                                  color: Colors.lightBlue[900],
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600)),
                                        ),

                                        widget.unidad != null
                                            ? Container(
                                                child: Text(
                                                  'Unidad: ${widget.unidad}             ',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.lightBlue[900],
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
          ),
        ],
      );
}
