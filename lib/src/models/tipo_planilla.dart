import 'package:helpcom/src/pages/lista_producto_plantilla.dart';

class TipoPlanilla{

  int _pla_id;
  String _pla_observacion;


  int get pla_observacionpla_id => _pla_id;

  set pla_id(int value) {
    _pla_id = value;
  }

  String get pla_observacion => _pla_observacion;

  set pla_observacion(String value) {
    _pla_observacion = value;
  }

int get pla_id =>  _pla_id;


}
