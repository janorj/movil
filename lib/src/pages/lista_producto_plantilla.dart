import 'dart:convert';
import 'package:helpcom/src/providers/codigo_producto_provider.dart';
import 'package:helpcom/src/providers/identificacion_documento_provider.dart';
import 'package:helpcom/src/providers/recepcion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(new MaterialApp(
    title: "Lista Producto Plantilla",
    home: new Lista_Producto_Plantilla(),
  ));
}

class Lista_Producto_Plantilla extends StatelessWidget {
  String rec_numero;

  @override
  Widget build(BuildContext context) {
    comprobarProductos(context);
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);

    print("ss " + codigoproProvider.rec_numero);

    List<Producto> data = codigoproProvider.listaproduto;

    return Scaffold(
      appBar: AppBar(
        title: new Text("Lista Producto Plantilla"),
      ),
      body: new Container(child: listaProductos(context)),
    );
  }

  Future comprobarProductos(BuildContext context) async {
    final codigoproProvider = Provider.of<CodigoProductoProvider>(context);
    var url = DotEnv().env['SERVER'] + "selectproductoingresados";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "rec_numero": codigoproProvider.rec_numero.toString(),
    }).timeout(const Duration(seconds: 7));
    //print(response.body);
    switch (response.statusCode) {
      case 200:
        List productos_ingresados = jsonDecode(response.body);
        return productos_ingresados;
        break;
      case 500:
        Fluttertoast.showToast(msg: jsonDecode(response.body));
        throw Exception("No existen productos grabados");
        break;
      default:
        throw Exception("Error al cargar productos");
        break;
    }
  }

  FutureBuilder listaProductos(BuildContext context) {
    return FutureBuilder(
      future: comprobarProductos(context),
      builder: (_, snapshot) {
        if (ConnectionState.waiting == snapshot.connectionState) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("No existen productos grabados");
        } else {
          List data = snapshot.data;
          return Container(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "PLU: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["pro_codigo_plu"].toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Cod.bar: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["mae_productos"]["pro_nombre_corto"]
                              .toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Productos: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["restantes"].toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}
