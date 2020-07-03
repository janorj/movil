import 'package:flutter/material.dart';
import 'package:helpcom/src/pages/busqueda_recepcion.dart';
import 'package:helpcom/src/pages/consulta_producto.dart';
import 'package:helpcom/src/pages/detalle_pack_virtual.dart';
import 'package:helpcom/src/pages/identificacion_documento.dart';
import 'package:helpcom/src/pages/imprime_recepcion.dart';
import 'package:helpcom/src/pages/ingreso_producto.dart';
import 'package:helpcom/src/pages/ingreso_producto_pendiente.dart';
import 'package:helpcom/src/pages/inicio_page.dart';
import 'package:helpcom/src/pages/lista_producto_plantilla.dart';
import 'package:helpcom/src/pages/lista_toma_inventario.dart';
import 'package:helpcom/src/pages/listado_pack_virtual.dart';
import 'package:helpcom/src/pages/listado_product.dart';
import 'package:helpcom/src/pages/login_page.dart';
import 'package:helpcom/src/pages/menu_inventario.dart';
import 'package:helpcom/src/pages/nuevo_inventario.dart';
import 'package:helpcom/src/pages/opciones_recepcion.dart';
import 'package:helpcom/src/pages/producto_grabado.dart';
import 'package:helpcom/src/pages/producto_leido_previamente.dart';
import 'package:helpcom/src/pages/recepciones_pendientes.dart';
import 'package:helpcom/src/pages/seleccion_toma_inventario.dart';
import 'package:helpcom/src/pages/toma_inventario.dart';
import 'package:helpcom/src/pages/venta_producto.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => LoginPage(),
    '/menu': (BuildContext context) => InicioPage(),
    '/busqueda_recepcion': (BuildContext context) => BusquedaRecepcion(),
    '/opciones_recepcion': (BuildContext context) => Opcione_Recepcion(),
    '/identificacion_documento': (BuildContext context) => IdentiDocu(),
    '/ingreso_producto': (BuildContext context) => Ingreso_Procuto(),
    '/listado_producto_grabado': (BuildContext context) =>
        ListadoProductograbado(),
    '/recep_pendientes': (BuildContext context) => RecepPendiente(),
    '/leido_previamente': (BuildContext context) =>
        Producto_Leido_Previamente(),
    '/listadoproducto': (BuildContext context) => ListadoProducto(),
    '/imprimerecep': (BuildContext context) => ImprimeRecep(),
    '/ingreso_producto_pendiente': (BuildContext context) =>
        Ingreso_Producto_pendiente(),
//autogestion sala
    '/consulta_producto': (BuildContext context) => Consulta_Producto(),
    '/venta_producto': (BuildContext context) => Venta_Producto(),
    '/detalle_pack_virtual': (BuildContext context) => Detalle_Pack(),
    '/producto_pack_virtual': (BuildContext context) => PackVirtual(),
//inventario
    '/inventario': (BuildContext context) => Opcionnes_Inventario(),
    '/toma_inventario': (BuildContext context) => Toma_Inventario(),
    '/nuevo_inventario': (BuildContext context) => Nuevo_Inventario(),
    '/seleccion_invetario': (BuildContext context) => Seleccion_Inventario(),
    '/lista_plantilla': (BuildContext context) => Lista_Producto_Plantilla(),
    '/lista_toma_inventario': (BuildContext context) => ListadoTomaInventario(),
  };
}
