import 'dart:async';
import 'dart:convert';
import 'package:helpcom/src/models/recepcion_pendiente.dart';
import 'package:helpcom/src/providers/codigo_producto_provider.dart';
import 'package:helpcom/src/providers/identificacion_documento_provider.dart';
import 'package:helpcom/src/providers/recepcion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecepPendiente(),
    );
  }
}

class RecepPendiente extends StatefulWidget {

  @override

  _RecepPendienteState createState() => _RecepPendienteState();
}
int rec_total;
class _RecepPendienteState extends State<RecepPendiente> {
  List<RecepcionPendiente> _recepciones = List<RecepcionPendiente>();
  List<RecepcionPendiente> _recepcionesMostrar = List<RecepcionPendiente>();

  Future<List<RecepcionPendiente>> obtenerRecepcionesPendientes() async {
    String url = DotEnv().env['SERVER'] + "busquedarecepcionpendiente";
    var response = await http.post(
      url,
      headers: {"Accept": "application/json"},
    ).timeout(const Duration(seconds: 7));
    print("obtenerRecepcionesPendientes"+response.body);
    List<RecepcionPendiente> recepciones = List<RecepcionPendiente>();

    if (response.statusCode == 200) {
      var recepcionesList = json.decode(response.body);
      for (var recepcion in recepcionesList) {
        //print(recepcion);
        _recepciones.add(RecepcionPendiente.fromJson(recepcion));
        // notes.add(noteJson);
      }
    }
    return recepciones;
  }

