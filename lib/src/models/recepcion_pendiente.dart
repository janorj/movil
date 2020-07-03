
import 'package:helpcom/src/models/com_facturas_compras.dart';

class RecepcionPendiente{

  String rec_numero;
  String oco_id;
  String rec_patente;
  String prv_rut;
  String doc_id;
  String fco_total;
  ComFacturasCompras com_factura_compras;

  RecepcionPendiente.fromJson(Map<String,dynamic> json){
    rec_numero = json["rec_numero"].toString();
    oco_id = json["oco_id"].toString();
    rec_patente = json["rec_patente"].toString();
    prv_rut = json["prv_rut"].toString();
    doc_id = json["doc_id"].toString();
    fco_total = json["fco_total"].toString();
    com_factura_compras = ComFacturasCompras.fromJson(json["com_facturas_compras"]);
  }

}