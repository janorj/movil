import 'dart:async';
import 'dart:convert';
import 'package:helpcom/src/providers/recepcion_provider.dart';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

void main() {

  runApp(BusquedaRecepcion());
}

class BusquedaRecepcion extends StatefulWidget {
  const BusquedaRecepcion({
    Key key,
  }) : super(key: key);

  @override
  _BusquedaRecepcionState createState() => _BusquedaRecepcionState();
}

class _BusquedaRecepcionState extends State<BusquedaRecepcion> {
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
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Showing some progress...');

    //Optional
    pr.style(
      message: 'Cargando...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
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
    final recepcion_provider = Provider.of<RecepcionProvider>(context);

    return MaterialApp(
      title: 'Busqueda Recepciòn',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Busqueda Recepciòn'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              titleSection,
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: ocController,
                    keyboardType: TextInputType.number,
                    focusNode: _nodeText1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese orden de compra';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Orden Compra",
                      prefixIcon: Icon(Icons.search),
                      labelText: "Orden Compra",
                      focusColor: Colors.red,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
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
                                Icons.search,
                                color: color,
                                semanticLabel: "Buscar O.C",
                              ),
                              iconSize: 30,
                              onPressed: () {
                                pr.show();

                                Future.delayed(Duration(seconds: 3)).then((onValue) async {
                                  if(pr.isShowing())
                                    busquedaOc(ocController.text);
                                    recepcion_provider.ocoid = ocController.text;
                                  pr.hide();
                                  if (_formKey.currentState.validate()) {
                                    // If the form is valid, display a Snackbar.
                                  }
                                });

                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Buscar O.C",
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
                                Icons.clear_all,
                                color: color,
                                semanticLabel: "Limpiar",
                              ),
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  rut = '';
                                  nombre = '';
                                  observacion = '';
                                  ocController.clear();
                                });
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Limpiar",
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
                  )
                ]),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            //padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              'R.U.T.: ' + rut,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            //padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Nombre: $nombre',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: Text(
                              'Observación:',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 400,
                            height: 100,
                            child: Text(
                              observacion,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            decoration: BoxDecoration(border: Border.all()),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Consumer<RecepcionProvider>(
                                      builder: (_, recepcionInfo, child) =>
                                          IconButton(
                                        icon: Icon(
                                          Icons.playlist_add_check,
                                          color: color,
                                          semanticLabel: "OK",
                                        ),
                                        iconSize: 30,
                                        onPressed: () {
                                          if (rut == "") {
                                            Fluttertoast.showToast(
                                                msg: "Busque orden de compra");
                                          } else {
                                            Navigator.pushNamed(context,
                                                '/identificacion_documento');
                                            recepcion_provider.prv =
                                                rut.toString();
                                            recepcion_provider.total_recepcion =
                                                total.toString();
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        "OK",
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
                      )),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15,
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
    //print("busquedaCod"+response.body);
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