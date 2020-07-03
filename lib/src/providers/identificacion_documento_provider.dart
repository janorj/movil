import 'package:flutter/material.dart';

class IdentiDocProvider with ChangeNotifier {


  String _tipodoc = '';
  String _numerodoc = '';
  String _numero_tipo_documento='';
  String _total= '';
  String _fechaingreso= '';
  String _fechadoc= '';
  String _nombreconductor = '';
  String _rutconductor = '';
  String _patente = '';
  String _fco_id = '';

  String get numero_tipo_documento => _numero_tipo_documento;

  set numero_tipo_documento(String value) {
    _numero_tipo_documento = value;
  }


  get tipodoc {
    return _tipodoc;
  }
  set tipodoc( String tipodoc ) {
    this._tipodoc = tipodoc;
    notifyListeners();
  }

  //getter setter  numerodoc
  get numerodoc {
    return _numerodoc;
  }
  set numerodoc( String numerodoc ) {
    this._numerodoc = numerodoc;
    notifyListeners();
  }

  //getter setter  numerodoc
  get fco_id {
    return _fco_id;
  }
  set fco_id( String fco_id ) {
    this._fco_id = fco_id;
    notifyListeners();
  }

  //getter setter  total
  get total {
    return _total;
  }
  set total( String total ) {
    this._total = total;
    notifyListeners();
  }

  //getter setter  fechaingreso
  get fechaingreso {
    return _fechaingreso;
  }
  set fechaingreso( String fechaingreso ) {
    this._fechaingreso = fechaingreso;
    notifyListeners();
  }

  //getter setter  fechadoc
  get fechadoc {
    return _fechadoc;
  }
  set fechadoc( String fechadoc ) {
    this._fechadoc = fechadoc;
    notifyListeners();
  }

  //getter setter  nombreconductor
  get nombreconductor {
    return _nombreconductor;
  }
  set nombreconductor( String nombreconductor ) {
    this._nombreconductor = nombreconductor;
    notifyListeners();
  }

  //getter setter  rutconductor
  get rutconductor {
    return _rutconductor;
  }
  set rutconductor( String rutconductor ) {
    this._rutconductor = rutconductor;
    notifyListeners();
  }

  //getter setter  patente
  get patente {
    return _patente;
  }
  set patente( String patente ) {
    this._patente = patente;
    notifyListeners();
  }



}