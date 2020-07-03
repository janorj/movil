import 'dart:convert';
import 'package:helpcom/src/providers/codigo_producto_provider.dart';
import 'package:helpcom/src/providers/recepcion_provider.dart';
import 'package:helpcom/src/providers/inventario_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(new MaterialApp(
    title: "My Apps",
    home: new ListadoTomaInventario(),
  ));
}

class ListadoTomaInventario extends StatelessWidget {
  String rec_numero;
  String pro_codigo_plu='';

  @override
  Widget build(BuildContext context) {
    lista_toma_inventarios(context);
    final codigoproProvider =
    Provider.of<CodigoProductoProvider>(context, listen: false);
    final recepcioProvider =
    Provider.of<RecepcionProvider>(context, listen: false);
    final inventarios_provider =
    Provider.of<InventarioProvider>(context, listen: false);

    //final inventarios_provider = Provider.of<InventarioProvider>(context);
    print(inventarios_provider.nombre_planilla);
    print(inventarios_provider.pla_id);
    print(inventarios_provider.tin_id);



    List<Producto> data = codigoproProvider.listaproduto;

    return Scaffold(
      appBar: AppBar(
        title: new Text("Lista de Productos"),
      ),
      body: new Container(child: lista_Inventarios(context)),
    );
  }

  Future lista_toma_inventarios(BuildContext context) async {
    final inventario_contados =
    Provider.of<InventarioProvider>(context, listen: false);
    var url = DotEnv().env['SERVER'] + "detalle_planilla";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pla_id": inventario_contados.pla_id,
      "tin_id": inventario_contados.tin_id,
    }).timeout(const Duration(seconds: 7));
    print("comprobarProductos"+ response.body);
    switch (response.statusCode) {
      case 200:
        List productos_ingresados = jsonDecode(response.body);

        return productos_ingresados;
        break;
      case 500:
      //Fluttertoast.showToast(msg: jsonDecode(response.body));
        throw Exception("No existen productos grabados");
        break;
      default:
        throw Exception("Error al cargar productos");
        break;
    }
  }

  FutureBuilder lista_Inventarios(BuildContext context) {
    final inventario_contados =
    Provider.of<InventarioProvider>(context, listen: false);
    return FutureBuilder(
      future: lista_toma_inventarios(context),
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
                          "PLU producto: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["pro_codigo_plu"].toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Cod Bar: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["pro_codigo_barra"]
                              .toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Producto: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["pro_nombre_corto"]
                              .toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Med: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["med_nombre"]
                              .toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Cantidad: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["tid_cantidad"]
                              .toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Costo: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["tid_costo"]
                              .toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),


                      ],
                    ),
                  );
                }
            ),
          );
        }
      },
    );
  }

}
