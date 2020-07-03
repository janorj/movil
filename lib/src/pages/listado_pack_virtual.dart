import 'dart:convert';
import 'package:helpcom/src/providers/autogestion_sala_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(new MaterialApp(
    title: "My Apps",
    home: new PackVirtual(),
  ));
}

class PackVirtual extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    detalle_Packvirtual(context);


    final auto = Provider.of<AutogetionSala>(context);

    print("ss " + auto.pavid);

    List<Pack> data = auto.listapack;

    return Scaffold(
      appBar: AppBar(
        title: new Text("Pack Virtuales"),
      ),
      body: new Container(child: listaPacks(context)),
    );
  }


  Future detalle_Packvirtual(BuildContext context) async {
    final autogestionProvider = Provider.of<AutogetionSala>(context,
        listen: false);
    var url = DotEnv().env['SERVER'] + "detalle_packvirtual";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pav_id": autogestionProvider.pavid.toString(),
    }).timeout(const Duration(seconds: 7));
    print(response.body);
    switch (response.statusCode) {
      case 200:
        List productos_pack = jsonDecode(response.body);
        return productos_pack;
        break;
      case 500:
        Fluttertoast.showToast(msg: jsonDecode(response.body));
        throw Exception("No existen Pack virtuales");
        break;
      default:
        throw Exception("Error al cargar packs");
        break;
    }
  }

  FutureBuilder listaPacks(BuildContext context) {
    return FutureBuilder(
      future: detalle_Packvirtual(context),
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
                          "Nombre Pack Virtual: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i]["pro_nombre_producto"].toString(),
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
