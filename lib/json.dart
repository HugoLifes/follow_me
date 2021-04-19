class Post {
  String idUnidad;
  String latitud;
  String longitud;
  String fecha;
  String compania;

  Post({this.latitud, this.longitud, this.idUnidad, this.fecha, this.compania});

  factory Post.formJson(Map<String, dynamic> parsedJson) {
    return Post(
      idUnidad: parsedJson['ID_UNIDAD'],
      latitud: parsedJson['LATITUD'],
      longitud: parsedJson['LONGITUD'],
      fecha: parsedJson['FECHA'],
      compania: parsedJson['COMPANIA'],
    );
  }
}
