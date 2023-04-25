import 'package:flutter/material.dart';
import 'package:sanitrazab/RegistrosHistoricos/RSiembra.dart';
import 'package:sanitrazab/ReportesSanidad/RFarmacovigilancia.dart';

class RDesinfeccionOvas extends StatefulWidget {
  const RDesinfeccionOvas({super.key});

  @override
  State<RDesinfeccionOvas> createState() => RDesinfeccionOvasState();
}

class RDesinfeccionOvasState extends State<RDesinfeccionOvas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: cuerpo(context),
        appBar: appBarRS(context),
        bottomNavigationBar: bottomNav(context, 1));
  }
}

Widget cuerpo(context) {
  return Container(
    child: Center(
        child: ListView(
      children: <Widget>[logo(), titulo(), dataTable()],
    )),
  );
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
            "REPORTE DE DESINFECCIÓN DE OVAS",
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

Widget dataTable() {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      scrollDirection: Axis.horizontal,
      child: DataTable(
          // Datatable widget that have the property columns and rows.
          columns: const [
            // Set the name of the column
            DataColumn(
              label: Text('Centro'),
            ),
            DataColumn(
              label: Text('Resolición directoral'),
            ),
            DataColumn(
              label: Text('Fecha'),
            ),
            DataColumn(
              label: Text('Especie'),
            ),
          ], rows: const [
        // Set the values to the columns
        DataRow(cells: [
          DataCell(Text("29/09/2022")),
          DataCell(Text("CA langostinos Perú")),
          DataCell(Text("Langostino")),
          DataCell(Text("1000")),
        ]),
        DataRow(cells: [
          DataCell(Text("06/01/2022")),
          DataCell(Text("Langostinera Rio Tumbes EIRL")),
          DataCell(Text("Langostino")),
          DataCell(Text("200,000")),
        ]),
      ]),
    ),
  );
}
