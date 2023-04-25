import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sanitrazab/Models/cosecha.dart';
import 'package:sanitrazab/RegistrosHistoricos/RSiembra.dart';
import 'package:http/http.dart' as http;

class RCosecha extends StatefulWidget {
  const RCosecha({super.key});

  @override
  State<RCosecha> createState() => RCosechaState();
}

class RCosechaState extends State<RCosecha> {
  RowSourceCosecha datos = RowSourceCosecha(datos: []);
  bool inicio = true;
  Future<List<Cosecha>>? historicoCosecha;

  Future<List<Cosecha>> getHistorico() async {
    final response = await http.post(
      Uri.parse('https://dev.sanitrazab.plnmarina.com/api/cosecha/historico'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "filtro": jsonEncode(
            <String, dynamic>{"fechainicio": null, "fechafin": null}),
      }),
    );

    List<Cosecha> rHCosecha = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        rHCosecha.add(Cosecha(
            element["fecha"],
            element["organizacion"],
            element["producto"],
            element["volumen"],
            element["despacho"],
            element["dec"]));
      }

      return rHCosecha;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    historicoCosecha = getHistorico();
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
            future: historicoCosecha,
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
    filter(List<Cosecha> d, String value) {
      List<Cosecha> filt = [];
      for (var element in d) {
        if (element.fecha.toUpperCase().contains(value.toUpperCase()) ||
            element.centroAcuicola
                .toUpperCase()
                .contains(value.toUpperCase()) ||
            element.especie.toUpperCase().contains(value.toUpperCase()) ||
            element.cantidadTotal.toString().contains(value) ||
            element.destino.toUpperCase().contains(value.toUpperCase()) ||
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
                print(value);
                datos.datos = filter(rH, value);
                print(datos.datos.length);
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
            label: Text('Cantidad (Kg)'),
          ),
          DataColumn(
            label: Text('Destino'),
          ),
          DataColumn(
            label: Text('DEC'),
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
            "REGISTROS HISTÓRICOS DE COSECHA",
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

class RowSourceCosecha extends DataTableSource {
  List<Cosecha> datos;

  RowSourceCosecha({required this.datos});

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
      DataCell(
          SizedBox(width: 200.0, child: Text(datos[index].destino.toString()))),
      DataCell(Text(datos[index].dec.toString()))
    ]);
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
