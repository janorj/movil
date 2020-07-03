import 'package:helpcom/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:helpcom/src/providers/recepcion_provider.dart';
import 'package:helpcom/src/providers/identificacion_documento_provider.dart';
import 'package:helpcom/src/providers/codigo_producto_provider.dart';
import 'package:helpcom/src/providers/autogestion_sala_provider.dart';
import 'package:helpcom/src/providers/inventario_provider.dart';

Future main() async{
  await DotEnv().load('.env');
  runApp(MaterialApp(
    home: MiApp(),
  ));
}
class MiApp extends StatelessWidget {
  //RecepcionProvider variable;
  //IdentiDocProvider iden;

  @override

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<RecepcionProvider>(
          create: (context){
            return RecepcionProvider();
          },
        ),

        ChangeNotifierProvider<IdentiDocProvider>(
          create: (context){
            return IdentiDocProvider();
          },
        ),
        ChangeNotifierProvider<CodigoProductoProvider>(
          create: (context){
            return CodigoProductoProvider();
          },
        ),
        ChangeNotifierProvider<AutogetionSala>(
          create: (context){
            return AutogetionSala();
          },
        ),
        ChangeNotifierProvider<InventarioProvider>(
          create: (context){
            return InventarioProvider();
          },
        )
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: getApplicationRoutes(),
      ),
    );
  }
}
