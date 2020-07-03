import 'dart:async';
import 'dart:convert';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

void main() {
  // debugPaintSizeEnabled = true;
  runApp(InicioPage());
}

class InicioPage extends StatefulWidget {
  const InicioPage({
    Key key,
  }) : super(key: key);

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final FocusNode _nodeText1 = FocusNode();
  String men_menu;
  String usu_nusuario;
  final _formKey = GlobalKey<FormState>();

  double percentage = 0.0;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Showing some progress...');

    //Optional
    pr.style(
      message: 'Espere...',
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

    Color color = Theme.of(context).primaryColor;
    return MaterialApp(
      title: 'Opciones',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Opciones'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Container(
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
                              Icons.add_to_home_screen,
                              color: color,
                            ),
                            iconSize: 50,
                          onPressed: ()  {
                            pr.show();
                            Future.delayed(Duration(seconds: 2)).then((onValue) async {
                              if(pr.isShowing())
                              if (await comprobarAcceso("M01", globals.usuarioLogeado.nombre)) {
                              Navigator.pushNamed(context, '/opciones_recepcion');
                              }
                              pr.hide();
                            }
                            );
                          },
                            ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Recepción",
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
                      Icons.border_color,
                      color: color,
                    ),
                    iconSize: 50,
                    onPressed: () async {
                      pr.show();
                      Future.delayed(Duration(seconds: 2)).then((onValue) async {
                        if(pr.isShowing())
                          if (await comprobarAcceso("M02", globals.usuarioLogeado.nombre)) {
                            Navigator.pushNamed(context, '/consulta_producto');
                          }
                        pr.hide();
                      });
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Auto gestion sala",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
//              Column(
//                mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: [
//                  //Icon(icon, color: color),
//                  IconButton(
//                    icon: Icon(
//                      Icons.print,
//                      color: color,
//                    ),
//                    iconSize: 50,
//                    onPressed: () {},
//                  ),
//                  Container(
//                    margin: const EdgeInsets.only(top: 8),
//                    child: Text(
//                      "Informes Gerenciales",
//                      style: TextStyle(
//                        fontSize: 20,
//                        fontWeight: FontWeight.w400,
//                        color: color,
//                      ),
//                    ),
//                  ),
//                ],
//              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon(icon, color: color),
                  IconButton(
                    icon: Icon(
                      Icons.business,
                      color: color,
                    ),
                    iconSize: 50,
                    onPressed: () {
                      pr.show();
                      Future.delayed(Duration(seconds: 2)).then((onValue) async {
                        if(pr.isShowing())
                          if (await comprobarAcceso("M04", globals.usuarioLogeado.nombre)) {
                            Navigator.pushNamed(context, '/inventario');
                          }
                        pr.hide();
                      });
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Inventario",
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
    print(men_menu);
    print(usu_nusuario);
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
