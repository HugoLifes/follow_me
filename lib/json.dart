// trabaja con la informacion del json recibido
class Post {
  String idUnidad;
  String latitud;
  String longitud;
  String fecha;
  String compania;
  String temperatura;
  String velocidad;
  int value;
  // se inicia
  Post(
      {this.temperatura,
      this.latitud,
      this.velocidad,
      this.longitud,
      this.idUnidad,
      this.value,
      this.fecha,
      this.compania});
  //recrea la informacion del json a nuestras variables declarada
  factory Post.formJson(Map<String, dynamic> parsedJson) {
    return Post(
      //relacionamos ese valor a la caracteristicas que segun vaya teniendo el json
      idUnidad: parsedJson['data']['ID_UNIDAD'],
      latitud: parsedJson['data']['LATITUD'],
      longitud: parsedJson['data']['LONGITUD'],
      fecha: parsedJson['fechaFinal'],
      compania: parsedJson['data']['COMPANIA'],
      temperatura: parsedJson['data']['TEMPERATURA'],
      velocidad: parsedJson['data']['VELOCIDAD'],
      value: parsedJson['value'],
    );
  }
}

class Send {
  int value;
  String msn;
  String idU;

  Send({this.value, this.msn, this.idU});

  factory Send.fromJson(Map<String, dynamic> json) {
    return Send(
      value: json['value'],
      msn: json['message'],
      idU: json['unitId'],
    );
  }
}
