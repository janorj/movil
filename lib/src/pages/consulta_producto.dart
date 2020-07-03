import 'dart:async';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:helpcom/src/providers/codigo_producto_provider.dart';
import 'package:helpcom/src/providers/autogestion_sala_provider.dart';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;
void main() {
  // debugPaintSizeEnabled = true;
  runApp(Consulta_Producto());
}

class Consulta_Producto extends StatefulWidget {
  @override
  _Consulta_ProductoState createState() => _Consulta_ProductoState();
}

class _Consulta_ProductoState extends State<Consulta_Producto> {
  final FocusNode _nodeText1 = FocusNode();

  @override

  String pro_plu = '';
  String pro_codigo_barra;

  String nombre_producto = '';
  String marca_producto = '';
  String saldo = '';
  String margen = '';
  String oferta = '';
  String precio_oferta = '';
  String cantidad_transito = '';
  String precio_compra = '';
  String pro_precio_fiscal = '';

  String cantidad_packvirtual = '';

  String cantidad_boleta = '';
  String cantidad_factura = '';
  String cantidad_nota_credito = '';

  String pro_fecha_inicio_oferta = '';
  String pro_fecha_termino_oferta = '';

//en uso
  int rec_numero;
  int fco_id;

  String valor_total_recepcion;
  String pro_codigo_plu;


  String pro_codigo_plu_ex;
  String pro_codigo_plu_grabados;
  double pendiente;

  String pav_id='';

  TextEditingController codproController = TextEditingController();
  TextEditingController pendiente_controller = TextEditingController();
  TextEditingController rpm_cantidad = TextEditingController();
  TextEditingController total_valor_producto = TextEditingController();
  TextEditingController packvtController = TextEditingController();
  TextEditingController dohController = TextEditingController();
  TextEditingController pav_controller= TextEditingController();

  bool pVal = false;
  double dp_total_ventas;
  double percentage = 0.0;

