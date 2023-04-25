import 'package:flutter/material.dart';
import 'package:sanitrazab/Trazabilidad/RTrazabilidad.dart';

// class MenuTraz extends StatelessWidget {
//   const MenuTraz({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //   body: ConsultarTraz(),
//     // );
//     return MaterialApp(
//       home: Scaffold(
//         body: const ConsultarTraz(),
//       ),
//     );
//   }
// }

class ConsultarTraz extends StatefulWidget {
  const ConsultarTraz({super.key});

  // const MenuPage({super.key, required this.title});

  @override
  State<ConsultarTraz> createState() => _ConsultarTrazState();
}

class _ConsultarTrazState extends State<ConsultarTraz> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dec;
  @override
  void initState() {
    super.initState();
    _dec = TextEditingController();
  }

  @override
  void dispose() {
    _dec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cuerpo(context),
    );
  }

  Widget cuerpo(context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/fondo-trazabilidad-imagen.jpg"),
              fit: BoxFit.cover)),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Fondo-trazabilidad_transparente.png"),
                fit: BoxFit.fitHeight)),
        child: Center(
            child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[logo(), cont(context)],
        )),
      ),
    );
  }

  Widget logo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      child: Image.asset("assets/SANITRAZAB.png"),
    );
  }

  Widget cont(context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffd8e8f5),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: <Widget>[titulo(), campoDec(), botonBuscar(context)],
          ),
        ),
      ),
    );
  }

  Widget titulo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: const Text(
        "Verifica la trazabilidad de tu producto ingresando el código",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color(0xff5d5d5d),
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget campoDec() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: TextFormField(
          controller: _dec,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa un DEC';
            }
            return null;
          },
          style: const TextStyle(color: Colors.white, fontSize: 20.0),
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.white),
            fillColor: const Color(0xFF2064b7),
            filled: true,
            suffixIcon: const Icon(Icons.search),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFF2064b7),
                width: 0.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFF2064b7),
                width: 0.0,
              ),
            ),
          ),
        ));
  }

  Widget botonBuscar(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFff8d4d)),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0)),
        ),
        child: const Text(
          "Buscar",
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () => {
          if (_formKey.currentState!.validate())
            {
              _formKey.currentState!.save(),
              print(_dec.text),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RTrazabilidad(dec: _dec.text)))
            }
        },
      ),
    );
  }
}
