import 'dart:convert';
import 'package:helpcom/src/models/usuario_model.dart';
import 'package:helpcom/src/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usuario_controller = TextEditingController();
  TextEditingController pass_controller = TextEditingController();
  bool autenticando = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar('Login Usuario'),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      new Image.asset(
                        'assets/images/logo.png',
                        width: 200.0,
                        height: 200.0,
                      ),
                      Text(
                        'SISTEMA CRUX MOVIL',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: usuario_controller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'ingresar nombre de usuario';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Usuario",
                          prefixIcon: Icon(Icons.supervised_user_circle),
                          labelText: "Usuario",
                          focusColor: Colors.red,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: pass_controller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'ingresar contraseña';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          prefixIcon: Icon(Icons.vpn_key),
                          labelText: "Contraseña",
                          focusColor: Colors.red,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      (autenticando == true)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          :
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    // If the form is valid, display a Snackbar.
                                    iniciarSesion(usuario_controller.text,
                                        pass_controller.text);
                                  }
                                },
                                child: Text('Ingresar'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(width: 2)),
                                color: Colors.lightBlue,
                                textColor: Colors.black,
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Version 1.0',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> iniciarSesion(String usuario, String password) async {
    try {
      autentica(true);
      var url = DotEnv().env['SERVER'] + "login";
      var response = await http.post(url, headers: {
        "Accept": "application/json"
      }, body: {
        "usu_nusuario": usuario,
        'usu_password': password
      }).timeout(const Duration(seconds: 7));
      //print(response.body);
      switch (response.statusCode) {
        case 200:
          var json_usuario = jsonDecode(response.body);
          UsuarioModel usuarioModel = UsuarioModel();
          usuarioModel.id = json_usuario["id"];
          usuarioModel.nombre = json_usuario["usu_nusuario"];
          globals.usuarioLogeado = usuarioModel;
          Navigator.pushNamed(context, '/menu');
          autentica(false);
          break;
        case 500:
          Fluttertoast.showToast(msg: response.body);
          autentica(false);
          break;
        default:
          Fluttertoast.showToast(msg: "Error");
          autentica(false);
          break;
      }
    } on TimeoutException catch (e) {
      autentica(false);
      Fluttertoast.showToast(
          msg: "Error de conexíon, reintente en unos minutos",
          toastLength: Toast.LENGTH_LONG);
    } catch (x) {
      autentica(false);
      Fluttertoast.showToast(
          msg: "Error" + x.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }

//Funcion para cambiar el estado actual de la autenticacion
  void autentica(bool estado) {
    setState(() {
      autenticando = estado;
    });
  }
}