  Widget build(BuildContext context) {
    final autogetion_Provider = Provider.of<AutogetionSala>(context);
    final codigoproProvider = Provider.of<CodigoProductoProvider>(context);
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

    Color color = Theme.of(context).primaryColor;

    return MaterialApp(
      title: 'Consulta Producto',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Consulta Producto'),
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

                          if (codproController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Ingrese codigo del producto",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }

                          else {
                            //pr.show();
                            //Future.delayed(Duration(seconds: 1));
                            pr.show();
                            Future.delayed(Duration(seconds: 2)).then((onValue) async {
                              if(pr.isShowing())
                                busquedaCod(codproController.text);
                              print(pro_plu);
                              calculoTrasporte(codproController.text);

                              await totalBoleta(codproController.text);
                              await totalFactura(codproController.text);
                              await totalNotaCredito(codproController.text);
                              await totalPkVirtual(codproController.text);
                              pav_controller.text = (pav_id).toString();

                              try {
                                double totalboletas =
                                double.parse(cantidad_boleta);
                                double totalfacturas =
                                double.parse(cantidad_factura);
                                double totalnotascredito =
                                double.parse(cantidad_nota_credito);
                                print("totalboletas $totalboletas");
                                print("totalfacturas $totalfacturas");
                                print("totalnotascredito $totalnotascredito");

                                double stock = double.parse(saldo);
                                print("stock $stock");
                                double preciocompras =
                                double.parse(precio_compra);
                                print("preciocompras $preciocompras");

                                double totalventas =
                                ((totalboletas + totalfacturas) -
                                    totalnotascredito);
                                dp_total_ventas = totalventas / 30;
                                print("dp_total_ventas $dp_total_ventas");

                                double diainventario = ((stock * preciocompras) /
                                    (totalventas / 90));
                                double x = diainventario;
                                String roundedX = x.toStringAsFixed(1);
                                print("redon $roundedX");

                                double cantidad_virtual =
                                double.parse(cantidad_packvirtual);
                                print("virtualcantidad $cantidad_virtual");

                                packvtController.text =
                                    (cantidad_virtual).toString();
                                dohController.text = (roundedX).toString();
                              } catch (e) {
                                dohController.text = "0";
                              }
                              pr.hide();
                            }
                            );
                          }
                          //pr.hide();
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
                        ),
                        iconSize: 25,

                        onPressed: () async{
                         // Navigator.pushNamed(context, '/prueba');
                          var result = await BarcodeScanner.scan();

                          print(result.type); // The result type (barcode, cancelled, failed)
                          print(result.rawContent); // The barcode content
                          print(result.format); // The barcode format (as enum)
                          print(result.formatNote); // If a unknown format was scanned this field cont
                          codproController.text = result.rawContent;
                          print("Codigoxxttxx: "+codproController.text);
                          busquedaCod(codproController.text);

                          print(pro_plu);
                          calculoTrasporte(codproController.text);
                          await totalBoleta(codproController.text);
                          await totalFactura(codproController.text);
                          await totalNotaCredito(codproController.text);
                          await totalPkVirtual(codproController.text);
                          pav_controller.text = (pav_id).toString();
                          try {
                            double totalboletas =
                            double.parse(cantidad_boleta);
                            double totalfacturas =
                            double.parse(cantidad_factura);
                            double totalnotascredito =
                            double.parse(cantidad_nota_credito);
                            print("totalboletas $totalboletas");
                            print("totalfacturas $totalfacturas");
                            print("totalnotascredito $totalnotascredito");

                            double stock = double.parse(saldo);
                            print("stock $stock");
                            double preciocompras =
                            double.parse(precio_compra);
                            print("preciocompras $preciocompras");

                            double totalventas =
                            ((totalboletas + totalfacturas) -
                                totalnotascredito);
                            dp_total_ventas = totalventas / 30;
                            print("dp_total_ventas $dp_total_ventas");

                            double diainventario = ((stock * preciocompras) /
                                (totalventas / 90));
                            double x = diainventario;
                            String roundedX = x.toStringAsFixed(1);
                            print("redon $roundedX");

                            double cantidad_virtual =
                            double.parse(cantidad_packvirtual);
                            print("virtualcantidad $cantidad_virtual");

                            packvtController.text =
                                (cantidad_virtual).toString();
                            dohController.text = (roundedX).toString();
                          } catch (e) {
                            dohController.text = "0";
                          }
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
                          "Descripcion Producto",
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
                            ' $nombre_producto',
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Marca",
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
                          '$marca_producto',
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
                          "Mercaderia en Transito",
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
                            '$cantidad_transito',
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Stock",
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
                          '$saldo ',
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
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Margen",
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
                            '$margen ',
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
                          "Precio",
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
                            '$pro_precio_fiscal ',
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
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "PK Virtual",
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
                          child: (double.tryParse(cantidad_packvirtual) != null)
                              ? Text(
                                  'SI',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: color,
                                  ),
                                )
                              : Text(
                                  '',
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
                          child: Text(
                            '$cantidad_packvirtual ',
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
              height: 10,
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
                          "DOH",
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
                            controller: dohController,
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
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Oferta",
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
                            '$oferta ',
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
                          "\$",
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
                            '$precio_oferta ',
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
                      //Icon(icon, color: color),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          busqueda_Cap_Sugerido(codproController.text);
                          if (codproController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Ingrese codigo del producto",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else if (await busqueda_Cap_Sugerido
                            (codproController.text) == true  ) {
                            Fluttertoast.showToast(
                                msg: "Producto ya sugerido",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else if(pro_plu != codproController.text && pro_codigo_barra != codproController.text){
                            Fluttertoast.showToast(
                                msg: "plu no corresponde a los datos",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }else if(codproController.text == pro_plu || codproController.text == pro_codigo_barra){
                            insertar_cap_sugerido(codproController.text);
                            Fluttertoast.showToast(
                                msg: "Sugerido",
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
                          "Sugerido",
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
                          Icons.local_grocery_store,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          if (codproController.text == "" ) {
                            Fluttertoast.showToast(
                                msg: "Ingrese codigo del producto",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else if(nombre_producto.isEmpty){
                            Fluttertoast.showToast(
                                msg: "Buscar codigo ingresado",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else if( pro_plu != codproController.text && pro_codigo_barra != codproController.text){
                            Fluttertoast.showToast(
                                msg: "plu no corresponde a los datos",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }else if(codproController.text == pro_plu || codproController.text == pro_codigo_barra){
                          Navigator.pushNamed(context, '/venta_producto');
                          codigoproProvider.codpro = pro_plu.toString();
                          autogetion_Provider.pavid = pav_controller.text;
                          autogetion_Provider.profechainicio = pro_fecha_inicio_oferta.toString();
                          autogetion_Provider.profechafin = pro_fecha_termino_oferta.toString();
                          autogetion_Provider.propreciofiscal = pro_precio_fiscal.toString();
                          autogetion_Provider.cantidadpackvirtual = cantidad_packvirtual.toString();
                          }

                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Venta",
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
                          Icons.insert_comment,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          busqueda_Fleje_unit(codproController.text);
                          if (codproController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Ingrese codigo del producto",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else if (await busqueda_Fleje_unit
                            (codproController.text) == true  ) {
                            Fluttertoast.showToast(
                                msg: "Fleje ya ingresado para este producto",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          } else if(pro_plu != codproController.text && pro_codigo_barra != codproController.text){
                              Fluttertoast.showToast(
                                  msg: "plu no corresponde a los datos",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 30.0);
                          }else if(codproController.text == pro_plu || codproController.text == pro_codigo_barra){
                            insertar_Flejeunit(context);
                            Fluttertoast.showToast(
                                msg: "Fleje ingresado",
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
                          "Fleje Unit",
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
                        onPressed: () {
                          //Navigator.pushNamed(context, '/menu');
                          Navigator.of(context).pop();
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
      pro_precio_fiscal = '';
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
    print('busquedaCod' + response.body);
    print('busquedaCodcontrolle' + codproController.text);
    switch (response.statusCode) {
      case 200:
        //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          pro_plu = data['pro_codigo_plu'].toString();
          pro_codigo_barra = data['pro_codigo_barra'].toString();
          nombre_producto = data['pro_nombre_producto'].toString();
          marca_producto = data["mae_marca"]['mar_nombre'].toString();
          saldo = data['saldo'].toString();
          margen = data['pro_margen_actual'].toString();
          oferta = data['pro_oferta'].toString();
          precio_oferta = data['pro_precio_oferta'].toString();
          precio_compra = data['pro_precio_compra_bruto'].toString();
          pro_precio_fiscal = data['pro_precio_fiscal'].toString();
          pro_fecha_inicio_oferta = data['pro_fecha_inicio_oferta'].toString();
          pro_fecha_termino_oferta =
              data['pro_fecha_termino_oferta'].toString();
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
        //Fluttertoast.showToast(msg: response.body.toString());
        //limpiarCampos();
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
        //Fluttertoast.showToast(msg: response.body.toString());
        //limpiarCampos();
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
        //Fluttertoast.showToast(msg: response.body.toString());
        //limpiarCampos();
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
      "pro_codigo_plu": pro_plu.toString(),
      "usu_nusuario": globals.usuarioLogeado.nombre,
    }).timeout(const Duration(seconds: 7));
    //print("update_orden_compra" + response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        //pro_codigo_plu = data;
        //limpiarCampos();
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
        //Fluttertoast.showToast(msg: response.body.toString());
        //limpiarCampos();
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
          pav_id = data[0]['pav_id'].toString();
        });
        return true;
        break;
      case 500:
        //Fluttertoast.showToast(msg: response.body.toString());
        //limpiarCampos();
        return false;
        break;
      default:
        return false;
        break;
    }
  }

  Future<bool> busqueda_Fleje_unit(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "busqueda_fleje_unit";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_codigo_plu,
    }).timeout(const Duration(seconds: 7));
    print('busqueda_Fleje_unit' + response.body);
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

  Future<bool> insertar_Flejeunit(BuildContext context) async {
    final codigopro_rec_Provider =
        Provider.of<CodigoProductoProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "insertar_fleje_unit";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_plu.toString(),
      "fle_precio": pro_precio_fiscal.toString(),
      "fle_cantidad": '1',
      "efl_id": '0',
      "usu_nusuario": globals.usuarioLogeado.nombre,
    }).timeout(const Duration(seconds: 7));
    print("insertar_Flejeunit" + response.body);
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