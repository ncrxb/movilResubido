


import 'package:dio/dio.dart';
import 'package:movil/app/models_marcadores/marcadores_models.dart';

class MarcadoresCProvider{
  final _url = 'https://api-estadia.herokuapp.com/api/casas';
  final _http = Dio();


  Future<List<MarcadoresCModel>> obtenerMarcadores()async{
    final response = await _http.get(_url);
    List<dynamic> data = response.data[''];
  }
  
}