import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:helpcom/src/providers/inventario_provider.dart';
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
  runApp(Seleccion_Inventario());
}

class Seleccion_Inventario extends StatefulWidget {
  @override
  _Seleccion_InventarioState createState() => _Seleccion_InventarioState();
}

class _Seleccion_InventarioState extends State<Seleccion_Inventario> {
  final FocusNode _nodeText1 = FocusNode();
  @override
  int pro_plu;
  String nombre_producto='';
  int pro_unidades_embalaje = 0;
  String emb_nombre='';
  String med_nombre='';
  int dep_id;
  String tid_cantidad;
  int pro_funcion_plu;
  int pro_unidad;

  TextEditingController codproController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController resultado_suma_controller = TextEditingController();
  TextEditingController resultado_resta_controller = TextEditingController();

  bool pVal = false;

  Widget build(BuildContext context) {
    final identiProvider = Provider.of<IdentiDocProvider>(context);
    final inventarios_provider = Provider.of<InventarioProvider>(context);
    print(inventarios_provider.nombre_planilla);
    print(inventarios_provider.pla_id);
    print(inventarios_provider.tin_id);

    Color color = Theme.of(context).primaryColor;

    return MaterialApp(
      title: 'Editar Toma de Inventario',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Editar Toma de Inventario'),
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
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          height: 30,
                          child: Text(
                            'Planilla:' + inventarios_provider.pla_id,
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
                              'Toma Inv:' + inventarios_provider.tin_id,
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
                              'Cant.Cont.Prod.:' + identiProvider.numerodoc,
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
                          final codigoproProvider =
                          Provider.of<CodigoProductoProvider>(context, listen: false);
                         await busqueda_producto_invnetario(codproController.text);

                          if (await busqueda_producto_invnetario(codproController.text) == true && await previamente_prodcuto(context) == false){
                            Fluttertoast.showToast(
                                msg: "PLU no corresponde a toma de inventario",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            limpiarCampos();
                          }else{
                            codigoproProvider.codpro = pro_plu.toString();
                            await cantidad_contados(context);
                            await pesable_contados(context);
                          }

                        },
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
                        onPressed: () async {
                          final codigoproProvider =
                          Provider.of<CodigoProductoProvider>(context, listen: false);
                          var result = await BarcodeScanner.scan();
                          print(result.type); // The result type (barcode, cancelled, failed)
                          print(result.rawContent); // The barcode content
                          print(result.format); // The barcode format (as enum)
                          print(result.formatNote); // If a unknown format was scanned this field cont
                          codproController.text = result.rawContent;
                          //await busqueda_producto_invnetario(codproController.text);
                          //previamente_prodcuto(context);
                          if (await busqueda_producto_invnetario(codproController.text) == true && await previamente_prodcuto(context) == false){
                            Fluttertoast.showToast(
                                msg: "PLU no corresponde a toma de inventario",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            limpiarCampos();
                          }else{
                            codigoproProvider.codpro = pro_plu.toString();
                            await cantidad_contados(context);
                            await pesable_contados(context);
                            double precio_unidad =
                            double.parse(tid_cantidad);
                            print(precio_unidad);
                          }
                        },
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
                            '$nombre_producto',
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
                          "Unidad",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 100,
                          height: 30,
                          child: Text(
                            '$emb_nombre',
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
                  Flexible(child:Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cant X",
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
                          '$pro_unidades_embalaje', //pedido original
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
                  ),),
                ],
              ),
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Flexible(child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Pesable"),
                  Checkbox(
                    value: pVal,
                    onChanged: (bool value) {
                      setState(() {
                        //pVal = value;
                      });
                    },
                  ),
                ],
              ),),

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tipo Emb",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 100,
                          height: 30,
                          child:  Text('$med_nombre'
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
                          "Contados",
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
                          child:
//                          (int.parse(tid_cantidad) == 0) ?
//                          Text('$tid_cantidad',
//                            textAlign: TextAlign.right,
//                            style: TextStyle(
//                              fontSize: 15,
//                              fontWeight: FontWeight.w400,
//                                color: color
//                            ),
//                          )
//                              :
                          Text('$tid_cantidad',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.pink,
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
                          //cantidadController
                          child:
                          TextField(
                            // keyboardType: TextInputType.number,
                            controller: cantidadController,
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

                              try {
                                double cantidad = double.parse(value);
                                double cantidad_ingresada = double.parse(tid_cantidad);
                                resultado_suma_controller.text =
                                    (cantidad_ingresada + cantidad).toString();
                                resultado_resta_controller.text =
                                    (cantidad_ingresada - cantidad).toString();



                              } catch (e) {
                                resultado_suma_controller.text = "0";
                                resultado_resta_controller.text = "0";
                              }

                            },
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
                          "Total suma",
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
                          child:
                          TextField(
                            controller: resultado_suma_controller,
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
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total resta",
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
                          child:
                          TextField(
                            controller: resultado_resta_controller,
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
                      //Icon(icon, color: color),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushNamed(context, '/productorecep');
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Icon(icon, color: color),
                      IconButton(
                        icon: Icon(
                          Icons.list,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushNamed(context, '/lista_toma_inventario');


                          final inventario_contados =
                          Provider.of<InventarioProvider>(context, listen: false);

                          inventario_contados.pla_id = inventarios_provider.pla_id;
                          inventarios_provider.tin_id;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Listar",
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
                          Icons.library_add,
                          color: Colors.green,
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          previamente_prodcuto(context);
                          if(cantidadController.text==''){
                            Fluttertoast.showToast(
                                msg: "No se ha ingresado cantidad",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }else if(double.tryParse(tid_cantidad)== 0){
                            update_toma_inventario_sincontar(context);
                            Fluttertoast.showToast(
                                msg: "se acutalizo sin contar",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            limpiarCampos();
                          }
                          else{
                            update_toma_inventario_contado(context);
                            Fluttertoast.showToast(
                                msg: "se actualizo contado",
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
                          Icons.do_not_disturb_on,
                          color: Colors.red,
                        ),
                        iconSize: 30,
                        onPressed: () async {
                          previamente_prodcuto(context);
                          if(cantidadController.text==''){
                            Fluttertoast.showToast(
                                msg: "No se ha ingresado cantidad",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                          }else if(double.tryParse(tid_cantidad)== 0){
                            update_toma_inventario_sincontar(context);
                            Fluttertoast.showToast(
                                msg: "se acutalizo sin contar",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 30.0);
                            limpiarCampos();
                          }
                          else{
                            update_toma_inventario_contado(context);
                            Fluttertoast.showToast(
                                msg: "se actualizo contado",
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
                          "Restar",
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
      codproController.clear();
      cantidadController.clear();
      nombre_producto='';
      tid_cantidad='';
      emb_nombre='';
      pro_unidades_embalaje =0;
      med_nombre='';
      pVal = false;
    });
  }

  Future<bool> busqueda_producto_invnetario(String pro_codigo_plu) async {
    String url = DotEnv().env['SERVER'] + "busqueda_producto_toma";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_codigo_plu,
      "pro_codigo_barra": codproController.text
    }).timeout(const Duration(seconds: 7));
    print('busqueda_producto_invnetario' + response.body);
    switch (response.statusCode) {
      case 200:
      //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          pro_plu = data[0]['pro_codigo_plu'];
          nombre_producto = data[0]['pro_nombre_producto'].toString();
          pro_unidades_embalaje = data[0]['pro_unidades_embalaje'];
          emb_nombre = data[0]['emb_nombre'].toString();
          med_nombre = data[0]['med_nombre'].toString();
          dep_id = data[0]['dep_id'];
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

  Future<bool> cantidad_contados(BuildContext context) async {
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    final inventario_contados =
    Provider.of<InventarioProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "busqueda_contado_toma";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_plu.toString(),
      "pla_id": inventario_contados.pla_id.toString(),
      "tin_id": inventario_contados.tin_id.toString()
    }).timeout(const Duration(seconds: 7));
print('cantidad_contados'+response.body);
    switch (response.statusCode) {
      case 200:
      //Fluttertoast.showToast(msg: response.body.toString());
        var data = jsonDecode(response.body);
        setState(() {
          tid_cantidad = data[0]["tid_cantidad"].toString();
        });
        return true;
      case 500:
      //Fluttertoast.showToast(msg: response.body.toString());
        return false;
        break;
      default:
        return false;
        break;
    }
  }
  Future<bool> pesable_contados(BuildContext context) async {
    String url = DotEnv().env['SERVER'] + "pesable_contado_toma";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_plu.toString(),
    }).timeout(const Duration(seconds: 7));
    print('pesable_contados'+response.body);
    switch (response.statusCode) {
      case 200:
        var data = jsonDecode(response.body);
        if (data[0]['pro_funcion_plu'] == 1 &&
            data[0]['pro_unidad'] == 1) {
          setState(() {
            pVal = true;
          });
        } else {
          setState(() {
            pVal = false;
          });
        }
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
  Future<bool> previamente_prodcuto(BuildContext context) async {
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    final inventario_contados =
    Provider.of<InventarioProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "previamante_toma_inventario";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_plu.toString(),
      "pla_id": inventario_contados.pla_id.toString(),
      "tin_id": inventario_contados.tin_id.toString()
    }).timeout(const Duration(seconds: 7));
    print('previamente_prodcuto'+response.body);
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

  Future<bool> update_toma_inventario_sincontar(BuildContext context) async {
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    final inventario_contados =
    Provider.of<InventarioProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "actualiza_toma_inventario_sincontar";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_plu.toString(),
      "pla_id": inventario_contados.pla_id.toString(),
      "tin_id": inventario_contados.tin_id.toString(),
      "tid_cantidad": cantidadController.text,
    }).timeout(const Duration(seconds: 7));
    print('update_toma_inventario_sincontar'+response.body);
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
  Future<bool> update_toma_inventario_contado(BuildContext context) async {
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    final inventario_contados =
    Provider.of<InventarioProvider>(context, listen: false);
    String url = DotEnv().env['SERVER'] + "actualiza_toma_inventario_contado";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pro_codigo_plu": pro_plu.toString(),
      "pla_id": inventario_contados.pla_id.toString(),
      "tin_id": inventario_contados.tin_id.toString(),
      "tid_cantidad": tid_cantidad.toString(),
      "cantidad": cantidadController.text,
    }).timeout(const Duration(seconds: 7));
    print('update_toma_inventario_contado'+response.body);
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
