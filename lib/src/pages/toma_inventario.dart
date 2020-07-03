import 'dart:convert';
import 'dart:ui';
import 'package:helpcom/src/models/tipo_planilla.dart';
import 'package:helpcom/src/providers/inventario_provider.dart';
import 'package:helpcom/src/utils/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:provider/provider.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(Toma_Inventario());
}

class Toma_Inventario extends StatefulWidget {

  @override
  _Toma_InventarioState createState() => _Toma_InventarioState();
}

class _Toma_InventarioState extends State<Toma_Inventario> {

  List tiposPLanillas = List();
  List<DropdownMenuItem> _items;
  List tiposPLanillas_plaid = List();
  TipoPlanilla seleccionado;

  @override
  void initState() {
    seleccion_toma_inventario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final inventarios_provider = Provider.of<InventarioProvider>(context);
    Color color = Theme
        .of(context)
        .primaryColor;

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('th', 'TH'), // Thai
      ],
      title: 'Toma Inventario',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Toma Inventario'),
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
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text("Plantilla"),
                    DropdownButton(

                      value: seleccionado,
                      hint: Text("TODOS"),
                      items: _items,

                      onChanged: (value) {
                        setState(() {
                          seleccionado = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),

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
                          "Tomas Inventarios",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: color,
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(child: grilla_inventario(context)),
                        //Container(child: xd(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (seleccionado == null) ?
                      IconButton(
                        icon: Icon(
                          Icons.chrome_reader_mode,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () {

                        },
                      ):
                      IconButton(
                        icon: Icon(
                          Icons.chrome_reader_mode,
                          color: color,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushNamed(context, '/nuevo_inventario');
                          inventarios_provider.pla_id = seleccionado.pla_id.toString();
                          inventarios_provider.nombre_planilla = seleccionado.pla_observacion.toString();

                        },
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Nuevo",
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

  Future seleccion_toma_inventario() async {
    String url = DotEnv().env['SERVER'] + "seleccion_lista";
    var response = await http.post(
      url,
      headers: {"Accept": "application/json"},
    ).timeout(const Duration(seconds: 7));
    switch (response.statusCode) {
      case 200:
        List data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          TipoPlanilla tiposPlanilla = TipoPlanilla();
          tiposPlanilla.pla_id = data[i]["pla_id"];
          tiposPlanilla.pla_observacion = data[i]["pla_observacion"];
          tiposPLanillas.add(tiposPlanilla);
        }
        List<DropdownMenuItem> items = new List();
        for (TipoPlanilla tiposPLanillas in tiposPLanillas) {
          items.add(
            new DropdownMenuItem(
                value: tiposPLanillas,
                child: Text(tiposPLanillas.pla_observacion)
            ),
          );
        }
        setState(() {
          _items = items;
        });
        break;
      case 500:
        //Fluttertoast.showToast(msg: response.body.toString());
        break;
      default:
        break;
    }
  }

  Future grilla_toma_inventario_todo(BuildContext context) async {
    var url = DotEnv().env['SERVER'] + "grilla_toma_inventario_todo";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {

    }).timeout(const Duration(seconds: 7));
    //print('YO NO FUI'+response.body);
    switch (response.statusCode) {
      case 200:
        List toma_inventarios = jsonDecode(response.body);

        return toma_inventarios;
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
  Future grilla_toma_inventario(BuildContext context) async {
    var url = DotEnv().env['SERVER'] + "grilla_toma_inventario";
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "pla_id": '${seleccionado.pla_id}',
    }).timeout(const Duration(seconds: 7));

    switch (response.statusCode) {
      case 200:
        List toma_inventarios = jsonDecode(response.body);
        return toma_inventarios;
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

  FutureBuilder grilla_inventario(BuildContext context) {
    return
      (seleccionado == null) ?
      FutureBuilder(
        future: grilla_toma_inventario_todo(context),
        builder: (_, snapshot) {
          if (ConnectionState.waiting == snapshot.connectionState) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("No existen productos grabadosxxx");
          } else {
            List data = snapshot.data;
            return Container (
              padding: const EdgeInsets.all(32),
              child:
              InkWell(
                child:
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FittedBox(
                    child: DataTable(


                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'ID',
                            style: TextStyle(fontStyle: FontStyle.italic),

                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nº PLA',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'NOMBRE',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: IconButton(
                            icon: Icon(
                              Icons.check_box,
                            ),
                            iconSize: 25,
                          ),
                        ),
                      ],
                      rows: data.map((inventarios_grilla) =>
                          DataRow(
                              cells: [
                                DataCell(
                                    Text(inventarios_grilla['tin_id'].toString()),
                                ),
                                DataCell(
                                  Text(inventarios_grilla['pla_id'].toString()),
                                ),
                                DataCell(
                                  Text(inventarios_grilla['tin_observacion'].toString()),
                                ),
                                DataCell(
                                  Icon(
                                    Icons.check_box,
                                  ),
                                    onTap: (){
                                      Navigator.pushNamed(
                                          context, '/seleccion_invetario');
                                      final inventarios_provider_select =
                                      Provider.of<InventarioProvider>(context, listen: false);
                                      inventarios_provider_select.tin_id = inventarios_grilla['tin_id'].toString();
                                      inventarios_provider_select.pla_id = inventarios_grilla['pla_id'].toString();
                                      inventarios_provider_select.nombre_planilla = inventarios_grilla['tin_observacion'].toString();
                                      print(inventarios_provider_select.nombre_planilla);

                                    }
                                ),
                              ],
                          )
                      ).toList(),
                    ),
                  ),
                ),
              ),

            );
          }
        },
      ):

      FutureBuilder(
      future: grilla_toma_inventario(context),
      builder: (_, snapshot) {
        if (ConnectionState.waiting == snapshot.connectionState) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("No existen productos grabadosyyy");
        } else {
          List data = snapshot.data;
          return
            Container(
              child:
              InkWell(
                  child: SingleChildScrollView(
                    child: FittedBox(
                      child: DataTable(

                        columns: const <DataColumn>
                        [
                            DataColumn(
                            label: Text(
                              'ID',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'Nº PLA',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'NOMBRE',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: IconButton(
                              icon: Icon(
                                Icons.check_box,
                              ),
                              iconSize: 25,
                            ),
                          ),
                        ],

                        rows: data.map((inventarios_grilla) =>
                            DataRow(
                                cells: [
                                  DataCell(
                                      Text(inventarios_grilla['tin_id'].toString()),
                                  ),
                                  DataCell(
                                    Text(inventarios_grilla['pla_id'].toString()),
                                  ),
                                  DataCell(
                                    Text(inventarios_grilla['tin_observacion'].toString()),
                                  ),
                                  DataCell(
                                      Icon(
                                        Icons.check_box,
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/seleccion_invetario');
                                        final inventarios_provider_select =
                                        Provider.of<InventarioProvider>(context, listen: false);
                                        inventarios_provider_select.tin_id = inventarios_grilla['tin_id'].toString();
                                        inventarios_provider_select.pla_id = inventarios_grilla['pla_id'].toString();
                                        inventarios_provider_select.nombre_planilla = inventarios_grilla['tin_observacion'].toString();
                                        print(inventarios_provider_select.nombre_planilla);

                                      }
                                  ),
                                ],
                            ),
                        ).toList(),
                      ),
                    ),
                  )
              ),
            );
      }
      },
    );
  }
}