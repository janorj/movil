import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpcom/src/models/tipo_documento.dart';
import 'package:helpcom/src/providers/inventario_provider.dart';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(Nuevo_Inventario());
}

class Nuevo_Inventario extends StatefulWidget {
  String doc_id;
  String men_menu;
  String usu_nusuario;
  String rut = '';
  String nombre = '';
  String observacion = '';

  @override
  _Nuevo_InventarioState createState() => _Nuevo_InventarioState();
}

class _Nuevo_InventarioState extends State<Nuevo_Inventario> {
  TextEditingController tipodocutController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List tiposDocumento = List();
  List<DropdownMenuItem> _items;

  int tipo;

  TipoDOcumento seleccionado;
  String nombre_doc = '';
  String fecha_documento_ver = '';
  String fecha_documento = '';
  String fecha_ingreso_ver = '';
  String fecha_ingreso = '';

  TextEditingController nueva_toma_controller = TextEditingController();

  @override
  bool onSubmitAction(BuildContext context) {
    bool result = _formKey.currentState.validate();
    //print(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final inventarios_provider = Provider.of<InventarioProvider>(context);

    Color color = Theme.of(context).primaryColor;

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('th', 'TH'), // Thai
      ],
      title: 'Nuevo Invetario',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nuevo Invetario'),
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
                            'Usuario: ' + globals.usuarioLogeado.nombre,
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
                          "Plantilla",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Consumer<InventarioProvider>(
                          builder: (_, recepcionInfo, child) => Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 200,
                            height: 30,
                            child: Text(
                              inventarios_provider.pla_id,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: color,
                              ),
                            ),
                            decoration: BoxDecoration(border: Border.all()),
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
                          "Nombre",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Consumer<InventarioProvider>(
                          builder: (_, recepcionInfo, child) => Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 200,
                            height: 30,
                            child: Text(
                              inventarios_provider.nombre_planilla,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: color,
                              ),
                            ),
                            decoration: BoxDecoration(border: Border.all()),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
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
                          "Nueva toma inventario",
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
                          child: TextField(
                            controller: nueva_toma_controller,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: Colors.grey,
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
                      IconButton(
                        icon: Icon(
                          Icons.save,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          await Verifica_toma_nueva_inventario(context);

                          if (nueva_toma_controller.text == '') {
                            Fluttertoast.showToast(
                                msg:
                                    "NO SE PUEDE INGRESAR UNA TOMA DE INVENTARIO CON EL NOMBRE VACIO!!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else if (await Verifica_toma_nueva_inventario(
                                  context) ==
                              true) {
                            Fluttertoast.showToast(
                                msg: "La toma de de inventario ya existe",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else {
                            insertar_tomainventario(context);
                            Fluttertoast.showToast(
                                msg: "Toma de inventario correcta",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            limpiarCampos();
                          }
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Grabar",
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
                          Icons.arrow_back,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushNamed(context, '/identidocu');
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
      nueva_toma_controller.clear();
    });
  }

  Future<bool> Verifica_toma_nueva_inventario(BuildContext context) async {
    String url = DotEnv().env['SERVER'] + "verifica_toma_inventario";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "tin_observacion": nueva_toma_controller.text,
    }).timeout(const Duration(seconds: 7));
    print("existencia_Plu" + response.body);
    switch (response.statusCode) {
      case 200:
        return true;
        break;
      case 500:
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  //inserta nueva toma de inventario
  Future insertar_tomainventario(BuildContext context) async {
    final ingresar_nueva_toma =
        Provider.of<InventarioProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "insertar_toma_inventario";

    var tempDate = new DateTime.now();
    String formattedDate =
        "${tempDate.year.toString()}-${tempDate.month.toString().padLeft(2, '0')}-${tempDate.day.toString().padLeft(2, '0')}";
    print(formattedDate);
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      //"tin_fecha": formattedDate.toString(),
      "tin_sala_bodega": '0',
      "tin_observacion": nueva_toma_controller.text,
      "usu_nusuario": globals.usuarioLogeado.nombre,
      "pla_id": ingresar_nueva_toma.pla_id,
    }).timeout(const Duration(seconds: 7));

    print("insertar_tomainventario" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        break;
      default:
        break;
    }
  }
}
