import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpcom/src/providers/codigo_producto_provider.dart';
import 'package:helpcom/src/providers/identificacion_documento_provider.dart';
import 'package:helpcom/src/providers/recepcion_provider.dart';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

ProgressDialog pr;

void main() {
  // debugPaintSizeEnabled = true;
  runApp(Ingreso_Producto_pendiente());
}

class Ingreso_Producto_pendiente extends StatefulWidget {
  @override
  _Ingreso_Producto_pendienteState createState() =>
      _Ingreso_Producto_pendienteState();
}

class _Ingreso_Producto_pendienteState
    extends State<Ingreso_Producto_pendiente> {
  final FocusNode _nodeText1 = FocusNode();
  double percentage = 0.0;
  @override
  String pro_plu = '';
  String pro_codigo_barra;

  String nombrepro = '';
  String tipoemb = '';
  String unidad = '';
  String cantxemb = '';
  String cantoc = '';
  String ocm_total_bruto;
  String ocm_unitario_bruto;
  String rpm_solicitados_oc;
  String rpm_cantidad_ingresada;
  int restantes = 0;

  double restantes_double;
  int cantidad_registrada;

  int cantidad_pedida;

  double cantidad;
  String valor_total_recepcion;
  int rec_numero;

  int fco_id;

  String pro_codigo_plu;

  String pro_codigo_plu_ex;
  String pro_codigo_plu_grabados;
  double pendiente;

  int cantida_por_recepcionar = 0;

  int cantida_rpm;
  int rec_numero_ex;
  String fol_ano = '';
  String fol_mes = '';
  String bfolio = '';

  TextEditingController codproController = TextEditingController();
  TextEditingController pendiente_controller = TextEditingController();
  TextEditingController rpm_cantidad = TextEditingController();
  TextEditingController sumacantidad_controller = TextEditingController();
  TextEditingController total_valor_producto = TextEditingController();
  TextEditingController pendiente_normal_controller = TextEditingController();

  TextEditingController sumapendiete_controller = TextEditingController();
  TextEditingController grabar_pendite_controller = TextEditingController();

  bool pVal = false;
  int rpm_cantidad_leido;
  int rec_total;

  String double_cantidad_registrada = '';
  String double_restantes_double = '';
  String double_cantidad_pedida = '';
  String double_cantida_por_recepcionar = '';
  String double_rpm_cantidad_leido = '';

  iniState() {
    limpiarCampos();
  }

  Widget build(BuildContext context) {
    final identiProvider = Provider.of<IdentiDocProvider>(context);
    final codigoproProvider = Provider.of<CodigoProductoProvider>(context);
    final _recepcion_provider = Provider.of<RecepcionProvider>(context);
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
    print("rec_numero " + codigoproProvider.rec_numero);
    print("fcoid " + identiProvider.fco_id);
    print("res $restantes");
    Color color = Theme.of(context).primaryColor;
    return MaterialApp(
      title: 'Ingreso Producto Pendiente',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ingreso Producto Pendiente'),
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
                        Consumer<IdentiDocProvider>(
                          builder: (_, recepcionInfo, child) => Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 200,
                            height: 30,
                            child: Text(
                              'REC:' + codigoproProvider.rec_numero,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Tipo Doc:' + identiProvider.tipodoc,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Consumer<RecepcionProvider>(
                          builder: (_, recepcionInfo, child) => Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 200,
                            height: 30,
                            child: Text(
                              'O.C.:' + recepcionInfo.ocoid,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Consumer<IdentiDocProvider>(
                          builder: (_, recepcionInfo, child) => Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 200,
                            height: 30,
                            child: Text(
                              'Nº Doc:' + identiProvider.numerodoc,
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
            Column(children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                focusNode: _nodeText1,
                controller: codproController,
                decoration: InputDecoration(
                  hintText: "Codigo Producto",
                  prefixIcon: Icon(Icons.search),
                  labelText: "Codigo Producto",
                  focusColor: Colors.red,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
              ),
            ]),
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
                        ),
                        iconSize: 25,
                        onPressed: () async {
                          pr.show();
                          Future.delayed(Duration(seconds: 2))
                              .then((onValue) async {
                            if (pr.isShowing())
                              //await busquedaCod(context);
                              //await existencia_Plu(context);

                              await producto_existe(codproController.text);
                            await existencia_Plu(context);
                            await busquedaCod(context);
                            await busquedaCod_igresado_double(context);
                            await rec_numero_otra(context);
                            print('rpm_cantida $cantida_rpm');
                            print('rpm_cantida_oc $cantoc');

                            print('rpm_cantida $cantida_rpm');
                            print('rpm_cantida_oc $cantoc');
                            if (await leido_previamente_double(context) ==
                                    true &&
                                pVal == true) {
                              //await canitdad_otras_recepciones(context);
                              await canitdad_otras_recepciones_doble(context);
                              await rec_numero_otra(context);
                              //int cantidad_en_otro_rec = cantida_por_recepcionar;
                              int rpm_en_otro_rec = cantida_rpm;
                              //int rpm_actual_rec = rpm_cantidad_leido;
//                              cantida_por_recepcionar
//                              double_cantida_por_recepcionar
                              codigoproProvider.nombreproducto =
                                  nombrepro.toString();
                              codigoproProvider.rec_numero =
                                  codigoproProvider.rec_numero.toString();
                              codigoproProvider.cantidad_oc = cantoc.toString();
                              codigoproProvider.tipo_emb = tipoemb.toString();
                              codigoproProvider.unidad = unidad.toString();
                              codigoproProvider.cantidaporrecepcionar =
                                  double_cantida_por_recepcionar.toString();
                              codigoproProvider.cantidad_rpm_otro_rec =
                                  rpm_en_otro_rec;
                              codigoproProvider.cantidad_rpm_actual_rec =
                                  double_cantidad_registrada.toString();
                              codigoproProvider.codpro = pro_plu;
                              codigoproProvider.pval = pVal;
                              Navigator.pushNamed(
                                  context, '/leido_previamente');
                              await limpiarCampos();
                            } else if (await leido_previamente(context) ==
                                    true &&
                                rpm_cantidad_leido != null) {
                              await canitdad_otras_recepciones(context);
                              await rec_numero_otra(context);
                              int cantidad_en_otro_rec =
                                  cantida_por_recepcionar;
                              int rpm_en_otro_rec = cantida_rpm;
                              int rpm_actual_rec = rpm_cantidad_leido;
                              Navigator.pushNamed(
                                  context, '/leido_previamente');
                              codigoproProvider.nombreproducto =
                                  nombrepro.toString();
                              codigoproProvider.rec_numero =
                                  codigoproProvider.rec_numero.toString();
                              codigoproProvider.cantidad_oc = cantoc.toString();
                              codigoproProvider.tipo_emb = tipoemb.toString();
                              codigoproProvider.unidad = unidad.toString();
                              codigoproProvider.cantidaporrecepcionar =
                                  cantidad_en_otro_rec.toString();
                              codigoproProvider.cantidad_rpm_otro_rec =
                                  rpm_en_otro_rec;
                              codigoproProvider.cantidad_rpm_actual_rec =
                                  rpm_actual_rec.toString();
                              codigoproProvider.codpro = pro_plu;
                              codigoproProvider.pval = pVal;
                              await limpiarCampos();
                            } else if (codproController.text == "") {
                              Fluttertoast.showToast(
                                  msg: "Ingrese codigo de producto",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 30.0);
                            } else if (await existencia_Plu(context) == false) {
                              Fluttertoast.showToast(
                                  msg: "PLU no existe en la base de datos",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 30.0);
                            } else if (await rec_numero_otra(context) == true &&
                                cantida_rpm == int.tryParse(cantoc)) {
                              Fluttertoast.showToast(
                                  msg:
                                      "PLU completa y/o Existente en otra recepcion",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 30.0);
                              limpiarCampos();
                            } else {
                              await busquedaCod(context);
                              await busquedaCod_igresado(context);
                              print(rec_numero_ex);
                              print(restantes);
                              print(cantidad_registrada);
                              print(cantidad_pedida);
                              //validacion para buscar productos nuevo a ingresar o completar producto pendiente dentro de
                              //una rececpcion nueva
                              if (cantidad_registrada != cantidad_pedida ||
                                  await busquedaCod_igresado(context) ==
                                      false) {
                                await busquedaCod(context);
                                setState(() {
                                  print('pendiente restante $restantes');
                                  sumapendiete_controller.text =
                                      restantes.toString();
                                  rpm_cantidad.clear();
                                });
                              } else if (cantida_rpm != 0) {
                                await busquedaCod(context);
                                await canitdad_otras_recepciones(context);
                                print('pendiente $cantida_por_recepcionar');
                                setState(() {
                                  pendiente_controller.text =
                                      cantida_por_recepcionar.toString();
                                  rpm_cantidad.clear();
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Ya registrado completamente",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 30.0);
                                pendiente_controller.clear();
                                rpm_cantidad.clear();
                                limpiarCampos();
                              }
                            }
                            pr.hide();
                          });
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Buscar Codigo",
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
                          Icons.linked_camera,
                          color: color,
                          semanticLabel: "Escanear",
                        ),
                        iconSize: 25,
                        onPressed: () async {
                          var result = await BarcodeScanner.scan();
                          print(result
                              .type); // The result type (barcode, cancelled, failed)
                          print(result.rawContent); // The barcode content
                          print(result.format); // The barcode format (as enum)
                          print(result
                              .formatNote); // If a unknown format was scanned this field cont
                          codproController.text = result.rawContent;

                          print("Codigoxxttxx: " + codproController.text);

                          await producto_existe(codproController.text);
                          pro_codigo_plu = pro_plu.toString();
                          print("pro_codigo_plu: " + pro_codigo_plu);

                          pr.show();
                          Future.delayed(Duration(seconds: 2))
                              .then((onValue) async {
                            if (pr.isShowing()) await rec_numero_otra(context);
                            await busquedaCod(context);
                            await existencia_Plu(context);
                            print('rpm_cantida $cantida_rpm');
                            print('rpm_cantida_oc $cantoc');
                            if (await leido_previamente_double(context) ==
                                    true &&
                                pVal == true) {
                              //await canitdad_otras_recepciones(context);
                              await canitdad_otras_recepciones_doble(context);
                              await rec_numero_otra(context);
                              //int cantidad_en_otro_rec = cantida_por_recepcionar;
                              int rpm_en_otro_rec = cantida_rpm;
                              //int rpm_actual_rec = rpm_cantidad_leido;
//                              cantida_por_recepcionar
//                              double_cantida_por_recepcionar
                              codigoproProvider.nombreproducto =
                                  nombrepro.toString();
                              codigoproProvider.rec_numero =
                                  codigoproProvider.rec_numero.toString();
                              codigoproProvider.cantidad_oc = cantoc.toString();
                              codigoproProvider.tipo_emb = tipoemb.toString();
                              codigoproProvider.unidad = unidad.toString();
                              codigoproProvider.cantidaporrecepcionar =
                                  double_cantida_por_recepcionar.toString();
                              codigoproProvider.cantidad_rpm_otro_rec =
                                  rpm_en_otro_rec;
                              codigoproProvider.cantidad_rpm_actual_rec =
                                  double_cantidad_registrada.toString();
                              codigoproProvider.codpro = pro_plu;
                              codigoproProvider.pval = pVal;
                              Navigator.pushNamed(
                                  context, '/leido_previamente');
                              await limpiarCampos();
                            } else if (await leido_previamente(context) ==
                                    true &&
                                rpm_cantidad_leido != null) {
                              await canitdad_otras_recepciones(context);
                              await rec_numero_otra(context);
                              int cantidad_en_otro_rec =
                                  cantida_por_recepcionar;
                              int rpm_en_otro_rec = cantida_rpm;
                              int rpm_actual_rec = rpm_cantidad_leido;
                              Navigator.pushNamed(
                                  context, '/leido_previamente');
                              codigoproProvider.nombreproducto =
                                  nombrepro.toString();
                              codigoproProvider.rec_numero =
                                  codigoproProvider.rec_numero.toString();
                              codigoproProvider.cantidad_oc = cantoc.toString();
                              codigoproProvider.tipo_emb = tipoemb.toString();
                              codigoproProvider.unidad = unidad.toString();
                              codigoproProvider.cantidaporrecepcionar =
                                  cantidad_en_otro_rec.toString();
                              codigoproProvider.cantidad_rpm_otro_rec =
                                  rpm_en_otro_rec;
                              codigoproProvider.cantidad_rpm_actual_rec =
                                  rpm_actual_rec.toString();
                              codigoproProvider.codpro = pro_plu;
                              codigoproProvider.pval = pVal;
                              await limpiarCampos();
                            } else if (codproController.text == "") {
                              Fluttertoast.showToast(
                                  msg: "Ingrese codigo de producto",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 30.0);
                            } else if (await existencia_Plu(context) == false) {
                              Fluttertoast.showToast(
                                  msg: "PLU no existe en la base de datos",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 30.0);
                            } else if (await rec_numero_otra(context) == true &&
                                cantida_rpm == int.tryParse(cantoc)) {
                              Fluttertoast.showToast(
                                  msg:
                                      "PLU completa y/o Existente en otra recepcion",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 30.0);
                              limpiarCampos();
                            } else {
                              await busquedaCod(context);
                              await busquedaCod_igresado(context);
                              print(rec_numero_ex);
                              print(restantes);
                              print(cantidad_registrada);
                              print(cantidad_pedida);
                              //validacion para buscar productos nuevo a ingresar o completar producto pendiente dentro de
                              //una rececpcion nueva
                              if (cantidad_registrada != cantidad_pedida ||
                                  await busquedaCod_igresado(context) ==
                                      false) {
                                await busquedaCod(context);
                                setState(() {
                                  print('pendiente restante $restantes');
                                  sumapendiete_controller.text =
                                      restantes.toString();
                                  rpm_cantidad.clear();
                                });
                              } else if (cantida_rpm != 0) {
                                await busquedaCod(context);
                                await canitdad_otras_recepciones(context);
                                print('pendiente $cantida_por_recepcionar');
                                setState(() {
                                  pendiente_controller.text =
                                      cantida_por_recepcionar.toString();
                                  rpm_cantidad.clear();
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Ya registrado completamente",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 30.0);
                                pendiente_controller.clear();
                                rpm_cantidad.clear();
                                limpiarCampos();
                              }
                            }
                            pr.hide();
                          });
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Icon(icon, color: color),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: color,
                          semanticLabel: "Limpiar",
                        ),
                        iconSize: 25,
                        onPressed: () {
                          limpiarCampos();
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
            ),
            SizedBox(
              height: 15,
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
                          "Nombre Producto",
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
                            '$nombrepro',
                            //maxLines: whatever,
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
                children: <Widget>[
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
                        child: Text(
                          //forma de llamar el dato cargo en el controlador
                          //se utilizar el final declarado (constante)
                          identiProvider.patente,
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
                          "Cant X Emb",
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
                            '$cantxemb',
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
                  )
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
                        "Tipo Embalaje",
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
                          ' $tipoemb',
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
                          child: (pVal == true)
                              ? TextField(
                                  // keyboardType: TextInputType.number,
                                  controller: rpm_cantidad,
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: color,
                                  ),
                                  onChanged: (value) {
                                    //en onchanged se captura el valor ingresado(editable)
                                    //en try se convierte el tipo de dato(string a double)
                                    //en catch se advierte de alguna excepcion(errores),
                                    //durante la conversion en try
                                    try {
                                      double cantidad_oc = double.parse(cantoc);

                                      double cantidad = double.parse(value);
                                      double precio_unidad =
                                          double.parse(ocm_unitario_bruto);
                                      int pendite_restar = restantes;
                                      int pendite_sumar = cantidad_registrada;
                                      int cantidad_rpm_pendiente = cantida_rpm;

                                      if (restantes != 0 && restantes != null) {
                                        sumapendiete_controller.text =
                                            (restantes - cantidad).toString();
                                        grabar_pendite_controller.text =
                                            (pendite_sumar + cantidad)
                                                .toString();
                                        double cantidad_cantidad_pendiente =
                                            (pendite_sumar + cantidad);
//                                        print(
//                                            "nunca1 $cantidad_cantidad_pendiente");
                                        total_valor_producto.text =
                                            (cantidad_cantidad_pendiente *
                                                    precio_unidad)
                                                .toString();
//                                        print(
//                                            'if ' + total_valor_producto.text);
                                      } else if (cantida_por_recepcionar != 0) {
                                        total_valor_producto.text =
                                            (cantidad * precio_unidad)
                                                .toString();
                                        pendiente_controller.text =
                                            (cantida_por_recepcionar - cantidad)
                                                .toString();
                                        print('ELSEif_pv ' +
                                            pendiente_controller.text);
                                        print(
                                            'ELSEifCANTIDADRPM_pv $cantida_por_recepcionar');
                                      } else {
                                        total_valor_producto.text =
                                            (cantidad * precio_unidad)
                                                .toString();
                                        print('eslse ' +
                                            total_valor_producto.text);
                                        pendiente_normal_controller.text =
                                            (cantidad_oc - cantidad).toString();
                                      }
                                    } catch (e) {
                                      pendiente_normal_controller.text =
                                          "Error";
                                    }
                                    //print(value);
                                  },
                                )
                              : TextField(
                                  // keyboardType: TextInputType.number,
                                  controller: rpm_cantidad,
                                  maxLines: 1,
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: color,
                                  ),
                                  onChanged: (value) {
                                    //en onchanged se captura el valor ingresado(editable)
                                    //en try se convierte el tipo de dato(string a double)
                                    //en catch se advierte de alguna excepcion(errores),
                                    //durante la conversion en try
                                    try {
                                      double cantidad_oc = double.parse(cantoc);

                                      double cantidad = double.parse(value);
                                      double precio_unidad =
                                          double.parse(ocm_unitario_bruto);
                                      int pendite_restar = restantes;
                                      int pendite_sumar = cantidad_registrada;

                                      if (pendite_restar != 0 &&
                                          pendite_restar != null) {
                                        double cantidad_cantidad_pendiente =
                                            (pendite_sumar + cantidad);
                                        //double valor_total_pendiente = (cantidad_cantidad_pendiente * precio_unidad);
                                        print(
                                            "nunca1 $cantidad_cantidad_pendiente");
                                        total_valor_producto.text =
                                            (cantidad_cantidad_pendiente *
                                                    precio_unidad)
                                                .toString();
                                        sumapendiete_controller.text =
                                            (pendite_restar - cantidad)
                                                .toString();
                                        grabar_pendite_controller.text =
                                            (pendite_sumar + cantidad)
                                                .toString();
                                        print(
                                            'if ' + total_valor_producto.text);
                                        print('if_contro ' +
                                            sumapendiete_controller.text);
                                      } else if (cantida_por_recepcionar != 0 &&
                                          cantida_por_recepcionar != null) {
                                        total_valor_producto.text =
                                            (cantidad * precio_unidad)
                                                .toString();
                                        pendiente_controller.text =
                                            (cantida_por_recepcionar - cantidad)
                                                .toString();
                                        print(
                                            'ELSEif_cantodad_por $cantida_por_recepcionar');
                                        print('ELSEif_cantodad $cantidad');
                                        print('ELSEif ' +
                                            pendiente_controller.text);
                                        print(
                                            'ELSEifCANTIDADRPM $cantida_por_recepcionar');
                                      } else {
                                        total_valor_producto.text =
                                            (cantidad * precio_unidad)
                                                .toString();
                                        print('eslse2-- ' +
                                            total_valor_producto.text);
                                        setState(() {
                                          pendiente_normal_controller.text =
                                              (cantidad_oc - cantidad)
                                                  .toString();
                                          print('eslse2-- ' +
                                              pendiente_normal_controller.text);
                                        });
                                      }
                                    } catch (e) {
                                      pendiente_normal_controller.text =
                                          "Error";
                                    }
                                    //print(value);
                                  },
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Unidad",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: color,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 80,
                        height: 30,
                        child: Text(
                          '$unidad',
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("P"),
                      Checkbox(
                        value: pVal,
                        onChanged: (bool value) {
                          setState(() {
                            //pVal = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cantidad OC",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: color,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 80,
                        height: 30,
                        child: Text(
                          '$cantoc',
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
                          "PENDIENTE",
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
                          child: (restantes != null && restantes > 0)
                              ? TextField(
                                  controller: sumapendiete_controller,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: color,
                                  ),
                                )
                              :
                              //cantida_por_recepcionar
                              (cantida_por_recepcionar != 0)
                                  ? TextField(
                                      controller: pendiente_controller,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: color,
                                      ),
                                    )
                                  : TextField(
                                      controller: pendiente_normal_controller,
                                      enabled: false,
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
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (restantes != null && restantes > 0)
                          ? IconButton(
                              icon: Icon(
                                Icons.save,
                                color: color,
                              ),
                              iconSize: 30,
                              onPressed: () async {
                                int cantidad_oc = restantes;
                                double porcentaje = (cantidad_oc * 120) / 100;

                                //print("porcentaje $porcentaje");
                                //print("cantidadoc $cantidad_oc");
                                if (rpm_cantidad.text == '') {
                                  Fluttertoast.showToast(
                                      msg: "ingrese cantidad",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 30.0);
                                } else if (pVal == true &&
                                    double.parse(rpm_cantidad.text) >
                                        porcentaje) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Excede el 20% extra para producto pesable",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 30.0);
                                } else if (pVal == false &&
                                    double.parse(rpm_cantidad.text) >
                                        restantes) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Ingrese cantidad igual o menor a cantidad Oc11",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 30.0);
                                } else {
                                  await updatecantidad_pendiente(context);
                                  limpiarCampos();
                                }
                              },
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.save,
                                color: color,
                              ),
                              iconSize: 30,
                              onPressed: () async {
                                double cantidad_oc = double.parse(cantoc);
                                double porcentaje = (cantidad_oc * 120) / 100;
                                print("porcentajeelse $porcentaje");
                                print("cantidadocelse $cantidad_oc");
                                print(rpm_cantidad.text);

                                if (codproController.text == '') {
                                  Fluttertoast.showToast(
                                      msg: "Ingrese codigo producto",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 30.0);
                                } else if (rpm_cantidad.text == '') {
                                  Fluttertoast.showToast(
                                      msg: "ingrese cantidadxx",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 30.0);
                                } else if (pVal == true &&
                                    double.parse(rpm_cantidad.text) >
                                        porcentaje) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Excede el 20% extra para producto pesable",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 30.0);
                                } else if (pVal == false &&
                                    int.parse(rpm_cantidad.text) >
                                        int.parse(cantoc)) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Ingrese cantidad igual o menor a cantidad Oc",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 30.0);
                                } else if (double.parse(rpm_cantidad.text) <
                                        double.parse(cantoc) &&
                                    rec_numero == null &&
                                    nombrepro != '') {
                                  primershowAlertDialog(context);
                                } else if (double.parse(rpm_cantidad.text) <
                                    double.parse(cantoc)) {
                                  showAlertDialog(context);
                                } else if (rec_numero == null &&
                                    nombrepro != '') {
//                            await insertarDatosDoc(context);
//                            insertarDatosFactura(context);
                                  insertarDatosproductosmov(context);
                                  updateDetalleCompra(context);
                                  limpiarCampos();
                                  Fluttertoast.showToast(
                                      msg:
                                      "Datos guardados exitosamente",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 30.0);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Busque el codigo ingresado");

                                  if (codproController.text ==
                                      pro_codigo_plu_ex) {
                                    insertarDatosproductosmov(context);
                                    sumatotalrecepcion(context);
                                    updateDetalleCompra(context);
                                    limpiarCampos();
                                    Fluttertoast.showToast(
                                        msg: "Datos guardados exitosamente");
                                  }
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
                          Icons.playlist_add_check,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          final insertar_indenti_factura =
                              Provider.of<IdentiDocProvider>(context,
                                  listen: false);
                          total_recepcion_crp(context);
                          recepcion_Recepcionado(context);
                          verifica_numero_documento(context);

                          if (codigoproProvider.rec_numero == null) {
                            Fluttertoast.showToast(
                                msg:
                                    "DEBE INGRESAR PRODUCTOS A LA RECEPCION!!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            //verifica_numero_documento(context);
                          } else if (nombrepro != '') {
                            Fluttertoast.showToast(
                                msg:
                                    "EXISTE INFORMACION DE PRODUCTO INGRESADA EN EL FORMULARIO QUE NO A SIDO GRABADA!!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else if (await verifica_numero_documento(context) ==
                              true) {
                            Fluttertoast.showToast(
                                msg:
                                    "LA FACTURA DE COMPRA  SE INGRESO EN OTRA RECEPCION!!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else if (int.tryParse(
                                  insertar_indenti_factura.total) !=
                              rec_total) {
                            cierreshowAlertDialog(context);
                          } else {
                            busca_oco_tipo(context);
                            print("IMPRIMR DOC");
                            Fluttertoast.showToast(
                                msg: "IMPRIMR",
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
                          Icons.pageview,
                          color: color,
                          semanticLabel: "Prod Recep",
                        ),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/listado_producto_grabado');
                          codigoproProvider.rec_numero;
                          _recepcion_provider.ocoid;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Prod Recep",
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
                          Icons.exit_to_app,
                          color: color,
                          semanticLabel: "Salir",
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          await limpia_provider();
                          Navigator.pushNamed(context, '/menu');
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Salir",
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

  limpiarCampos() {
    setState(() {
      nombrepro = '';
      tipoemb = '';
      unidad = '';
      cantxemb = '';
      cantoc = '';
      rpm_cantidad.clear();
      codproController.clear();
      pendiente_controller.clear();
      pendiente_normal_controller.clear();
      restantes = 0;
      cantida_por_recepcionar = 0;
      pVal = false;
    });
  }

  void limpia_provider() {
    final identiProvider =
        Provider.of<IdentiDocProvider>(context, listen: false);
    final codigoproProvider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    final recepcion_provider =
        Provider.of<RecepcionProvider>(context, listen: false);
    setState(() {
      codigoproProvider.rec_numero = '';
      identiProvider.tipodoc = '';
      recepcion_provider.ocoid = '';
      identiProvider.numerodoc = '';
      rec_numero_ex = null;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget siButton = FlatButton(
      child: Text("Si"),
      onPressed: () async {
        //if (codproController.text == pro_codigo_plu_ex) {
        await insertarDatosproductosmov(context);
        await updateDetalleCompra(context);
        Navigator.of(context, rootNavigator: true).pop();
        limpiarCampos();
      },
    );
    Widget noButton = FlatButton(
      child: Text("noarriba"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Diferencia al ingresar cantidad"),
          content: Text(
              "La cantidad ingresada es diferente a la solicitada.¿Desea grabar el producto?"),
          actions: [
            siButton,
            noButton,
            FlatButton(
              child: Text("No"),
              onPressed: () async {
                await Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  cierreshowAlertDialog(BuildContext context) {
    // set up the buttons
    Widget siButton = FlatButton(
      child: Text("Si"),
      onPressed: () async {
        if (await recepcion_Recepcionado(context) == true) {
          bool mCierraRecep = true;
          int que_hacer = 2;

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text('PRODUCTOS NO RECEPCIONADOS'),
                  children: <Widget>[
                    SimpleDialogOption(
                      child: const Text(
                          'Hay productos que no estan recepcionados, ¿que desea hacer?'),
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
              });
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
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  primershowAlertDialog(BuildContext context) {
    // set up the buttons
    Widget siButton = FlatButton(
      child: Text("Si"),
      onPressed: () async {
        await insertarDatosDoc(context);
        insertarDatosFactura(context);
        insertarDatosproductosmov(context);
        await updateDetalleCompra(context);
        limpiarCampos();
        Fluttertoast.showToast(
            msg: "El producto fue grabado con cantidad pendiente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 30.0);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Diferencia al ingresar cantidad"),
          content: Text(
              "La cantidad ingresada es diferente a la Pendiente.¿Desea grabar el producto?"),
          actions: [
            siButton,
            //noButton,
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> busquedaCod(BuildContext context) async {
    String url = DotEnv().env['SERVER'] + "obtener_producto_orden_compra";
    final recepcion_ocoid =
        Provider.of<RecepcionProvider>(context, listen: false);
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_plu,
      "oco_id": recepcion_ocoid.ocoid,
    }).timeout(const Duration(seconds: 7));
    //print("plu: " + pro_codigo_plu + " oco: " + recepcion_ocoid.ocoid);
    print("busquedaCod " + response.body);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          nombrepro = data["mae_productos"]['pro_nombre_producto'].toString();
          tipoemb =
              data["mae_productos"]['mae_embalaje']['emb_nombre'].toString();
          unidad =
              data["mae_productos"]['mae_tipo_medida']['med_nombre'].toString();
          cantxemb = data["mae_productos"]['pro_unidades_embalaje'].toString();
          cantoc = data['ocm_cantidad'].toString();
          ocm_total_bruto = data['ocm_total_bruto'].toString();
          ocm_unitario_bruto = data['ocm_unitario_bruto'].toString();
          pro_codigo_plu_ex =
              data["mae_productos"]['pro_codigo_plu'].toString();
          if (data["mae_productos"]['pro_funcion_plu'] == 1) {
            setState(() {
              pVal = true;
            });
          } else {
            setState(() {
              pVal = false;
            });
          }
        });
        return true;
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
//        limpiarCampos();
//        setState(() {
//          codproController.clear();
//          nombrepro = "";
//          tipoemb = "";
//          unidad = "";
//          cantxemb = "";
//          cantoc = "";
//          rpm_cantidad.clear();
//        });
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future busquedaCod_igresado(BuildContext context) async {
    final codigoproProvider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "validacionproductoingresado";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": codigoproProvider.rec_numero,
      "pro_codigo_plu": pro_plu
    }).timeout(const Duration(seconds: 7));
//    print("busquedaCod_igresado"+response.body);
//    print("rec_ingresado: " +
//        rec_numero.toString() +
//        " plu_ingresado: " +
//        codproController.text);

    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        rec_numero = data["rec_numero"];
        cantidad_registrada = data["rpm_cantidad"];
        restantes = data["restantes"];
        cantidad_pedida = data["rpm_solicitados_oc"];

//        limpiarCampos();
//        setState(() {
//          codproController.clear();
//          nombrepro = "";
//          tipoemb = "";
//          unidad = "";
//          cantxemb = "";
//          cantoc = "";
//          rpm_cantidad.clear();
//        });
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

  Future busquedaCod_igresado_double(BuildContext context) async {
    final codigoproProvider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "validacionproductoingresado";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": codigoproProvider.rec_numero,
      "pro_codigo_plu": pro_plu
    }).timeout(const Duration(seconds: 7));
    print("busquedaCod_igresado_double" + response.body);
//    print("rec_ingresado: " +
//        rec_numero.toString() +
//        " plu_ingresado: " +
//        codproController.text);

    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        //rec_numero = data["rec_numero"];
        double_cantidad_registrada = data["rpm_cantidad"].toString();
        double_restantes_double = data["restantes"].toString();
        double_cantidad_pedida = data["rpm_solicitados_oc"].toString();

//        limpiarCampos();
//        setState(() {
//          codproController.clear();
//          nombrepro = "";
//          tipoemb = "";
//          unidad = "";
//          cantxemb = "";
//          cantoc = "";
//          rpm_cantidad.clear();
//        });
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

  Future<bool> updatecantidad_pendiente(BuildContext context) async {
    final codigopro_rec_Provider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "updatecantidad";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rpm_cantidad": grabar_pendite_controller.text,
      "pro_codigo_plu": pro_plu,
      "rec_numero": codigopro_rec_Provider.rec_numero,
      "rpm_total": total_valor_producto.text,
    }).timeout(const Duration(seconds: 7));
    print("updatecantidad" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        //pro_codigo_plu = data;
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        break;
      default:
        break;
    }
  }

//datos de insercion tabla com_recepcion_productos_mov
  Future insertarDatosproductosmov(BuildContext context) async {
    final codigoproProvider_pendiente =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    final identiProvider =
        Provider.of<IdentiDocProvider>(context, listen: false);

    String url = DotEnv().env['SERVER'] + "com_recepcion_productos_mov";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": codigoproProvider_pendiente.rec_numero,
      "pro_codigo_plu": pro_plu,
      "rpm_cantidad": rpm_cantidad.text,
      "rpm_unitario": ocm_unitario_bruto,
      "rpm_total": total_valor_producto.text,
      "rpm_solicitados_oc": cantoc,
      "rpm_recepcionados": "0", //hard-code
      "rpm_estado": "RECEPCIONADO", //hard-code
      "fco_id": identiProvider.fco_id,
      "rpm_unidad_embalaje": "1", //hard-code
      "rpm_unitario_factura": ocm_unitario_bruto,
      "rpm_cantidad_factura": rpm_cantidad.text,
    }).timeout(const Duration(seconds: 7));
    //print("frsnciscoid $fco_id");
    print("insertarDatosproductosmov" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        //pro_codigo_plu = data;
//        limpiarCampos();
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

  //insercion datos en tabla com_recepcion_productos
  Future insertarDatosDoc(BuildContext context) async {
    final insertar_recepcion_documento =
        Provider.of<RecepcionProvider>(context, listen: false);
    final insertar_indenti_documento =
        Provider.of<IdentiDocProvider>(context, listen: false);

    String url = DotEnv().env['SERVER'] + "com_recepcion_productos";
    String rut = insertar_indenti_documento.rutconductor;
    rut = rut.replaceAll(".", "");
    String rut_conduct = rut;
    var tempDate = DateTime.now();
    var formattedDate = "${tempDate.year}-0${tempDate.month}-${tempDate.day}  ";
    var formattedTime =
        "${tempDate.hour}:${tempDate.minute}:${tempDate.second}  ";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_fecha": formattedDate.toString(), // "2020-03-01",
      "rec_hora": formattedTime.toString(), // "12:38:20",
      "prv_rut": insertar_recepcion_documento.prv,
      "rec_total": insertar_indenti_documento.total,
      "rec_estado": "0", //hard-code
      "oco_id": insertar_recepcion_documento.ocoid,
      "usu_nusuario": globals.usuarioLogeado.nombre,
      "rec_sala_bodega": "0", //hard-code
      "rec_patente": insertar_indenti_documento.patente,
      "rec_nombre": insertar_indenti_documento.nombreconductor,
      "rec_rut": rut_conduct, //"12:38:20",
    }).timeout(const Duration(seconds: 7));
    print("insertarDatosDoc" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        rec_numero = data["rec_numero"];
        fco_id = data["fco_id"];
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
//        setState(() {
//          nombrepro = '';
//        });
        break;
      default:
        break;
    }
  }

//insercion de datos a tabla com_factura_compras
  Future insertarDatosFactura(BuildContext context) async {
    final insertar_recepcion_factura =
        Provider.of<RecepcionProvider>(context, listen: false);
    final insertar_indenti_factura =
        Provider.of<IdentiDocProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "com_facturas_compras";

    DateFormat inputFormat = DateFormat("yyyy-MM-dd");
    String fecha_ingre = insertar_indenti_factura.fechaingreso;
    DateTime dateTime_ymd = inputFormat.parse(fecha_ingre);
    var sixtyDaysFromNow = dateTime_ymd.add(new Duration(days: 30));
    var formattedDate =
        "${sixtyDaysFromNow.year}-0${sixtyDaysFromNow.month}-${sixtyDaysFromNow.day}  ";
    var formattedDateanio = "${dateTime_ymd.year}";
    var formattedDatemes = "${dateTime_ymd.month}";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "doc_id": insertar_indenti_factura.numero_tipo_documento,
      "fco_tipo": insertar_indenti_factura.tipodoc,
      "fco_numero": insertar_indenti_factura.numerodoc,
      "fco_fecha": insertar_indenti_factura.fechadoc,
      "prv_rut": insertar_recepcion_factura.prv,
      "fco_total": insertar_indenti_factura.total,
      "rec_numero": rec_numero.toString(),
      "act_precios": "0", //hard-code
      "fco_exento": "0", //hard-code
      "fco_neto": "0", //hard-code
      "fco_iva": "0", //hard-code
      "fco_ila": "0", //hard-code
      "fco_ila_beb": "0", //hard-code
      "fco_ila_cer": "0", //hard-code
      "fco_ila_lic": "0", //hard-code
      "fco_ret_carne": "0", //hard-code
      "fco_ret_harina": "0", //hard-code
      "fco_especifico": "0", //hard-code
      //"fco_correlativo": "0",
      "fco_fecha_ingreso": insertar_indenti_factura.fechaingreso,
      "fco_fecha_vencimiento": formattedDate.toString(), //'2020-03-01',
      "fco_ano": formattedDateanio.toString(), //'2020',
      "fco_mes": formattedDatemes.toString(), //'01',
      "fco_detalle": "S/C", //hard-code
      "fco_imp_no_recuperable": "0", //hard-code
    }).timeout(const Duration(seconds: 7));
    //print("insertarDatosFactura"+response.body);
    switch (response.statusCode) {
      case 200:
        var codpro = jsonDecode(response.body);
        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
        break;
      default:
        break;
    }
  }

  Future<bool> updatecantidad(BuildContext context) async {
    final insertar_recepcion =
        Provider.of<RecepcionProvider>(context, listen: false);
    final insertar_indentidoc =
        Provider.of<IdentiDocProvider>(context, listen: false);
    final codigopro_rec_Provider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "updatecantidad";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rpm_cantidad": sumacantidad_controller.text,
      "pro_codigo_plu": pro_plu,
      "rec_numero": codigopro_rec_Provider.rec_numero,
    }).timeout(const Duration(seconds: 7));
    print("updatecantidad" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        //pro_codigo_plu = data;

        break;
      case 500:
        Fluttertoast.showToast(msg: response.body.toString());
//        setState(() {
//          nombrepro = '';
//        });
        break;
      default:
        break;
    }
  }

  Future<bool> updateDetalleCompra(BuildContext context) async {
    final _recepcion_provider =
        Provider.of<RecepcionProvider>(context, listen: false);
    final codigopro_rec_Provider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "update_orden_compra";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": codigopro_rec_Provider.rec_numero.toString(),
      "pro_codigo_plu": pro_plu,
      "rpm_cantidad": rpm_cantidad.text,
      "oco_id": _recepcion_provider.ocoid.toString(),
      "ocm_recepcionados":
          codigopro_rec_Provider.cantidad_rpm_otro_rec.toString(),
    }).timeout(const Duration(seconds: 7));
    print("updatecantidad" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        //pro_codigo_plu = data;
        break;
      case 500:
        //Fluttertoast.showToast(msg: response.body.toString());
        break;
      default:
        break;
    }
  }

  Future<bool> sumatotalrecepcion(BuildContext context) async {
    final codigoproProvider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "sumatotal";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": codigoproProvider.rec_numero.toString(),
    }).timeout(const Duration(seconds: 7));
    //print(response.body);

    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        valor_total_recepcion = data["total"].toString();

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

  Future<bool> validacion_Folio(BuildContext context) async {
    final insertar_indenti_factura =
        Provider.of<IdentiDocProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "bfolio";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "doc_id": insertar_indenti_factura.numero_tipo_documento,
      "fecha": insertar_indenti_factura.fechaingreso, //'2019-01-01',
    }).timeout(const Duration(seconds: 7));
    //print("validacion_Folio"+response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        setState(() {
          fol_ano = data['mFolioAno'].toString();
          fol_mes = data['mFolioMes'].toString();
          bfolio = data['bFolio'].toString();
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

  Future<bool> existencia_Plu(BuildContext context) async {
    String url = DotEnv().env['SERVER'] + "verifica_plu";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_plu,
    }).timeout(const Duration(seconds: 7));
    //print("existencia_Plu" + response.body);
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

  Future<bool> rec_numero_otra(BuildContext context) async {
    final insertar_recepcion =
        Provider.of<RecepcionProvider>(context, listen: false);
    final cod_provaider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "verifica_rec_numero";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "oco_id": insertar_recepcion.ocoid.toString(),
      "pro_codigo_plu": pro_plu,
      "rec_numero": cod_provaider.rec_numero.toString(),
    }).timeout(const Duration(seconds: 7));
    print("rec_numero_otra" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        setState(() {
          cantida_rpm = data[0]['cantidad_rpm'];
        });
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

  Future<bool> canitdad_otras_recepciones(BuildContext context) async {
    final insertar_recepcion =
        Provider.of<RecepcionProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "verifica_plu_otra_recep";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "oco_id": insertar_recepcion.ocoid.toString(),
      "pro_codigo_plu": pro_plu,
    }).timeout(const Duration(seconds: 7));
    print("canitdad_otras_recepciones" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        setState(() {
          cantida_por_recepcionar = data[0]['recepcionados'];
        });
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

  Future<bool> canitdad_otras_recepciones_doble(BuildContext context) async {
    final insertar_recepcion =
        Provider.of<RecepcionProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "verifica_plu_otra_recep";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "oco_id": insertar_recepcion.ocoid.toString(),
      "pro_codigo_plu": pro_plu,
    }).timeout(const Duration(seconds: 7));
    print("canitdad_otras_recepciones_doble" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        setState(() {
          double_cantida_por_recepcionar = data[0]['recepcionados'].toString();
        });
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

  Future<bool> leido_previamente(BuildContext context) async {
    final insertar_recepcion =
        Provider.of<RecepcionProvider>(context, listen: false);
    final cod_provaider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "leido_previamente";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "oco_id": insertar_recepcion.ocoid.toString(),
      "pro_codigo_plu": pro_plu,
      "rec_numero": cod_provaider.rec_numero.toString(),
    }).timeout(const Duration(seconds: 7));
    print("leido_previamente" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        setState(() {
          rpm_cantidad_leido = data[0]['rpm_cantidad'];
        });
        //limpiarCampos();
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

  Future<bool> leido_previamente_double(BuildContext context) async {
    final insertar_recepcion =
        Provider.of<RecepcionProvider>(context, listen: false);
    final cod_provaider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "leido_previamente";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "oco_id": insertar_recepcion.ocoid.toString(),
      "pro_codigo_plu": pro_plu,
      "rec_numero": cod_provaider.rec_numero.toString(),
    }).timeout(const Duration(seconds: 7));
    print("leido_previamente" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        setState(() {
          double_rpm_cantidad_leido = data[0]['rpm_cantidad'].toString();
        });
        //limpiarCampos();
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

  Future<bool> total_recepcion_crp(BuildContext context) async {
    String url = DotEnv().env['SERVER'] + "total_recepcion_crp";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": rec_numero_ex.toString(),
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

  Future<bool> verifica_numero_documento(BuildContext context) async {
    final codigoproProvider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    final identiProvider =
        Provider.of<IdentiDocProvider>(context, listen: false);
    final _recepcion_provider =
        Provider.of<RecepcionProvider>(context, listen: false);
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

  Future<bool> producto_existe(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "select_producto_existe";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_activo": '1',
      "pro_codigo_plu": pro_codigo_plu,
      "pro_codigo_barra": codproController.text
    }).timeout(const Duration(seconds: 7));
    print('producto_existe' + response.body);
    print('producto_existebusquedaCodcontrolle ' + codproController.text);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          pro_plu = data['pro_codigo_plu'].toString();
          pro_codigo_barra = data['pro_codigo_barra'].toString();
        });
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
