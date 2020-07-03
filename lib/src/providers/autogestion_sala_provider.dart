import 'package:flutter/material.dart';

class AutogetionSala with ChangeNotifier {
  String _pavid = '';
  String _profechainicio= '';
  String _profechafin= '';
  String _propreciofiscal= '';
  String _cantidadpackvirtual= '';
  String _nombrepacks='';

  List<Pack> _listapack = List <Pack>();

  get pavid {
    return _pavid;
  }
  set pavid( String pavid ) {
    this._pavid = pavid;
    notifyListeners();
  }

  get profechainicio {
    return _profechainicio;
  }
  set profechainicio( String profechainicio ) {
    this._profechainicio = profechainicio;
    notifyListeners();
  }

  get profechafin {
    return _profechafin;
  }
  set profechafin( String profechafin ) {
    this._profechafin = profechafin;
    notifyListeners();
  }

  get propreciofiscal {
    return _propreciofiscal;
  }
  set propreciofiscal( String propreciofiscal ) {
    this._propreciofiscal = propreciofiscal;
    notifyListeners();
  }

  get cantidadpackvirtual {
    return _cantidadpackvirtual;
  }
  set cantidadpackvirtual( String cantidadpackvirtual ) {
    this._cantidadpackvirtual = cantidadpackvirtual;
    notifyListeners();
  }

  get nombrepacks {
    return _nombrepacks;
  }
  set nombrepacks( String nombrepacks ) {
    this._nombrepacks = nombrepacks;
    notifyListeners();
  }

  addPack(Pack pack){

    this._listapack.add(pack);
    notifyListeners();
  }

  List<Pack> get listapack => _listapack;
}

class Pack{

  String _nombrepack;

  String get nombrepack => _nombrepack;

  set nombrepack(String value) {
    _nombrepack = value;
  }


}