  @override
  void initState() {
    obtenerRecepcionesPendientes().then((value) {
      setState(() {
        _recepciones.addAll(value);
        _recepcionesMostrar = _recepciones;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Busqueda Recepción'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index - 1);
          },
          itemCount: _recepcionesMostrar.length + 1,
        ));
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(hintText: 'Buscar O.C...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _recepcionesMostrar = _recepciones.where((recepcion) {
              var recepcionOco = recepcion.oco_id.toString();
              return recepcionOco.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Nº Orden de Compra: ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _recepcionesMostrar[index].oco_id.toString(),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Recepción: ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _recepcionesMostrar[index].rec_numero.toString(),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Nº DOC: ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _recepcionesMostrar[index]
                  .com_factura_compras
                  .fco_numero
                  .toString(),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _recepcionesMostrar[index]
                  .com_factura_compras
                  .fco_total
                  .toString(),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          Icons.add_to_photos,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          final identiProvider =
                          Provider.of<IdentiDocProvider>(context, listen: false);
                          final codigoproProvider =
                          Provider.of<CodigoProductoProvider>(context, listen: false);
                          final recepcionProvider =
                          Provider.of<RecepcionProvider>(context, listen: false);
                          Navigator.pushNamed(context, '/ingreso_producto_pendiente');

                          codigoproProvider.rec_numero =
                              _recepcionesMostrar[index].rec_numero.toString();

                          recepcionProvider.ocoid =
                              _recepcionesMostrar[index].oco_id.toString();

                          identiProvider.tipodoc = _recepcionesMostrar[index]
                              .com_factura_compras
                              .fco_tipo
                              .toString();
                          identiProvider.numerodoc = _recepcionesMostrar[index]
                              .com_factura_compras
                              .fco_numero
                              .toString();
                          identiProvider.fco_id = _recepcionesMostrar[index].com_factura_compras.fco_id
                              .toString();
                          identiProvider.patente =
                              _recepcionesMostrar[index].rec_patente.toString();

                          recepcionProvider.prv =
                              _recepcionesMostrar[index].prv_rut.toString();

                          identiProvider.numero_tipo_documento=_recepcionesMostrar[index].com_factura_compras.doc_id.toString();
                          print('sxsxs'+identiProvider.numero_tipo_documento);
                          recepcionProvider.fco_total= _recepcionesMostrar[index].com_factura_compras.fco_total.toString();

                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Retomar",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
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
                          Icons.playlist_add_check,
                        ),
                        iconSize: 30,
                        onPressed: () async{
                          final codigoproProvider =
                          Provider.of<CodigoProductoProvider>(context, listen: false);
                          final insertar_indenti_factura =
                          Provider.of<IdentiDocProvider>(context, listen: false);
                          final recepcionProvider =
                          Provider.of<RecepcionProvider>(context, listen: false);
                          total_recepcion_crp(context);
                          recepcion_Recepcionado(context);

                          if(codigoproProvider.rec_numero == null){
                            Fluttertoast.showToast(
                                msg:
                                "DEBE INGRESAR PRODUCTOS A LA RECEPCION!!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            //verifica_numero_documento(context);
                          }else if(await verifica_numero_documento(context)==true ){
                          Fluttertoast.showToast(
                          msg:
                          "LA FACTURA DE COMPRA  SE INGRESO EN OTRA RECEPCION!!!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 30.0);
                          }else if(int.tryParse(recepcionProvider.fco_total) != rec_total ){
                            print('object'+insertar_indenti_factura.total);
                            print('objectwww $rec_total');
                          cierreshowAlertDialog(context);
                          }
                          else{
                          busca_oco_tipo(context);
                          print("IMPRIMR DOC");
                          Fluttertoast.showToast(
                          msg:
                          "IMPRIMR",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 30.0);
                          }
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Cierre Doc",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
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
                          Icons.pageview,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          final codigoproProvider =
                          Provider.of<CodigoProductoProvider>(context, listen: false);
                          final recepcionProvider =
                          Provider.of<RecepcionProvider>(context, listen: false);

                          Navigator.pushNamed(
                              context, '/listado_producto_grabado');
                          codigoproProvider.rec_numero =
                              _recepcionesMostrar[index].rec_numero.toString();
                          recepcionProvider.ocoid =
                              _recepcionesMostrar[index].oco_id.toString();

                          print("rec"+codigoproProvider.rec_numero);
                          print("ss"+recepcionProvider.ocoid);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Ver",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
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


  cierreshowAlertDialog(BuildContext context) {
    // set up the buttons
    Widget siButton = FlatButton(
      child: Text("Si"),
      onPressed:  () async{
        if(await recepcion_Recepcionado(context)==true){
          bool mCierraRecep = true;
          int que_hacer =2;

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text('PRODUCTOS NO RECEPCIONADOS'),

                  children: <Widget>[
                    SimpleDialogOption(
                      child: const Text('Hay productos que no estan recepcionados, ¿que desea hacer?'),

                    ),

                    SimpleDialogOption(

                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text('PENDIENTE PARA NUEVA RECEPCION'),

                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        actualiza_oco_recepcionado(context);
                      },
                      child: const Text('INGRESAR COMO NO RECEPCIONADOS'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text('VOLVER A RECEPCIONAR'),
                    ),

                  ],
                );
              }
          );


        }

      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Existe Diferencia entre el documento y la recepcion"),
          content: Text("Desea dar de alta la recepcion de todos modos"),
          actions: [
            siButton,
            //noButton,
            FlatButton(
              child: Text("No"),
              onPressed:  () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> recepcion_Recepcionado(BuildContext context) async {
    final insertar_recepcion =
    Provider.of<RecepcionProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "verifica_recepcion_recepcionado";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "oco_id": insertar_recepcion.ocoid,
    }).timeout(const Duration(seconds: 7));
    print("recepcion_Recepcionado" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);

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

  Future<bool> actualiza_oco_recepcionado(BuildContext context) async {
    final insertar_recepcion =
    Provider.of<RecepcionProvider>(context, listen: false);

    String url = DotEnv().env['SERVER'] + "actualiza_oco_recepcionado";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "oco_id": insertar_recepcion.ocoid.toString(),
    }).timeout(const Duration(seconds: 7));
    print("actualiza_oco_recepcionado" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);

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

  Future<bool> total_recepcion_crp(BuildContext context) async {
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "total_recepcion_crp";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": codigoproProvider.rec_numero.toString(),
    }).timeout(const Duration(seconds: 7));
    print("total_recepcion_crp" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        setState(() {
          rec_total = data[0]['rec_total'];
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

  Future<bool> verifica_numero_documento(BuildContext context) async {
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    final identiProvider = Provider.of<IdentiDocProvider>(context, listen: false);
    final _recepcion_provider = Provider.of<RecepcionProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "valida_doc";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "doc_id": identiProvider.numero_tipo_documento.toString(),
      "fco_numero": identiProvider.numerodoc.toString(),
      "rec_numero": codigoproProvider.rec_numero.toString(),
      "prv_rut": _recepcion_provider.prv.toString(),
    }).timeout(const Duration(seconds: 7));
    print("verifica_numero_documento" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
//        rec_numero_ex = data["rec_numero"];
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

  Future<bool> busca_oco_tipo(BuildContext context) async {
    final insertar_recepcion =
    Provider.of<RecepcionProvider>(context, listen: false);

    String url = DotEnv().env['SERVER'] + "busca_oco_tipo";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "oco_id": insertar_recepcion.ocoid.toString(),
    }).timeout(const Duration(seconds: 7));
    print("busca_oco_tipo" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
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
}