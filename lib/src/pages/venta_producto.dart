import 'dart:async';
import 'dart:convert';

import 'package:helpcom/src/providers/autogestion_sala_provider.dart';
import 'package:helpcom/src/providers/codigo_producto_provider.dart';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(Venta_Producto());
}

class Venta_Producto extends StatefulWidget {
  @override
  _Venta_ProductoState createState() => _Venta_ProductoState();
}

class _Venta_ProductoState extends State<Venta_Producto> {
  final FocusNode _nodeText1 = FocusNode();

  @override
  //ParametrosPromedioVenta args;
  String BOL = '';
  String FAC = '';
  String NCR= '';
  String semana1="";
  String semana2="";
  String semana3="";
  String semana4="";
  String peak='';
  String cantidad_vendida='';
  String fecha_peak ='';

  String pav_id='';
  String pav_desde='';
  String pav_hasta ='';
  String pav_nombre ='';


  initState(){
  info_venta_pack_virtual(context);
  informacion_packvirtual(context);
  estadistica_Boleta(context);
  detalle_Packvirtual(context);
  }
  Widget build(BuildContext context) {

    double x =double.tryParse(cantidad_vendida) ?? 1;
    double xy = (x / 90);
    //print("dd $xy");
//    DateTime fecha_peak_ver = DateTime.parse(fecha_peak);
//    String format_fecha_peak_ver ="${fecha_peak_ver.day.toString().padLeft(2,'0')}-${fecha_peak_ver.month.toString().padLeft(2,'0')}-${fecha_peak_ver.year.toString()}";
//    print(format_fecha_peak_ver);

//    DateTime fecha_peak_ver = DateTime.parse(fecha_peak);
//    var formatter = new DateFormat('dd-MM-yyyy');
//    String format_fecha_peak_ver = formatter.format(fecha_peak_ver);
//    print(format_fecha_peak_ver);
//
//    DateTime pav_desde_ver = DateTime.parse(pav_desde);
//    var formatter_pav_desde = new DateFormat('dd-MM-yyyy');
//    String format_pav_desde_ver = formatter_pav_desde.format(pav_desde_ver);
//    print(format_pav_desde_ver);
//
//    DateTime pav_hasta_ver = DateTime.parse(pav_hasta);
//    var formatter_pav_hasta = new DateFormat('dd-MM-yyyy');
//    String format_pav_hasta_ver = formatter_pav_hasta.format(pav_hasta_ver);
//    print(format_pav_hasta_ver);


    final autogestionProvider = Provider.of<AutogetionSala>(context,
        listen: false);
    Color color = Theme.of(context).primaryColor;

    return MaterialApp(
      title: 'Venta Producto',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Venta Producto'),
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Expanded(
                    /*1*/
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Usuario:' + globals.usuarioLogeado.nombre,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Text(
                          'Sucursal:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Image.asset(
                    'assets/images/logo.png',
                    width: 80.0,
                    height: 80.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Semana 1",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            semana1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Semana 2",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            semana2,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Semana 3",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            semana3,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Semana 4",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            semana4,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child:
                    Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "U.N. venta prom. dia",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: color,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 200,
                        height: 30,
                        child: Text(
                          xy.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        decoration: BoxDecoration(border: Border.all()),
                      ),
                    ],
                  ),
            ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Venta Peak",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            peak,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Fecha",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            fecha_peak,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "PACK VIRTUAL",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(child: listaPacks(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Precio",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            autogestionProvider.propreciofiscal,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "PK Virtual",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: (double.tryParse(autogestionProvider.cantidadpackvirtual) != null)
                      ? Text(
                    'SI',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: color,
                    ),
                  )
                      : Text(
                    '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: color,
                    ),
                  ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cantidad",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child:
                          Text(
                            autogestionProvider.cantidadpackvirtual,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pack",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Desde",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            pav_desde,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hasta",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            pav_hasta,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Icon(icon, color: color),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: ()  async {

                          Navigator.of(context).pop();
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Volver",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Icon(icon, color: color),
                      IconButton(
                        icon: Icon(
                          Icons.youtube_searched_for,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushNamed(context, '/consulta_producto');
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Escanear",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future info_venta_pack_virtual(BuildContext context) async {
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "informacion_venta_pack_virtual";
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');

    //SEMANA1
    var fecha_menos = now.subtract(new Duration(days: 28));
    String fecha_menos_semana_uno = formatter.format(fecha_menos);
    DateTime dateTime_ymd_semana_uno = formatter.parse(fecha_menos_semana_uno);
    var formato_fecha_mas = dateTime_ymd_semana_uno.add(new Duration(days: 6));
    String fecha_menos_semana_uno_dos = formatter.format(formato_fecha_mas);
    //SEMANA2
    DateTime dateTime_ymd_semana_dos = formatter.parse(fecha_menos_semana_uno_dos);
    var formato_fecha_mas_dos_uno = dateTime_ymd_semana_dos.add(new Duration(days: 1));
    String fecha_menos_semana_dos_uno= formatter.format(formato_fecha_mas_dos_uno);
    DateTime dateTime_ymd_semana_dos_uno = formatter.parse(fecha_menos_semana_dos_uno);
    var formato_fecha_mas_dos_dos = dateTime_ymd_semana_dos_uno.add(new Duration(days: 6));
    String fecha_menos_semana_dos_dos= formatter.format(formato_fecha_mas_dos_dos);
    //SEMANA3
    DateTime dateTime_ymd_semana_tres = formatter.parse(fecha_menos_semana_dos_dos);
    var formato_fecha_mas_tres_uno = dateTime_ymd_semana_tres.add(new Duration(days: 1));
    String fecha_menos_semana_tres_uno= formatter.format(formato_fecha_mas_tres_uno);
    DateTime dateTime_ymd_semana_tres_uno = formatter.parse(fecha_menos_semana_tres_uno);
    var formato_fecha_mas_tres_dos = dateTime_ymd_semana_tres_uno.add(new Duration(days: 6));
    String fecha_menos_semana_tres_dos= formatter.format(formato_fecha_mas_tres_dos);
    //SEMANA4
    DateTime dateTime_ymd_semana_cuatro = formatter.parse(fecha_menos_semana_tres_dos);
    var formato_fecha_mas_cuatro_uno = dateTime_ymd_semana_cuatro.add(new Duration(days: 1));
    String fecha_menos_semana_cuatro_uno= formatter.format(formato_fecha_mas_cuatro_uno);
    DateTime dateTime_ymd_semana_cuatro_uno = formatter.parse(fecha_menos_semana_cuatro_uno);
    var formato_fecha_mas_cuatro_dos = dateTime_ymd_semana_cuatro_uno.add(new Duration(days: 6));
    String fecha_menos_semana_cuatro_dos= formatter.format(formato_fecha_mas_cuatro_dos);

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      //envia datos a la consulta eloquent
      "pro_codigo_plu": codigoproProvider.codpro,
      "fecha_menos_semana_uno": fecha_menos_semana_uno,
      "fecha_menos_semana_uno_dos": fecha_menos_semana_uno_dos,
      "fecha_menos_semana_dos_uno": fecha_menos_semana_dos_uno,
      "fecha_menos_semana_dos_dos": fecha_menos_semana_dos_dos,
      "fecha_menos_semana_tres_uno": fecha_menos_semana_tres_uno,
      "fecha_menos_semana_tres_dos": fecha_menos_semana_tres_dos,
      "fecha_menos_semana_cuatro_uno": fecha_menos_semana_cuatro_uno,
      "fecha_menos_semana_cuatro_dos": fecha_menos_semana_cuatro_dos,

    }).timeout(const Duration(seconds: 7));
    print(response.body);
    switch (response.statusCode) {
      //resive datos de la consulta eloquent
      case 200:
        var response1 = jsonDecode(response.body);
    setState(() {
      semana1 = response1[0].toStringAsFixed(2);
      semana2 = response1[1].toStringAsFixed(2);
      semana3 = response1[2].toStringAsFixed(2);
      semana4 = response1[3].toStringAsFixed(2);
    });
        return true;
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future<bool> informacion_packvirtual(BuildContext context) async {
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "informacion_por_pack_virtual";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": codigoproProvider.codpro,
    }).timeout(const Duration(seconds: 7));
    print('informacion_packvirtual'+response.body);
    switch (response.statusCode) {
      case 200:
      //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          pav_id = data[0]['pav_id'].toString();
          pav_desde = data[0]['pav_desde'].toString();
          pav_hasta = data[0]['pav_hasta'].toString();
          pav_nombre = data[0]['pav_nombre'].toString();
        });
        return true;
        break;
      case 500:
      //Fluttertoast.showToast(msg: response.body.toString());
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future<bool> estadistica_Boleta(BuildContext context) async {
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "estadistica_boleta";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": codigoproProvider.codpro,
    }).timeout(const Duration(seconds: 7));
    print('estadistica_Boleta'+response.body);
    switch (response.statusCode) {
      case 200:
      //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);

        setState(() {
          //cantidad_factura = data[0]['total_fac'].toString();
          peak = data[0]['peak'].toString();
          cantidad_vendida = data[0]['cantidad_vendida'].toString();
          fecha_peak = data[0]['fecha_peak'].toString();
        });
        return true;
        break;
      case 500:
      //Fluttertoast.showToast(msg: response.body.toString());
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future detalle_Packvirtual(BuildContext context) async {
    final autogestionProvider = Provider.of<AutogetionSala>(context,
        listen: false);
    var url = DotEnv().env['SERVER'] + "detalle_packvirtual";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pav_id": autogestionProvider.pavid.toString(),
    }).timeout(const Duration(seconds: 7));
    print(response.body);
    switch (response.statusCode) {
      case 200:
        List productos_pack = jsonDecode(response.body);
        //nombrepacks = productos_pack[0]['pro_nombre_producto'].toString();

        return productos_pack;
        break;
      case 500:
        Fluttertoast.showToast(msg: jsonDecode(response.body));
        throw Exception("No existen Pack virtuales");
        break;
      default:
        throw Exception("Error al cargar packs");
        break;
    }
  }
  FutureBuilder listaPacks(BuildContext context) {
    final autogestionProvider = Provider.of<AutogetionSala>(context,
        listen: false);
    return FutureBuilder(
      future: detalle_Packvirtual(context),
      builder: (_, snapshot) {
        if (ConnectionState.waiting == snapshot.connectionState) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("No existen productos grabados");
        } else {
          List data = snapshot.data;
          return Container(
            child: ListView.builder(
                itemCount: data.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (_, i) {
                  return InkWell(
                    onTap: (){
                      Navigator.pushNamed(
                          context, '/detalle_pack_virtual');
                      autogestionProvider.nombrepacks = data[i]["pro_nombre_producto"].toString();
                      autogestionProvider.profechainicio = pav_desde.toString();
                      autogestionProvider.profechafin = pav_hasta.toString();
                      autogestionProvider.propreciofiscal;
                    },

                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Nombre Pack Virtual: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data[i]["pro_nombre_producto"].toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}

Future<bool> comprobarAcceso(String men_menu, String usu_nusuario) async {
  bool permiso = false;
  try {
    var url = DotEnv().env['SERVER'] + "acceso";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "men_menu": men_menu.toString(),
      'usu_nusuario': usu_nusuario.toString()
    }).timeout(const Duration(seconds: 7));
    switch (response.statusCode) {
      case 200:
        List data = jsonDecode(response.body);
        if (data.length == 1) {
          //print('acceso correcto');
          permiso = true;
        } else {
          Fluttertoast.showToast(msg: "Acceso denegado");
          //print('acceso incorrecto');
          permiso = false;
        }
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body);
        permiso = false;
        break;
      default:
        Fluttertoast.showToast(msg: "Error");
        permiso = false;
        break;
    }
  } on TimeoutException catch (e) {
    Fluttertoast.showToast(
        msg: "Error de conexíon, reintente en unos minutos",
        toastLength: Toast.LENGTH_LONG);
  } catch (x) {
    Fluttertoast.showToast(
        msg: "Error" + x.toString(), toastLength: Toast.LENGTH_LONG);
  }
  return permiso;
}