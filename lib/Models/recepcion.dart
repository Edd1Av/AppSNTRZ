class Recepcion {
  String fecha = "";
  String estatus = "";
  String planta = "";
  String centro = "";
  String especie = "";
  double cantidad = 0.0;
  String dec = "";

  Recepcion(String fecha, String estatus, String planta, String centro,
      String especie, double cantidad, String dec) {
    this.fecha = fecha;
    this.estatus = estatus;
    this.planta = planta;
    this.centro = centro;
    this.especie = especie;
    this.cantidad = cantidad;
    this.dec = dec;
  }
}
