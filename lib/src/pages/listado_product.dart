import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(ListadoProducto());
}
class ListadoProducto extends StatefulWidget {

  @override
  _ListadoProductoState createState() => _ListadoProductoState();
}
class _ListadoProductoState extends State<ListadoProducto> {


  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Listado de Producto'),
        ),
        body: ListView.builder(

          itemBuilder: (BuildContext context, int index) =>
              EntryItem(data[index]),
          itemCount: data.length,
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'PLU',
    <Entry>[
      Entry('PRODUCTO'),
      Entry('CANT'),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}





