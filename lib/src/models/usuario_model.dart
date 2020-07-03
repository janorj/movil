class UsuarioModel {
  int _id;
  String _nombre;
  String _sucursal;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get nombre => _nombre;

  String get sucursal => _sucursal;

  set sucursal(String value) {
    _sucursal = value;
  }

  set nombre(String value) {
    _nombre = value;
  }


}