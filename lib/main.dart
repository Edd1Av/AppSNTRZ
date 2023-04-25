import 'package:flutter/material.dart';
import 'package:sanitrazab/menu.dart';

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sanitrazab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cuerpo(context),
    );
  }
}

Widget cuerpo(context) {
  return Container(
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/Fondo-login.jpg"), fit: BoxFit.cover)),
    child: Center(
        child: ListView(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        logo(),
        campoUsuario(),
        campoContrasena(),
        const SizedBox(height: 10.0),
        botonLogin(context)
      ],
    )),
  );
}

Widget logo() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
    child: Image.asset("assets/SANITRAZAB.png"),
  );
}

Widget titulo() {
  return const Text(
    "Iniciar Sesión",
    style: TextStyle(
        color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
  );
}

Widget campoUsuario() {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 20.0),
        decoration: InputDecoration(
          hintText: "Usuario",
          hintStyle: const TextStyle(color: Colors.white),
          fillColor: const Color(0xFF2064b7),
          filled: true,
          prefixIcon: const Icon(Icons.person),
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

Widget campoContrasena() {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
      child: TextField(
        obscureText: true,
        style: const TextStyle(color: Colors.white, fontSize: 20.0),
        decoration: InputDecoration(
          hintText: "Contraseña",
          hintStyle: const TextStyle(color: Colors.white),
          fillColor: const Color(0xFF2064b7),
          filled: true,
          prefixIcon: const Icon(Icons.lock),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFF2064b7),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFF2064b7),
              width: 1.0,
            ),
          ),
        ),
      ));
}

Widget botonLogin(context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 0.0),
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFFff8d4d)),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0)),
      ),
      child: const Text(
        "Entrar",
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MenuPage()))
      },
    ),
  );
}
