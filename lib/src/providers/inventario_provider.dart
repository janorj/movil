import 'package:flutter/material.dart';

class InventarioProvider with ChangeNotifier {
  String _tin_id;
  String _pla_id;
  String _nombre_planilla = '';

  String get pla_id => _pla_id;

  set pla_id(String value) {
    _pla_id = value;
  }


  get nombre_planilla {
    return _nombre_planilla;
  }
  set nombre_planilla( String nombre_planilla ) {
    this._nombre_planilla = nombre_planilla;
    notifyListeners();
  }

  get tin_id {
    return _tin_id;
  }
  set tin_id( String tin_id ) {
    this._tin_id = tin_id;
    notifyListeners();
  }
}