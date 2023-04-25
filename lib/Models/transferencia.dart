class Transferencia {
  String fecha = "";
  String centroAcuicola = "";
  String especie = "";
  int cantidadTotal = 0;
  String origen = "";
  String destino = "";

  Transferencia(String fecha, String centroAcuicola, String especie,
      int cantidadTotal, String origen, String destino) {
    this.fecha = fecha;
    this.centroAcuicola = centroAcuicola;
    this.especie = especie;
    this.cantidadTotal = cantidadTotal;
    this.origen = origen;
    this.destino = destino;
  }
}
