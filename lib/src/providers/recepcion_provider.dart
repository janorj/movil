import 'package:flutter/material.dart';

class RecepcionProvider with ChangeNotifier {
  String _ocoid = '';
  String _prv='';
  String _total_recepcion='';
  String _fco_total='';

  String get fco_total => _fco_total;

  set fco_total(String value) {
    _fco_total = value;
  }


  get ocoid {
    return _ocoid;
  }
  set ocoid( String ocoid ) {
    this._ocoid = ocoid;
    notifyListeners();
  }

  get prv {
    return _prv;
  }
  set prv( String prv ) {
    this._prv = prv;
    notifyListeners();
  }
  get total_recepcion {
    return _total_recepcion;
  }
  set total_recepcion( String total_recepcion ) {
    this._total_recepcion = total_recepcion;
    notifyListeners();
  }

}

