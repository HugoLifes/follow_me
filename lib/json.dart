// trabaja con la informacion del json recibido
class Post {
  String idUnidad;
  String latitud;
  String longitud;
  String fecha;
  String compania;
  String temperatura;
  String velocidad;
  // se inicia
  Post(
      {this.temperatura,
      this.latitud,
      this.velocidad,
      this.longitud,
      this.idUnidad,
      this.fecha,
      this.compania});
  //recrea la informacion del json a nuestras variables declarada
  factory Post.formJson(Map<String, dynamic> parsedJson) {
    return Post(
        //relacionamos ese valor a la caracteristicas que segun vaya teniendo el json
        idUnidad: parsedJson['ID_UNIDAD'],
        latitud: parsedJson['LATITUD'],
        longitud: parsedJson['LONGITUD'],
        fecha: parsedJson['FECHA'],
        compania: parsedJson['COMPANIA'],
        temperatura: parsedJson['TEMPERATURA'],
        velocidad: parsedJson['VELOCIDAD']);
  }
}
