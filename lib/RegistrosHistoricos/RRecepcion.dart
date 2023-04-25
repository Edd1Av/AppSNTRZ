import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sanitrazab/Models/recepcion.dart';
import 'package:sanitrazab/RegistrosHistoricos/RSiembra.dart';
import 'package:http/http.dart' as http;

class RRecepcion extends StatefulWidget {
  const RRecepcion({super.key});

  @override
  State<RRecepcion> createState() => RRecepcionState();
}

class RRecepcionState extends State<RRecepcion> {
  RowSourceRecepcion datos = RowSourceRecepcion(datos: []);
  bool inicio = true;
  Future<List<Recepcion>>? historicoRecepcion;

  Future<List<Recepcion>> getHistorico() async {
    final response = await http.post(
      Uri.parse('https://dev.sanitrazab.plnmarina.com/api/recepcion/historico'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "filtro": jsonEncode(
            <String, dynamic>{"fechainicio": null, "fechafin": null}),
      }),
    );

    List<Recepcion> rHRecepcion = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        rHRecepcion.add(Recepcion(
            element["fechaRecepcion"] ?? "",
            element["statusNombre"],
            element["despacho"],
            element["centroCultivo"],
            element["producto"],
            element["volumen"],
            element["dec"]));
      }

      return rHRecepcion;

      // Iterable list = json.decode(response.body);
      // RHSiembras = list.map((model) => Siembra.fromJson(model)).toList();
      // return RHSiembras;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    historicoRecepcion = getHistorico();
    //hist = getHistorico();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: cuerpo(context),
        appBar: appBarR(context),
        bottomNavigationBar: bottomNav(context, 0));
  }

  Widget cuerpo(context) {
    return Container(
      child: Center(
          child: ListView(
        children: <Widget>[
          logo(),
          titulo(),
          FutureBuilder(
            future: historicoRecepcion,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return dataTable(context, snapshot.data);
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      )),
    );
  }

  Widget dataTable(BuildContext context, rH) {
    filter(List<Recepcion> d, String value) {
      List<Recepcion> filt = [];
      for (var element in d) {
        if (element.fecha.toUpperCase().contains(value.toUpperCase()) ||
            element.estatus.toUpperCase().contains(value.toUpperCase()) ||
            element.planta.toUpperCase().contains(value.toUpperCase()) ||
            element.centro.toUpperCase().contains(value.toUpperCase()) ||
            element.especie.toUpperCase().contains(value.toUpperCase()) ||
            element.cantidad.toString().contains(value) ||
            element.dec.toUpperCase().contains(value.toUpperCase())) {
          filt.add(element);
        }
      }
      return filt;
    }

    if (inicio) {
      datos.datos = rH;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: PaginatedDataTable(
        initialFirstRowIndex: 0,
        source: datos,
        showFirstLastButtons: true,
        showCheckboxColumn: true,
        header: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: TextField(
            decoration: const InputDecoration(hintText: "Buscar ..."),
            onChanged: (value) {
              setState(() {
                inicio = false;
                datos.datos = filter(rH, value);
                datos.notifyListeners();
              });
            },
          ),
        ),
        columns: const [
          // Set the name of the column
          DataColumn(
            label: Text('Fecha'),
          ),
          DataColumn(
            label: Text('Estatus'),
          ),
          DataColumn(
            label: Text('Planta'),
          ),
          DataColumn(
            label: Text('Centro Cultivo'),
          ),
          DataColumn(
            label: Text('Especie'),
          ),
          DataColumn(
            label: Text('Cantidad (Kg)'),
          ),
          DataColumn(
            label: Text('Dec'),
          )
        ],
        rowsPerPage: 8,
      ),
    );
    //);
  }
}

Widget titulo() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: const Icon(
            Icons.square,
            color: Color(0xFFff8d4d),
          ),
        ),
        const Flexible(
          child: Text(
            "REGISTROS HISTÓRICOS DE RECEPCIÓN",
            style: TextStyle(
              color: Color(0xFF0d3d75),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

class RowSourceRecepcion extends DataTableSource {
  List<Recepcion> datos;

  RowSourceRecepcion({required this.datos});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => datos.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(datos[index].fecha.toString())),
      DataCell(SizedBox(
        child: Text(datos[index].estatus.toString()),
      )),
      DataCell(
          SizedBox(width: 200.0, child: Text(datos[index].planta.toString()))),
      DataCell(
          SizedBox(width: 200.0, child: Text(datos[index].centro.toString()))),
      DataCell(Text(datos[index].especie.toString())),
      DataCell(Text(datos[index].cantidad.toString())),
      DataCell(Text(datos[index].dec.toString()))
    ]);
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
