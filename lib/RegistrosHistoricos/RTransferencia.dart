import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sanitrazab/Models/transferencia.dart';
import 'package:sanitrazab/RegistrosHistoricos/RSiembra.dart';
import 'package:http/http.dart' as http;

class RTransferencia extends StatefulWidget {
  const RTransferencia({super.key});

  @override
  State<RTransferencia> createState() => RTransferenciaState();
}

class RTransferenciaState extends State<RTransferencia> {
  RowSourceTransferencia datos = RowSourceTransferencia(datos: []);
  bool inicio = true;
  Future<List<Transferencia>>? historicoTransferencia;

  Future<List<Transferencia>> getHistorico() async {
    final response = await http.post(
      Uri.parse(
          'https://dev.sanitrazab.plnmarina.com/api/transferencia/historico'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "filtro": jsonEncode(
            <String, dynamic>{"fechainicio": null, "fechafin": null}),
      }),
    );

    List<Transferencia> rHTransferencia = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        rHTransferencia.add(Transferencia(
            element["fecha"],
            element["centroAcuicola"],
            element["especie"],
            element["cantidadTotal"],
            element["codigoOrigen"],
            element["codigoDestino"]));
      }

      return rHTransferencia;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    historicoTransferencia = getHistorico();
    //hist = getHistorico();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: cuerpo(context, historicoTransferencia),
        appBar: appBarR(context),
        bottomNavigationBar: bottomNav(context, 0));
  }

  Widget cuerpo(BuildContext context, historicoTransferencia) {
    return Container(
      child: Center(
          child: ListView(
        children: <Widget>[
          logo(),
          titulo(),
          FutureBuilder(
            future: historicoTransferencia,
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
    filter(List<Transferencia> d, String value) {
      List<Transferencia> filt = [];
      for (var element in d) {
        if (element.fecha.toUpperCase().contains(value.toUpperCase()) ||
            element.centroAcuicola
                .toUpperCase()
                .contains(value.toUpperCase()) ||
            element.especie.toUpperCase().contains(value.toUpperCase()) ||
            element.cantidadTotal.toString().contains(value) ||
            element.origen.toUpperCase().contains(value.toUpperCase()) ||
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
            label: Text('Centro'),
          ),
          DataColumn(
            label: Text('Especie'),
          ),
          DataColumn(
            label: Text('Cantidad (U)'),
          ),
          DataColumn(
            label: Text('Origen'),
          ),
          DataColumn(
            label: Text('Destino'),
          ),
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
            "REGISTROS HISTÓRICOS DE TRANSFERENCIA",
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

class RowSourceTransferencia extends DataTableSource {
  List<Transferencia> datos;

  RowSourceTransferencia({required this.datos});

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
        width: 200.0,
        child: Text(datos[index].centroAcuicola.toString()),
      )),
      DataCell(Text(datos[index].especie.toString())),
      DataCell(Text(datos[index].cantidadTotal.toString())),
      DataCell(Text(datos[index].origen.toString())),
      DataCell(Text(datos[index].destino.toString()))
    ]);
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
