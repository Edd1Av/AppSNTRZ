class DashboardResponse {
  bool success = false;
  dynamic response = Response();
}

class Response {
  List<DatosEspecie> datosEspecie = [];
  List<DatosCentro> datosCentroAcuicola = [];
  List<DatosMes> datosMesTonelada = [];
  List<DatosDepartamento> datosDepartamento = [];
}

class DatosEspecie {
  int especieId = 0;
  String nombre = "";
  double volumen = 0.0;

  DatosEspecie(int especieId, String nombre, double volumen) {
    this.especieId = especieId;
    this.nombre = nombre;
    this.volumen = volumen;
  }
}

class DatosCentro {
  String centroAcuicola = "";
  dynamic volumen = 0.0;
  dynamic porcentaje = 0.0;
  String provincia = "";
  String departamento = "";

  DatosCentro(String centroAcuicola, dynamic volumen, dynamic porcentaje,
      String provincia, String departamento) {
    this.centroAcuicola = centroAcuicola;
    this.volumen = volumen;
    this.porcentaje = porcentaje;
    this.provincia = provincia;
    this.departamento = departamento;
  }
}

class DatosMes {
  String mes = "";
  double volumen = 0.0;

  DatosMes(String mes, double volumen) {
    this.mes = mes;
    this.volumen = volumen;
  }
}

class DatosDepartamento {
  String nombre = "";
  double volumen = 0.0;

  DatosDepartamento(String nombre, double volumen) {
    this.nombre = nombre;
    this.volumen = volumen;
  }
}
