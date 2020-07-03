import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  String titulo;
  CustomAppBar(this.titulo);

  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      backgroundColor: Colors.indigo,

    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(55);


}