
class ComFacturasCompras{

  String fco_numero;
  String fco_tipo;
  String rec_patente;
  String fco_id;
  String doc_id;
  String fco_total;



  ComFacturasCompras.fromJson(Map<String,dynamic> json){

    fco_numero = json["fco_numero"].toString();
    fco_tipo = json["fco_tipo"].toString();
    fco_id = json["fco_id"].toString();
    doc_id = json["doc_id"].toString();
    fco_total = json["fco_total"].toString();

  }


}