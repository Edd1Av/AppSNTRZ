class Proceso {
  String fecha = "";
  String planta = "";
  String presentacion = "";
  dynamic total = 0;
  String lote = "";

  Proceso(String fecha, String planta, String presentacion, dynamic total,
      String lote) {
    this.fecha = fecha;
    this.planta = planta;
    this.presentacion = presentacion;
    this.total = total;
    this.lote = lote;
  }
}
