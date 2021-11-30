import 'package:dio/dio.dart';
import 'package:movil/app/ui/models/casas.model.dart';

class CasaProvider {
  final String _api = 'https://api-estadia.herokuapp.com/api/casas';
  final _http = Dio();

  Future <List<CasasModel>> getCasas() async {
    final _response = await _http.get(_api);
    List<dynamic> _data = _response.data;

    return _data.map((_data) => CasasModel.fromJson(_data)).toList();
  }
}
