import 'dart:async';
import 'dart:convert';
import 'package:helpcom/src/pages/busqueda_recepcion.dart';
import 'package:helpcom/src/providers/autogestion_sala_provider.dart';
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
  runApp(Detalle_Pack());
}

class Detalle_Pack extends StatefulWidget {
  @override
  _Detalle_PackState createState() => _Detalle_PackState();
}

class _Detalle_PackState extends State<Detalle_Pack> {
  final FocusNode _nodeText1 = FocusNode();

  @override
  String nombre_producto = '';
  String marca_producto = '';
  String saldo = '';
  String margen = '';
  String oferta = '';
  String precio_oferta = '';
  String cantidad_transito = '';
  String precio_compra = '';

  String cantidad_packvirtual = '';

  String cantidad_boleta = '';
  String cantidad_factura = '';
  String cantidad_nota_credito = '';

//en uso
  int rec_numero;

  int fco_id;

  String valor_total_recepcion;
  String pro_codigo_plu;
  String pro_codigo_barra;

  String pro_codigo_plu_ex;
  String pro_codigo_plu_grabados;
  double pendiente;

  TextEditingController codproController = TextEditingController();
  TextEditingController pendiente_controller = TextEditingController();
  TextEditingController rpm_cantidad = TextEditingController();
  TextEditingController total_valor_producto = TextEditingController();
  TextEditingController packvtController = TextEditingController();
  TextEditingController dohController = TextEditingController();

  bool pVal = false;

  Widget build(BuildContext context) {

    final autogestionProvider = Provider.of<AutogetionSala>(context,
        listen: false);
//DateTime.parse convierte un string en fecha*_*
    DateTime pav_desde_ver = DateTime.parse(autogestionProvider.profechainicio);
    var formatter_pav_desde = new DateFormat('dd-MM-yyyy');
    String format_pav_desde_ver = formatter_pav_desde.format(pav_desde_ver);
    print(format_pav_desde_ver);

    DateTime pav_hasta_ver = DateTime.parse(autogestionProvider.profechafin);
    var formatter_pav_hasta = new DateFormat('dd-MM-yyyy');
    String format_pav_hasta_ver = formatter_pav_hasta.format(pav_hasta_ver);
    print(format_pav_hasta_ver);

    Color color = Theme.of(context).primaryColor;

    return MaterialApp(
      title: 'Detalle Pack Virtual',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Detalle Pack Virtual'),
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
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PACK",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: color,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 240,
                        height: 50,
                        child: Text(
                          autogestionProvider.nombrepacks,
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
                            format_pav_desde_ver,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
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
                            format_pav_hasta_ver,
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
            SizedBox(
              height: 15,
            ),
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
                          "Productos",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 400,
                          height: 30,
                          child: Text(
                            //forma de llamar el dato cargo en el controlador
                            //se utilizar el final declarado (constante)
                            'PRODUCTOS DEL PACK',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 400,
                          height: 100,
                          child: Text(
                            //forma de llamar el dato cargo en el controlador
                            //se utilizar el final declarado (constante)
                            autogestionProvider.nombrepacks.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: color,
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                        Text(
                          //forma de llamar el dato cargo en el controlador
                          //se utilizar el final declarado (constante)
                          'lleve '+autogestionProvider.nombrepacks+'por \$'+ autogestionProvider.propreciofiscal,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
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
                        onPressed: () async {
                          //Navigator.pushNamed(context, '/venta_producto');
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void limpiarCampos() {
    setState(() {
      nombre_producto = '';
      marca_producto = '';
      cantidad_transito = '';
      saldo = '';
      margen = '';
      oferta = '';
      rpm_cantidad.clear();
      codproController.clear();
      precio_compra = '';

      dohController.clear();
      precio_oferta = '';
      cantidad_packvirtual = '';
    });
  }
  Future<bool> busquedaCod(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "busqueda_consulta_producto";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_codigo_plu,
      "pro_codigo_barra": codproController.text
    }).timeout(const Duration(seconds: 7));
    //print(response.body);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          nombre_producto = data['pro_nombre_producto'].toString();
          marca_producto = data["mae_marca"]['mar_nombre'].toString();
          saldo = data['saldo'].toString();
          margen = data['pro_margen_actual'].toString();
          oferta = data['pro_oferta'].toString();
          precio_oferta = data['pro_precio_oferta'].toString();
          precio_compra = data['pro_precio_compra_bruto'].toString();
        });
        return true;
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        limpiarCampos();
        setState(() {
          codproController.clear();
          nombre_producto = "";
          marca_producto = "";
          saldo = "";
          margen = "";
          oferta = "";
          precio_oferta = "";
        });
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future<bool> calculoTrasporte(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "calculo_transito";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_codigo_plu,
      //"pro_codigo_barra": codproController.text
    }).timeout(const Duration(seconds: 7));
    print('transporte' + response.body);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          cantidad_transito = data['cantidad'].toString();
        });
        return true;
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        limpiarCampos();
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future<bool> totalBoleta(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "total_boleta";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_codigo_plu,
      //"pro_codigo_barra": codproController.text
    }).timeout(const Duration(seconds: 7));
    print('boleta' + response.body);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          cantidad_boleta = data[0]['total_bol'].toString();
        });
        return true;
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        limpiarCampos();
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future<bool> totalFactura(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "total_factura";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_codigo_plu,
    }).timeout(const Duration(seconds: 7));
    print('factura' + response.body);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          cantidad_factura = data[0]['total_fac'].toString();
        });
        return true;
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        limpiarCampos();
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future<bool> busqueda_Cap_Sugerido(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "busquedar_cap_sugerido";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_codigo_plu,
    }).timeout(const Duration(seconds: 7));
    print('busqueda_Cap_Sugerido' + response.body);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
//        setState(() {
//          cantidad_factura = data[0]['total_fac'].toString();
//        });
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

  Future insertar_cap_sugerido(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "insertar_cap_sugerido";

    final dateFormatter = DateFormat('yyyy-MM-dd');
    final dateString = dateFormatter.format(DateTime.now());
    var tempDate = DateTime.now();
    var formattedTime =
        "${tempDate.hour}:${tempDate.minute}:${tempDate.second}  ";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "sug_fecha": dateString.toString(),
      "sug_hora": formattedTime.toString(),
      "pro_codigo_plu": codproController.text,
      "usu_nusuario": globals.usuarioLogeado.nombre,
    }).timeout(const Duration(seconds: 7));
    //print("update_orden_compra" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        //pro_codigo_plu = data;
        limpiarCampos();
//        setState(() {
//          codproController.clear();
//          nombrepro = '';
//        });
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
//        setState(() {
//          nombrepro = '';
//          rpm_cantidad.clear();
//        });
        break;
      default:
        break;
    }
  }

  Future<bool> totalNotaCredito(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "total_nota_credito";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_codigo_plu,
      //"pro_codigo_barra": codproController.text
    }).timeout(const Duration(seconds: 7));
    print('nota' + response.body);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          cantidad_nota_credito = data[0]['total_nc'].toString();
        });
        return true;
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        limpiarCampos();
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future<bool> totalPkVirtual(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "total_pack_virtual";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_codigo_plu,
      //"pro_codigo_barra": codproController.text
    }).timeout(const Duration(seconds: 7));
    print('pack virtual' + response.body);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          cantidad_packvirtual = data[0]['cant'].toString();
        });
        return true;
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        limpiarCampos();
        return false;
        break;
      default:
        return false;
        break;
    }
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
          print('acceso correcto');
          permiso = true;
        } else {
          Fluttertoast.showToast(msg: "Acceso denegado");
          print('acceso incorrecto');
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
