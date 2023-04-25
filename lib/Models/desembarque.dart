class Desembarque {
  String fecha = "";
  String embarcacion = "";
  String matricula = "";
  double total = 0;
  String fechaZarpe = "";

  Desembarque(String fecha, String embarcacion, String matricula, double total,
      String fechaZarpe) {
    this.fecha = fecha;
    this.embarcacion = embarcacion;
    this.matricula = matricula;
    this.total = total;
    this.fechaZarpe = fechaZarpe;
  }
}
