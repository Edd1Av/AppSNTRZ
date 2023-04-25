import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sanitrazab/Models/despacho.dart';
import 'package:sanitrazab/RegistrosHistoricos/RSiembra.dart';
import 'package:http/http.dart' as http;

class RDespacho extends StatefulWidget {
  const RDespacho({super.key});

  @override
  State<RDespacho> createState() => RDespachoState();
}

class RDespachoState extends State<RDespacho> {
  RowSourceDespacho datos = RowSourceDespacho(datos: []);
  bool inicio = true;
  Future<List<Despacho>>? historicoDespacho;

  Future<List<Despacho>> getHistorico() async {
    final response = await http.post(
      Uri.parse('https://dev.sanitrazab.plnmarina.com/api/despacho/historico'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "filtro": jsonEncode(
            <String, dynamic>{"fechainicio": null, "fechafin": null}),
      }),
    );

    List<Despacho> rHDespacho = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        rHDespacho.add(Despacho(element["fecha"], element["plantaProceso"],
            element["totalDespachadoKg"], element["destino"]));
      }

      return rHDespacho;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    historicoDespacho = getHistorico();
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
            future: historicoDespacho,
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
    filter(List<Despacho> d, String value) {
      List<Despacho> filt = [];
      for (var element in d) {
        if (element.fecha.toUpperCase().contains(value.toUpperCase()) ||
            element.planta.toUpperCase().contains(value.toUpperCase()) ||
            element.total.toString().contains(value) ||
            element.destino.toUpperCase().contains(value.toUpperCase())) {
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
            label: Text('Planta'),
          ),
          DataColumn(
            label: Text('Total (Kg)'),
          ),
          DataColumn(
            label: Text('Destino'),
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
            "REGISTROS HISTÓRICOS DE DESPACHO",
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

class RowSourceDespacho extends DataTableSource {
  List<Despacho> datos;

  RowSourceDespacho({required this.datos});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => datos.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(SizedBox(child: Text(datos[index].fecha.toString()))),
      DataCell(SizedBox(
        width: 200.0,
        child: Text(datos[index].planta.toString()),
      )),
      DataCell(SizedBox(child: Text(datos[index].total.toString()))),
      DataCell(
          SizedBox(width: 200.0, child: Text(datos[index].destino.toString()))),
    ]);
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
