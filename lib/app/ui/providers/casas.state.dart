import 'package:get/get.dart';
import 'package:movil/app/ui/models/casas.model.dart';

import 'casas.provider.dart';


class CasasState extends GetxController {
  List<CasasModel> casas = [];

  final casaProvider = CasaProvider();
  int index = 0;

  Future<void> getCasas() async {
    casas.addAll(await casaProvider.getCasas());
    index += 20;
    update();
  }
}
