import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sanitrazab/Models/dashboardResponse.dart';
import 'package:sanitrazab/RegistrosHistoricos/RSiembra.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  Future<Response>? dashboardResponse;
  // List<Siembra>? hist;
  // List<Siembra> l = [];

  RowSourceSiembra datos = RowSourceSiembra(datos: []);
  bool inicio = true;

  Future<Response> getHistorico() async {
    final response = await http.post(
      Uri.parse('https://dev.sanitrazab.plnmarina.com/api/dashboard'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "filtro": jsonEncode(
            <String, dynamic>{"fechainicio": null, "fechafin": null}),
      }),
    );

    Response datos = Response();
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData["response"]["datosEspecie"]) {
        datos.datosEspecie.add(DatosEspecie(
            element["especieId"], element["nombre"], element["volumen"] + 0.0));
      }

      for (var element in jsonData["response"]["datosMesTonelada"]) {
        datos.datosMesTonelada
            .add(DatosMes(element["mes"], element["volumen"] + 0.0));
      }

      return datos;

      // Iterable list = json.decode(response.body);
      // RHSiembras = list.map((model) => Siembra.fromJson(model)).toList();
      // return RHSiembras;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    dashboardResponse = getHistorico();
    //hist = getHistorico();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: cuerpo(context),
        appBar: appBarRS(context),
        bottomNavigationBar: bottomNav(context, 3));
  }

  Widget cuerpo(context) {
    return Container(
      child: Center(
          child: ListView(
        children: <Widget>[
          logo(),
          titulo("Producción Mensual (Tn)"),
          FutureBuilder(
            future: dashboardResponse,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    produccionMensual(context, snapshot.data),
                    titulo("Producción por Especie (Tn)"),
                    produccionEspecie(context, snapshot.data)
                  ],
                );
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
}

PreferredSizeWidget appBarRS(context) {
  return AppBar(
    title: const Text("Dashboard"),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.settings),
        tooltip: 'Setting Icon',
        onPressed: () {},
      ),
    ],
    backgroundColor: const Color(0xFF2064b7),
  );
}

Widget titulo(String titulo) {
  return Container(
    decoration: const BoxDecoration(color: Color(0XFF0066b7)),
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
        Flexible(
          child: Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget produccionMensual(context, Response? data) {
  return Container(
    decoration: const BoxDecoration(color: Color(0XFFD9E8F5)),
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    child: AspectRatio(
      aspectRatio: 2,
      child: BarChart(BarChartData(
        backgroundColor: const Color(0XFFD9E8F5),
        borderData: FlBorderData(
            border: const Border(bottom: BorderSide(), left: BorderSide())),
        gridData: FlGridData(show: false),
        groupsSpace: 10,
        barGroups: _chartGroups(data),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: _bottomTitles),
          // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      )),
    ),
  );
}

Widget produccionEspecie(context, Response? data) {
  return Container(
    decoration: const BoxDecoration(color: Color(0XFFD9E8F5)),
    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
    child: RotatedBox(
      quarterTurns: -3,
      child: AspectRatio(
        aspectRatio: 1,
        child: BarChart(
          BarChartData(
            backgroundColor: const Color(0XFFD9E8F5),
            borderData: FlBorderData(
                border:
                    const Border(bottom: BorderSide(), right: BorderSide())),
            gridData: FlGridData(show: false),
            groupsSpace: 0,
            barGroups: _chartGroupsEspecie(data),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  String text = "";
                  if (data != null) {
                    for (var element in data.datosEspecie) {
                      if (value.toInt() == element.especieId) {
                        text = element.nombre;
                      }
                    }
                  }
                  return Container(
                    height: 200.0,
                    child: RotatedBox(
                      child: Text(text),
                      quarterTurns: 0,
                    ),
                  );
                },
              )),
              // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        ),
      ),
    ),
  );
}

SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {
          case 1:
            text = 'Ene';
            break;
          case 2:
            text = 'Feb';
            break;
          case 3:
            text = 'Mar';
            break;
          case 4:
            text = 'Abr';
            break;
          case 5:
            text = 'May';
            break;
          case 6:
            text = 'Jun';
            break;
          case 7:
            text = 'Jul';
            break;
          case 8:
            text = 'Ago';
            break;
          case 9:
            text = 'Sep';
            break;
          case 10:
            text = 'Oct';
            break;
          case 11:
            text = 'Nov';
            break;
          case 12:
            text = 'Dic';
            break;
        }

        return Text(text);
      },
    );

List<BarChartGroupData> _chartGroups(Response? data) {
  if (data != null) {
    int indice = 1;
    List<BarChartGroupData> groups = [];
    for (var element in data.datosMesTonelada) {
      groups.add(BarChartGroupData(x: indice, barRods: [
        BarChartRodData(
            toY: element.volumen, width: 15.0, color: const Color(0xFFff8d4d))
      ]));
      indice++;
    }
    return groups;
  } else {
    return [];
  }
}

List<BarChartGroupData> _chartGroupsEspecie(Response? data) {
  if (data != null) {
    List<BarChartGroupData> groups = [];
    for (var element in data.datosEspecie) {
      groups.add(BarChartGroupData(x: element.especieId, barRods: [
        BarChartRodData(
            toY: element.volumen, width: 15.0, color: const Color(0xFF2064b7))
      ]));
    }
    return groups;
  } else {
    return [];
  }
}
