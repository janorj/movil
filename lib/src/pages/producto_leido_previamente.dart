import 'dart:async';
import 'dart:convert';
import 'package:helpcom/src/pages/busqueda_recepcion.dart';
import 'package:helpcom/src/providers/codigo_producto_provider.dart';
import 'package:helpcom/src/providers/identificacion_documento_provider.dart';
import 'package:helpcom/src/providers/recepcion_provider.dart';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(Producto_Leido_Previamente());
}

class Producto_Leido_Previamente extends StatefulWidget {
  @override
  _Producto_Leido_PreviamenteState createState() => _Producto_Leido_PreviamenteState();
}

class _Producto_Leido_PreviamenteState extends State<Producto_Leido_Previamente> {
  final FocusNode _nodeText1 = FocusNode();
  @override

  TextEditingController cant_propuesta_controller = TextEditingController();
  TextEditingController resultado_cantidad_propuesta = TextEditingController();
  TextEditingController ocm_pr_controller = TextEditingController();
  TextEditingController resultado_remplazo_controller = TextEditingController();

  bool pVal = false;
  bool calculo = true;
  bool calculo_remplazo = true;

  String rpm_cantidad_leido;
  Widget build(BuildContext context) {

    //Color colorTexto  = (calculo) ? Colors.blue : Colors.red;
    final identiProvider = Provider.of<IdentiDocProvider>(context);
    final codigoproProvider = Provider.of<CodigoProductoProvider>(context);
    final _recepcion_provider = Provider.of<RecepcionProvider>(context);

    Color color = Theme.of(context).primaryColor;

    return MaterialApp(
      title: 'Producto Recepcionado',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Producto Recepcionado'),
        ),
        body:
        ListView(
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
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child:
                          Text(
                            'REC: ' + codigoproProvider.rec_numero,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Tipo Doc: ' + identiProvider.tipodoc,
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
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'PRODUCTO CON RECEPCION PREVIA',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chrome_reader_mode,
                    color: Colors.deepOrange,
                    size: 60,
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
                          "PRODUCTO: "+codigoproProvider.codpro.toString(),
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
                            ' '+ codigoproProvider.nombreproducto,
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
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Solicitado O.C.",
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
                            codigoproProvider.cantidad_oc,
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
                          "Pendiente O.C.",
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
                            codigoproProvider.cantidaporrecepcionar.toString(),
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
                          "Otras uni rec.",
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
                            codigoproProvider.cantidad_rpm_otro_rec.toString(),
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
                          "Cant orig rec",
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
                            codigoproProvider.cantidad_rpm_actual_rec.toString(),
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
                          "Unidad",
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
                            codigoproProvider.tipo_emb,
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
                        "Cant propuesta",
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
                        child:
                        (codigoproProvider.pval == true) ?
                        TextField(
                          // keyboardType: TextInputType.number,
                          controller: cant_propuesta_controller,
                          maxLines: 1,
                          textAlign: TextAlign.right,
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
                              double otras_uni_rec = double.parse(codigoproProvider.cantidad_rpm_otro_rec.toString());
                              double cant_orig_rec = double.parse(codigoproProvider.cantidad_rpm_actual_rec.toString());
                              double cant_propuesta = double.parse(value);
                              resultado_cantidad_propuesta.text = (otras_uni_rec + cant_orig_rec + cant_propuesta).toString();
                              double ss = double.parse(resultado_cantidad_propuesta.text);
                              ocm_pr_controller.text= (ss - cant_propuesta).toString();

                              resultado_remplazo_controller.text = (otras_uni_rec + cant_propuesta).toString();

                              print('ocmcontrolelr' + ocm_pr_controller.text);
                              print('remplazo--- ' + resultado_remplazo_controller.text);
                              double xx = double.parse(codigoproProvider.cantidad_oc);
                              double yy = double.parse(resultado_cantidad_propuesta.text);
                              double zz = double.parse(resultado_remplazo_controller.text);

                              if( yy > xx ){
                                setState(() {
                                  calculo = true;
                                });
                                print("ifx");
                              }else{
                                setState(() {
                                  calculo = false;
                                });
                                print("elsex");
                              }

                              if( zz > xx ){
                                setState(() {
                                  calculo_remplazo = true;
                                });
                                print("ifx");
                              }else{
                                setState(() {
                                  calculo_remplazo = false;
                                });
                                print("elsex");
                              }
                            } catch (e) {
                              resultado_cantidad_propuesta.text = "0";
                              resultado_remplazo_controller.text = "0";
                            }

                          },
                        ):
                        TextField(
                          // keyboardType: TextInputType.number,
                          controller: cant_propuesta_controller,
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
                              double otras_uni_rec = double.parse(codigoproProvider.cantidad_rpm_otro_rec.toString());
                              double cant_orig_rec = double.parse(codigoproProvider.cantidad_rpm_actual_rec.toString());
                              double cant_propuesta = double.parse(value);
                              resultado_cantidad_propuesta.text = (otras_uni_rec + cant_orig_rec + cant_propuesta).toString();
                              double ss = double.parse(resultado_cantidad_propuesta.text);
                              ocm_pr_controller.text= (ss - cant_propuesta).toString();

                              resultado_remplazo_controller.text = (otras_uni_rec + cant_propuesta).toString();

                              print('ocmcontrolelr' + ocm_pr_controller.text);
                              print('remplazo--- ' + resultado_remplazo_controller.text);
                              double xx = double.parse(codigoproProvider.cantidad_oc);
                              double yy = double.parse(resultado_cantidad_propuesta.text);
                              double zz = double.parse(resultado_remplazo_controller.text);

                              if( yy > xx ){
                                setState(() {
                                  calculo = true;
                                });
                                print("ifx");
                              }else{
                                setState(() {
                                  calculo = false;
                                });
                                print("elsex");
                              }

                              if( zz > xx ){
                                setState(() {
                                  calculo_remplazo = true;
                                });
                                print("ifx");
                              }else{
                                setState(() {
                                  calculo_remplazo = false;
                                });
                                print("elsex");
                              }
                            } catch (e) {
                              resultado_cantidad_propuesta.text = "0";
                              resultado_remplazo_controller.text = "0";
                            }

                          },
                        ),
                        decoration: BoxDecoration(border: Border.all()),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Resultado Suma",
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
                        child:
                        TextField(
                          controller: resultado_cantidad_propuesta,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            fillColor: (calculo) ? Colors.redAccent : Colors.black,
                            filled: calculo
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
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
                        value: codigoproProvider.pval,
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
                        child:
                        Text(
                          codigoproProvider.unidad, //pedido original
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
                          "Resultado reemplazo",
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
                          child: TextField(
                            controller: resultado_remplazo_controller,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                fillColor: (calculo_remplazo) ? Colors.redAccent : Colors.black,
                                filled: calculo_remplazo
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (codigoproProvider.pval == true) ?
                      IconButton(
                        icon: Icon(
                          Icons.add_box,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          double cantidad_oc_normal =
                              double.tryParse(codigoproProvider.cantidad_oc) ?? 1;
                          double porcentaje =
                              (cantidad_oc_normal * 120) / 100;
                          print("porcentajeelse $porcentaje");
                          print("cantidad_oc_normal $cantidad_oc_normal");

                          if(cant_propuesta_controller.text == ''){
                            Fluttertoast.showToast(
                                msg: "ingrese cantidad para sumar",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }else if (double.parse(resultado_cantidad_propuesta.text) >  porcentaje  )
                          {
                            Fluttertoast.showToast(
                                msg: "Resultado suma excede el 20% extra producto pesable",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }
                          else{
                            update_suma_rpmcantidad_crpm(context);
                            updateDetalleCompra(context);
                            Fluttertoast.showToast(
                                msg: "Producto Incrementado",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            Navigator.of(context).pop();
                          }
                        },
                      ):
                      IconButton(
                        icon: Icon(
                          Icons.add_box,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          if(cant_propuesta_controller.text == ''){
                            Fluttertoast.showToast(
                                msg: "ingrese cantidad para sumar",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }else if (double.parse(resultado_cantidad_propuesta.text) > double.tryParse(codigoproProvider.cantidad_oc))
                            {
                              Fluttertoast.showToast(
                                  msg: "Resultado suma es mayor a solicitud OC",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 30.0);
                            }
                          else{
                            update_suma_rpmcantidad_crpm(context);
                            updateDetalleCompra(context);
                            Fluttertoast.showToast(
                                msg: "Producto Incrementado",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Sumar",
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
                          Icons.refresh,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          if(cant_propuesta_controller.text == ''){
                            Fluttertoast.showToast(
                                msg: "ingrese cantidad para reemplazar",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }else if (double.parse(resultado_remplazo_controller.text) > double.parse(codigoproProvider.cantidad_oc))
                          {
                            Fluttertoast.showToast(
                                msg: "Resultado reemplazo es mayor a solicitud OC",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }
                          else{
                            update_remplazo_rpmcantidad_crpm(context);
                            update_remplazo_ocm_ocpm(context);

                            Fluttertoast.showToast(
                                msg: "Producto Reemplazado",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            Navigator.of(context).pop();

                          }
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Reemplazar",
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
                          Icons.pause,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Conservar",
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
                          Icons.delete,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () {

                          showAlertDialog(context);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Eliminar",
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget siButton = FlatButton(
      child: Text("Si"),
      onPressed:  () {
        //leido_previamente(context);
          elimina_leido_previamente(context);
          update_leido(context);
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).pop();
      },
    );
    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("¿Desea eliminar el producto del sistema?"),
      actions: [
        siButton,
        noButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> update_suma_rpmcantidad_crpm(BuildContext context) async {
    final codigopro_rec_Provider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "suma_rpm_crpm";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rpm_cantidad": codigopro_rec_Provider.cantidad_rpm_actual_rec.toString(),
      "pro_codigo_plu": codigopro_rec_Provider.codpro.toString(),
      "rec_numero": codigopro_rec_Provider.rec_numero,
      "suma_nueva": cant_propuesta_controller.text,
    }).timeout(const Duration(seconds: 7));
    print("update_suma_rpmcantidad_crpm " + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        //pro_codigo_plu = data;
        break;
      case 500:
        //Fluttertoast.showToast(msg: response.body.toString())
        break;
      default:
        break;
    }
  }

  Future<bool> update_remplazo_rpmcantidad_crpm(BuildContext context) async {
    final codigopro_rec_Provider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "remplazo_rpm_crpm";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rpm_cantidad": cant_propuesta_controller.text,
      "pro_codigo_plu": codigopro_rec_Provider.codpro.toString(),
      "rec_numero": codigopro_rec_Provider.rec_numero,
    }).timeout(const Duration(seconds: 7));
    print("update_remplazo_rpmcantidad_crpm " + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        //pro_codigo_plu = data;
        break;
      case 500:
      //Fluttertoast.showToast(msg: response.body.toString())
        break;
      default:
        break;
    }
  }
  Future<bool> updateDetalleCompra(BuildContext context) async {
    final insertar_recepcion =
    Provider.of<RecepcionProvider>(context, listen: false);
    final codigopro_rec_Provider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "update_orden_compra";
    String our = codigopro_rec_Provider.cantidad_rpm_otro_rec.toString();
    String cor = codigopro_rec_Provider.cantidad_rpm_actual_rec.toString();
    String cp= cant_propuesta_controller.text;
    int nn = codigopro_rec_Provider.cantidad_rpm_otro_rec;

    String ocm_hh = '';
    String ocm_cp = '';
    if(nn ==0){
       ocm_hh= cor.toString();
       ocm_cp= cp.toString();
    }else{
      ocm_hh= ocm_pr_controller.text;
    }
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": codigopro_rec_Provider.rec_numero.toString(),
      "pro_codigo_plu": codigopro_rec_Provider.codpro.toString(),
      "rpm_cantidad": cant_propuesta_controller.text,
      "oco_id": insertar_recepcion.ocoid.toString(),
      "ocm_recepcionados" : ocm_hh.toString(),
    }).timeout(const Duration(seconds: 7));
    print("updateDetalleCompra" + response.body);
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
  Future<bool> update_remplazo_ocm_ocpm(BuildContext context) async {
    final insertar_recepcion =
    Provider.of<RecepcionProvider>(context, listen: false);
    final codigopro_rec_Provider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "remplazo_ocm_ocpm";
    String our = codigopro_rec_Provider.cantidad_rpm_otro_rec.toString();
    String cor = codigopro_rec_Provider.cantidad_rpm_actual_rec.toString();
    String cp= cant_propuesta_controller.text;
    int nn = codigopro_rec_Provider.cantidad_rpm_otro_rec;

    String ocm_hh = '';
    String ocm_cp = '';
    if(nn ==0){
      ocm_hh= cor.toString();
      //ocm_cp= cant_propuesta_controller.text;
    }else{
      ocm_hh= ocm_pr_controller.text;
      //ocm_cp= resultado_remplazo_controller.text;
    }
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": codigopro_rec_Provider.rec_numero.toString(),
      "pro_codigo_plu": codigopro_rec_Provider.codpro.toString(),
      "cantidad": resultado_remplazo_controller.text,
      "oco_id": insertar_recepcion.ocoid.toString(),
      "ocm_recepcionados" : ocm_hh.toString(),
    }).timeout(const Duration(seconds: 7));
    print("update_remplazo_ocm_ocpm" + response.body);
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
      "pro_codigo_plu": cod_provaider.codpro.toString(),
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
  Future<bool> update_leido(BuildContext context) async {
    final insertar_recepcion =
    Provider.of<RecepcionProvider>(context, listen: false);
    final codigopro_rec_Provider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "actualiza_leido";
    String our = codigopro_rec_Provider.cantidad_rpm_otro_rec.toString();
    String cor = codigopro_rec_Provider.cantidad_rpm_actual_rec.toString();
    String cp= cant_propuesta_controller.text;
    int nn = codigopro_rec_Provider.cantidad_rpm_otro_rec;

    String ocm_hh = '';
    String ocm_cp = '';
    if(nn ==0){
      ocm_hh= cor.toString();
      ocm_cp= cp.toString();
      print("IF $ocm_hh" );

    }else{
      ocm_hh= ocm_pr_controller.text;
      print("ELSE100 $ocm_hh" );
    }
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": codigopro_rec_Provider.codpro.toString(),
      "oco_id": insertar_recepcion.ocoid.toString(),
      "ocm_recepcionados" : our.toString(),
      "cantidad_actualiza": ocm_hh.toString(),
    }).timeout(const Duration(seconds: 7));
    print("update_leido" + response.body);
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
  Future<bool> elimina_leido_previamente(BuildContext context) async {
    final insertar_recepcion =
    Provider.of<RecepcionProvider>(context, listen: false);
    final cod_provaider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "elimina_pro_previamente_leido";

    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "oco_id": insertar_recepcion.ocoid.toString(),
      "pro_codigo_plu": cod_provaider.codpro.toString(),
      "rec_numero": cod_provaider.rec_numero.toString(),
    }).timeout(const Duration(seconds: 7));
    print("elimina_leido_previamente" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);

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
