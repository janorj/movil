import 'dart:convert';
import 'dart:ui';
import 'package:helpcom/src/models/tipo_documento.dart';
import 'package:helpcom/src/providers/identificacion_documento_provider.dart';
import 'package:helpcom/src/providers/recepcion_provider.dart';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:dart_rut_validator/dart_rut_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(IdentiDocu());
}

class IdentiDocu extends StatefulWidget {
  String doc_id;
  String men_menu;
  String usu_nusuario;
  String rut = '';
  String nombre = '';
  String observacion = '';

  @override
  _IdentiDocuState createState() => _IdentiDocuState();
}

class _IdentiDocuState extends State<IdentiDocu> {
  TextEditingController tipodocutController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List tiposDocumento = List();
  List<DropdownMenuItem> _items;

  int tipo;

  TipoDOcumento seleccionado;
  String nombre_doc = '';
  String fecha_documento_ver='';
  String fecha_documento='';
  String fecha_ingreso_ver='';
  String fecha_ingreso='';

  TextEditingController _rutController = TextEditingController();

  @override
  void initState() {
    selectDocumento();
    _rutController.clear();

    super.initState();
  }

  void onChangedApplyFormat(String text) {
    RUTValidator.formatFromTextController(_rutController);
  }

  bool onSubmitAction(BuildContext context) {
    bool result = _formKey.currentState.validate();
    //print(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final recepcion_provider = Provider.of<RecepcionProvider>(context);
    final identi_doc_provider = Provider.of<IdentiDocProvider>(context);

    //print("ssqq "+identi_doc_provider.fechaingreso);

    //controller sirve para obtener el dato de cada campo requerido
    TextEditingController numdocController = TextEditingController();
    TextEditingController totalController = TextEditingController();
    TextEditingController nomconductorController = TextEditingController();
    TextEditingController patenteController = TextEditingController();

    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    var formatter_dos = new DateFormat('yyyy-MM-dd');
    String fecha_now= formatter.format(now);
    String fecha_now_dos= formatter_dos.format(now);
    print(fecha_now);
    //print(fecha_now_dos);

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
      title: 'Identificacion Documento',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Identificacion Documento'),
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
                        Consumer<RecepcionProvider>(
                          builder: (_, recepcionInfo, child) => Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 200,
                            height: 30,
                            child: Text(
                              'PRV:' + recepcion_provider.prv,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "O.C",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: color,
                        ),
                      ),
                      Consumer<RecepcionProvider>(
                        builder: (_, recepcionInfo, child) => Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            recepcionInfo.ocoid,
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
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Icon(icon, color: color),
                        Text(
                          "REC",
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
                            "Automatico",
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
            Container(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text("Tipo Documento"),
                    DropdownButton(
                      value: seleccionado,
                      hint: Text("Selecione documento"),
                      items: _items,
                      onChanged: (value) {
                        //print(tipo);
                        setState(() {
                          seleccionado = value;
                          print(seleccionado.doc_descripcion);
                        });
                      },
                    )
                  ],
                ),
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
                      RaisedButton(
                        child: Text("Fecha Ingreso"),
                        onPressed: () async {
                        },

                      ),
                      Container(
                        //margin: const EdgeInsets.only(top: 8),
                        child: Text(
                            fecha_now,
                            //fecha_now
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Icon(icon, color: color),
                      RaisedButton(
                        child: Text("Fecha Documento"),
                        onPressed: () async {
                          DateTime newDateTime = await showRoundedDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 1),
                            lastDate: DateTime(DateTime.now().year + 1),
                            borderRadius: 16,
                          );
                          setState(() {
                            var formatter_ver = new DateFormat('dd-MM-yyyy');
                            var formatter = new DateFormat('yyyy-MM-dd');
                            String fecha_now_ver_doc= formatter_ver.format(newDateTime);
                            String fecha_now_doc= formatter.format(newDateTime);
                            print(fecha_now_doc);
                            fecha_documento_ver = fecha_now_ver_doc.toString();
                            fecha_documento = fecha_now_doc.toString();
                          });
                        },
                      ),
                      Container(
                        //margin: const EdgeInsets.only(top: 8),
                        child: Text(
                           '$fecha_documento_ver'
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
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
                        "Nº Documento",
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
                        child: TextField(
                          controller: numdocController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
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
                        //Icon(icon, color: color),
                        Text(
                          "Total",
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
                          child: TextField(
                            controller: totalController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
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
              height: 25,
            ),
            Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Text(
                  "RUN",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: color,
                  ),
                ),
                TextFormField(
                  controller: _rutController,
                  onChanged: onChangedApplyFormat,
                  validator:
                      RUTValidator(validationErrorText: "ingrese rut valido")
                          .validator,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Ingrese RUN transportista',
                    hintStyle: TextStyle(
                        letterSpacing: 0.6,
                        fontFeatures: [FontFeature.tabularFigures()]),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 25,
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
                        "Patente",
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
                        child: TextField(
                          //aqui se obtiene el dato requerido
                          controller: patenteController,
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
                          "Nombre Conductor",
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
                            controller: nomconductorController,
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
                          Icons.check,
                          color: color,
                          semanticLabel: "OK",
                        ),
                        iconSize: 30,
                        onPressed: () {
                          if (seleccionado == null) {
                            Fluttertoast.showToast(
                                msg: "Ingrese tipo documento");
                          } else if (fecha_documento_ver.toString() == "") {
                            Fluttertoast.showToast(
                                msg: "Ingrese fecha de documento");
                          } else if (numdocController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Ingrese numero documento");
                          }
//                          else if (totalController.text == "") {
//                            Fluttertoast.showToast(msg: "Ingrese total");
//                          } else  if (_rutController.text == "") {
//                            Fluttertoast.showToast(msg: "Ingrese rut");
//                          } else if (!onSubmitAction(context)) {
//                            Fluttertoast.showToast(msg: "Rut no valido");
//                          } else if (patenteController.text == "") {
//                            Fluttertoast.showToast(msg: "Ingrese patente");
//                          } else if (nomconductorController.text == "") {
//                            Fluttertoast.showToast(
//                                msg: "Ingrese nombre conductor");
//                          }
                          else {
                            Navigator.pushNamed(context, '/ingreso_producto');
                            //aqui se envian los campos capturados con controller
                            //(se hace un controller por cada campo a obtener)
                            identi_doc_provider.tipodoc =
                                seleccionado.doc_descripcion;
                            identi_doc_provider.numero_tipo_documento =
                                seleccionado.doc_id.toString();
                            identi_doc_provider.numerodoc =
                                numdocController.text;
                            identi_doc_provider.total = totalController.text;
                            identi_doc_provider.fechaingreso = fecha_now_dos;
                            identi_doc_provider.fechadoc = fecha_documento;
                            identi_doc_provider.nombreconductor =
                                nomconductorController.text;
                            identi_doc_provider.rutconductor =
                                _rutController.text;
                            identi_doc_provider.patente =
                                patenteController.text;
                            recepcion_provider.total_recepcion;

                          }
                        },
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.clear_all,
                          color: color,
                          semanticLabel: "Limpiar",
                        ),
                        iconSize: 30,
                        onPressed: () {},
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Icon(icon, color: color),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: color,
                          semanticLabel: "Factura sin ingreso",
                        ),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushNamed(context, '/identidocu');
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Factura sin ingreso",
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

  Future selectDocumento() async {
    String url = DotEnv().env['SERVER'] + "seleccion_tipodocumento";
    var response = await http.post(
      url,
      headers: {"Accept": "application/json"},
    ).timeout(const Duration(seconds: 7));

    switch (response.statusCode) {
      case 200:
        List data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          TipoDOcumento tipoDOcumento = TipoDOcumento();
          tipoDOcumento.doc_id = data[i]["doc_id"];
          tipoDOcumento.doc_descripcion = data[i]["doc_descripcion"];
          tiposDocumento.add(tipoDOcumento);
        }
        List<DropdownMenuItem> items = new List();
        for (TipoDOcumento tipo in tiposDocumento) {
          items.add(
            new DropdownMenuItem(
                value: tipo, child: Text(tipo.doc_descripcion)),
          );
        }
        setState(() {
          _items = items;
        });
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        break;
      default:
        break;
    }
  }
}