import 'dart:async';
import 'dart:convert';

import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


void main() {
  // debugPaintSizeEnabled = true;
  runApp(Opcione_Recepcion());
}

class Opcione_Recepcion extends StatefulWidget {
  const Opcione_Recepcion({
    Key key,
  }) : super(key: key);

  @override
  _Opcione_RecepcionState createState() => _Opcione_RecepcionState();
}

class _Opcione_RecepcionState extends State<Opcione_Recepcion> {
  final FocusNode _nodeText1 = FocusNode();
  String men_menu;
  String usu_nusuario;
  String rut = '';
  String nombre = '';
  String observacion = '';
  int total;

  TextEditingController ocController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

//Método para aplicar formato de manera
//automática:

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      // padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
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
    );

    Color color = Theme.of(context).primaryColor;


    return MaterialApp(
      title: 'Opciones Recepción',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Opciones Recepción'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              titleSection,

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
                            Icons.add_to_home_screen,
                            color: color,

                          ),
                          iconSize: 50,
                          onPressed: () {
                            Navigator.pushNamed(context, '/busqueda_recepcion');
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Nueva Recepción",
                            style: TextStyle(
                              fontSize: 20,
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
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon(icon, color: color),
                  IconButton(
                    icon: Icon(
                      Icons.update,
                      color: color,
                    ),
                    iconSize: 50,
                    onPressed: () {
                      Navigator.pushNamed(context, '/recep_pendientes');
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Retomar Recepción",
                      style: TextStyle(
                        fontSize: 20,
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
      ),
    );
  }

  Future busquedaOc(String ocoid) async {
    String url = DotEnv().env['SERVER'] + "busqueda_recepcion";
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {"oco_id": ocoid}).timeout(const Duration(seconds: 7));
    switch (response.statusCode) {
      case 200:
        var oc = jsonDecode(response.body);
        setState(() {
          rut = oc['prv_rut'];
          nombre = oc['mae_proveedores']['prv_nombre'];
          observacion = oc['oco_observacion'];
          total = oc['oco_total'];
        });
        break;
      case 201:
        Fluttertoast.showToast(msg: jsonDecode(response.body));
        limpiarCampos();
        setState(() {
          rut = "";
          nombre = "";
          observacion = "";
          ocController.clear();
        });
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        setState(() {
          rut = '';
          nombre = '';
          observacion = '';
          ocController.clear();
        });
        break;
      default:
        break;
    }
  }
}

void limpiarCampos() {}

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
