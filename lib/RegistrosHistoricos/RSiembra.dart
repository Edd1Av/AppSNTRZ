import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sanitrazab/Dashboard/Dashboard.dart';
import 'package:sanitrazab/Models/siembra.dart';
import 'package:sanitrazab/RegistrosHistoricos/RCosecha.dart';
import 'package:sanitrazab/RegistrosHistoricos/RDesembarque.dart';
import 'package:sanitrazab/RegistrosHistoricos/RDespacho.dart';
import 'package:sanitrazab/RegistrosHistoricos/RProceso.dart';
import 'package:sanitrazab/RegistrosHistoricos/RRecepcion.dart';
import 'package:sanitrazab/RegistrosHistoricos/RTransferencia.dart';
import 'package:sanitrazab/ReportesSanidad/RFarmacovigilancia.dart';
import 'package:http/http.dart' as http;
import 'package:sanitrazab/Trazabilidad/consultar.dart';

class RSiembra extends StatefulWidget {
  const RSiembra({super.key});

  @override
  State<RSiembra> createState() => RSiembraState();
}

class RSiembraState extends State<RSiembra> {
  Future<List<Siembra>>? historicoSiembra;
  List<Siembra>? hist;
  List<Siembra> l = [];
  RowSourceSiembra datos = RowSourceSiembra(datos: []);
  bool inicio = true;
  //List<Siembra> hRS = [];

  Future<List<Siembra>> getHistorico() async {
    // Map<String, String> body = {
    //   'filtro': json.encode({
    //     'fechainicio': null,
    //     'fechafin': null,
    //   }),
    // };

    // var match = {
    //   "filtro": {"fechainicio": 'null', "fechafin": 'null'},
    //   "organizacionId": 'null'
    // };
    final response = await http.post(
      Uri.parse('https://dev.sanitrazab.plnmarina.com/api/siembra/historico'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "filtro": jsonEncode(
            <String, dynamic>{"fechainicio": null, "fechafin": null}),
      }),
    );

    List<Siembra> rHSiembra = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        rHSiembra.add(Siembra(element["fecha"], element["centroAcuicola"],
            element["especie"], element["cantidadPL"]));
      }

      return rHSiembra;

      // Iterable list = json.decode(response.body);
      // RHSiembras = list.map((model) => Siembra.fromJson(model)).toList();
      // return RHSiembras;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    historicoSiembra = getHistorico();
    //hist = getHistorico();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: cuerpo(context, historicoSiembra),
        appBar: appBarR(context),
        bottomNavigationBar: bottomNav(context, 0));
  }

  Widget cuerpo(BuildContext context, historicoSiembra) {
    return Container(
      child: Center(
          child: ListView(
        children: <Widget>[
          logo(),
          titulo(),
          FutureBuilder(
            future: historicoSiembra,
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
    filter(List<Siembra> d, String value) {
      List<Siembra> filt = [];
      for (var element in d) {
        if (element.centroAcuicola
                .toUpperCase()
                .contains(value.toUpperCase()) ||
            element.fecha.toUpperCase().contains(value.toUpperCase()) ||
            element.especie.toUpperCase().contains(value.toUpperCase()) ||
            element.cantidadPL.toString().contains(value)) {
          filt.add(element);
        }
      }
      return filt;
    }

    if (inicio) {
      datos.datos = rH;
    }
    // setState(() {
    //   datos = new RowSource(datos: rH);
    // });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      // child: SingleChildScrollView(
      //   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      //   scrollDirection: Axis.horizontal,
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
            label: Text('Cantidad (U)'),
          ),
        ],
        rowsPerPage: 8,
      ),
    );
    //);
  }
}

PreferredSizeWidget appBarR(context) {
  return AppBar(
    title: const Text("Registros Históricos"),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.settings),
        tooltip: 'Setting Icon',
        onPressed: () {},
      ),
    ],
    backgroundColor: const Color(0xFF2064b7),
    leading: PopupMenuButton(
        icon: const Icon(Icons.menu),
        itemBuilder: (context) {
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: Text("Siembra"),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Text("Transferencia"),
            ),
            const PopupMenuItem<int>(
              value: 2,
              child: Text("Cosecha"),
            ),
            const PopupMenuItem<int>(
              value: 3,
              child: Text("Recepción"),
            ),
            const PopupMenuItem<int>(
              value: 4,
              child: Text("Proceso"),
            ),
            const PopupMenuItem<int>(
              value: 5,
              child: Text("Despacho"),
            ),
            const PopupMenuItem<int>(
              value: 6,
              child: Text("Desembarque"),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const RSiembra()));
          } else if (value == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const RTransferencia()));
          } else if (value == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const RCosecha()));
          } else if (value == 3) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const RRecepcion()));
          } else if (value == 4) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const RProceso()));
          } else if (value == 5) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const RDespacho()));
          } else if (value == 6) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const RDesembarque()));
          }
        }),
  );
}

Widget bottomNav(context, int currentIndx) {
  return BottomNavigationBar(
    currentIndex: currentIndx,
    type: BottomNavigationBarType.fixed,
    backgroundColor: const Color(0xFFff8d4d),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white.withOpacity(.60),
    selectedFontSize: 14,
    unselectedFontSize: 14,
    onTap: (index) {
      // Respond to item press.
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const RSiembra()));
      } else if (index == 1) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const RFarmacovigilancia()));
      } else if (index == 2) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ConsultarTraz()));
      } else if (index == 3) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      }
    },
    items: const [
      BottomNavigationBarItem(
        label: 'Registros',
        icon: Icon(Icons.library_books),
      ),
      BottomNavigationBarItem(
        label: 'Sanidad',
        icon: Icon(Icons.sailing_rounded),
      ),
      BottomNavigationBarItem(
        label: 'Trazabilidad',
        icon: Icon(Icons.location_on),
      ),
      BottomNavigationBarItem(
        label: 'Dashboard',
        icon: Icon(Icons.dashboard),
      ),
    ],
  );
}

Widget logo() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 15.0),
    child: Image.asset("assets/SANITRAZAB-menu.png"),
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
            "REGISTROS HISTÓRICOS DE SIEMBRA",
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

class RowSourceSiembra extends DataTableSource {
  List<Siembra> datos;

  RowSourceSiembra({required this.datos});

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
      DataCell(Text(datos[index].cantidadPL.toString()))
    ]);
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
