class Cosecha {
  String fecha = "";
  String centroAcuicola = "";
  String especie = "";
  double cantidadTotal = 0.0;
  String destino = "";
  String dec = "";

  Cosecha(String fecha, String centroAcuicola, String especie,
      double cantidadTotal, String destino, String dec) {
    this.fecha = fecha;
    this.centroAcuicola = centroAcuicola;
    this.especie = especie;
    this.cantidadTotal = cantidadTotal;
    this.destino = destino;
    this.dec = dec;
  }
}
