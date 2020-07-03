import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:esc_pos_printer/esc_pos_printer.dart';


void main() {
  // debugPaintSizeEnabled = true;
  runApp(ImprimeRecep());
}
class ImprimeRecep extends StatefulWidget {

  @override
  _ImprimeRecepState createState() => _ImprimeRecepState();
}

class _ImprimeRecepState extends State<ImprimeRecep> {

  @override

  Widget build(BuildContext context) {


    Color color = Theme.of(context).primaryColor;
    Widget recepname = Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBox(color, 'Nº RECEPCION')
        ],
      ),
    );

    Widget buttonimprime = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildimprime(color, Icons.print, 'IMPRIMIR')
        ],
      ),
    );
    return MaterialApp(
      title: 'Imprimir Recepcion',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Imprimir Recepcion'),
        ),
        body: ListView(
          children: [
            buttonimprime,
            recepname,
          ],
        ),
      ),
    );
  }

  Column _buildBox(Color color, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText(label),
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 200,
          height: 30,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
          decoration: BoxDecoration(border: Border.all()),
        ),
      ],
    );
  }

  Column _buildimprime(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Icon(icon, color: color),
        IconButton(
          icon: Icon(icon, color: color, semanticLabel: label,),
          iconSize: 150,
          onPressed: () {

              // To discover existing printers in your subnet, consider using
              // ping_discover_network package (https://pub.dev/packages/ping_discover_network).
              // Note that most of ESC/POS printers by default listen on port 9100.
              Printer.connect('10.0.2.2', port: 8000).then((printer) {


                printer.println(
                    'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
                printer.println('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
                    styles: PosStyles(codeTable: PosCodeTable.westEur));
                printer.println('Special 2: blåbærgrød',
                    styles: PosStyles(codeTable: PosCodeTable.westEur));

                printer.println('Bold text', styles: PosStyles(bold: true));
                printer.println('Reverse text', styles: PosStyles(reverse: true));
                printer.println('Underlined text',
                    styles: PosStyles(underline: true), linesAfter: 1);
                printer.println('Align left', styles: PosStyles(align: PosTextAlign.left));
                printer.println('Align center',
                    styles: PosStyles(align: PosTextAlign.center));
                printer.println('Align right',
                    styles: PosStyles(align: PosTextAlign.right), linesAfter: 1);
                printer.printRow([
                  PosColumn(
                    text: 'col3',
                    width: 3,
                    styles: PosStyles(align: PosTextAlign.center, underline: true),
                  ),
                  PosColumn(
                    text: 'col6',
                    width: 6,
                    styles: PosStyles(align: PosTextAlign.center, underline: true),
                  ),
                  PosColumn(
                    text: 'col3',
                    width: 3,
                    styles: PosStyles(align: PosTextAlign.center, underline: true),
                  ),
                ]);
                printer.println('Text size 200%',
                    styles: PosStyles(
                      height: PosTextSize.size2,
                      width: PosTextSize.size2,
                    ));

                // Print image
                //const String filename = './logo.png';
                //final Image image = decodeImage(File(filename).readAsBytesSync());
               // printer.printImage(image);
                // Print image using an alternative (obsolette) command
                // printer.printImageRaster(image);

                // Print barcode
                final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
                printer.printBarcode(Barcode.upcA(barData));

                // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
                // printer.println(
                //   'hello ! 中文字 # world @ éphémère &',
                //   styles: PosStyles(codeTable: PosCodeTable.westEur),
                // );

                printer.cut();
                printer.disconnect();
              }
              );


            print('ssii');
            //Navigator.pushNamed(context, '/imprimerecep');
            // args.usu_nusuario;
          },
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
