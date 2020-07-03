import 'package:flutter/material.dart';

class CodigoProductoProvider with ChangeNotifier {

  String _rec_numero = '';
  String _codpro = '';
  String _cantidaporrecepcionar ;
  List<Producto> _listaproduto = List <Producto>();
  String _nombreproducto='';
  String _cantidad_oc='';
  String _tipo_emb='';
  String _unidad='';
  int _cantidad_rpm_otro_rec;
  String _cantidad_rpm_actual_rec;
  bool _pval;

  get codpro {
    return _codpro;
  }
  set codpro( String codpro ) {
    this._codpro = codpro;
    notifyListeners();
  }

  get cantidaporrecepcionar {
    return _cantidaporrecepcionar;
  }
  set cantidaporrecepcionar( String cantidaporrecepcionar ) {
    this._cantidaporrecepcionar = cantidaporrecepcionar;
    notifyListeners();
  }

 addProducto(Producto producto){

    this._listaproduto.add(producto);
    notifyListeners();
  }

  List<Producto> get listaproduto => _listaproduto;

  get rec_numero {
    return _rec_numero;
  }
  set rec_numero( String rec_numero ) {
    this._rec_numero = rec_numero;
    notifyListeners();
  }

  get nombreproducto {
    return _nombreproducto;
  }
  set nombreproducto( String nombreproducto ) {
    this._nombreproducto = nombreproducto;
    notifyListeners();
  }

  get cantidad_oc  {
    return _cantidad_oc;
  }
  set cantidad_oc ( String cantidad_oc  ) {
    this._cantidad_oc = cantidad_oc ;
    notifyListeners();
  }

  get tipo_emb  {
    return _tipo_emb;
  }
  set tipo_emb ( String tipo_emb  ) {
    this._tipo_emb = tipo_emb ;
    notifyListeners();
  }

  get unidad  {
    return _unidad;
  }
  set unidad ( String unidad  ) {
    this._unidad = unidad ;
    notifyListeners();
  }

  get cantidad_rpm_otro_rec {
    return _cantidad_rpm_otro_rec;
  }
  set cantidad_rpm_otro_rec( int cantidad_rpm_otro_rec ) {
    this._cantidad_rpm_otro_rec = cantidad_rpm_otro_rec;
    notifyListeners();
  }

  get cantidad_rpm_actual_rec {
    return _cantidad_rpm_actual_rec;
  }
  set cantidad_rpm_actual_rec( String cantidad_rpm_actual_rec ) {
    this._cantidad_rpm_actual_rec = cantidad_rpm_actual_rec;
    notifyListeners();
  }

  get pval {
    return _pval;
  }
  set pval( bool pval ) {
    this._pval = pval;
    notifyListeners();
  }
}

class Producto{
  String _codigo;
  String _nombre;

  String get codigo => _codigo;

  set codigo(String value) {
    _codigo = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }


}