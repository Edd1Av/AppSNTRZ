import 'package:flutter/material.dart';
import 'package:sanitrazab/Dashboard/Dashboard.dart';
import 'package:sanitrazab/RegistrosHistoricos/RSiembra.dart';
import 'package:sanitrazab/ReportesSanidad/RFarmacovigilancia.dart';
import 'package:sanitrazab/Trazabilidad/consultar.dart';

// class Menu extends StatelessWidget {
//   // const Menu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Pagina"),
//       ),
//       body: MenuPage(),
//     );
//   }
// }

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  // const MenuPage({super.key, required this.title});

  @override
  State<MenuPage> createState() => _MyMenuPageState();
}

class _MyMenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cuerpo(context),
    );
  }
}

Widget cuerpo(context) {
  return Container(
    child: Center(
        child: ListView(
      children: <Widget>[logo(context), botones(context)],
    )),
  );
}

Widget logo(context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 20.0),
    child: Image.asset("assets/SANITRAZAB-menu.png"),
  );
}

Widget botones(context) {
  double screenWidth = MediaQuery.of(context).size.width;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
    child: Column(
      children: [
        Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2064b7)),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0)),
                ),
                // style: ElevatedButton.styleFrom(
                //     maximumSize: Size(screenWidth * .4, screenWidth),
                //     backgroundColor: Color(0xFF2064b7)),

                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const RSiembra()))
                },
                child: Column(children: [
                  const Text(
                    "REGISTROS HISTÓRICOS",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    "assets/Reportes-cosecha-icono.png",
                    height: screenWidth * .25,
                  ),
                ]),
              ),
            ),
            const SizedBox(width: 20.0),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2064b7)),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0)),
                ),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RFarmacovigilancia()))
                },
                child: Column(children: [
                  const Text(
                    "REPORTES DE SANIDAD",
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    "assets/Reportes-sanidad.png",
                    height: screenWidth * .25,
                  ),
                ]),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2064b7)),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0)),
                ),
                // style: ElevatedButton.styleFrom(
                //     maximumSize: Size(screenWidth * .4, screenWidth),
                //     backgroundColor: Color(0xFF2064b7)),

                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConsultarTraz()))
                },
                child: Column(children: [
                  const Text(
                    "REPORTE DE TRAZABILIDAD",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 19.0),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    "assets/Trazabilidad.png",
                    height: screenWidth * .25,
                  ),
                ]),
              ),
            ),
            const SizedBox(width: 20.0),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2064b7)),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0)),
                ),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()))
                },
                child: Column(children: [
                  const Text(
                    "VER DASHBOARD",
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    "assets/Dashboard.png",
                    height: screenWidth * .25,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
