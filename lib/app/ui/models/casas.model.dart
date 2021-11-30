class CasasModel {
  String? nombreNegocio;
  String? direccion;
  double? latitud;
  double? longitud;
  String? dllV;
  String? dllC;

  CasasModel({
    this.nombreNegocio,
    this.direccion,
    this.latitud,
    this.longitud,
    this.dllC,
    this.dllV,
  });

  factory CasasModel.fromJson(Map<String, dynamic> data) {
    return CasasModel(
      nombreNegocio: data['nombre_negocio'],
      direccion: data['direccion'],
      latitud: data['latitud'],
      longitud: data['longitud'],
      dllV: data['dllV'].toString(),
      dllC: data['dllC'].toString(),
    );
  }
}
