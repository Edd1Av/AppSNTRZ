import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class RTrazabilidad extends StatefulWidget {
  String dec;

  RTrazabilidad({required this.dec, super.key});

  // const MenuPage({super.key, required this.title});

  @override
  // ignore: no_logic_in_create_state
  State<RTrazabilidad> createState() => _RTrazabilidadState(decS: dec);
}

class _RTrazabilidadState extends State<RTrazabilidad> {
  String decS;
  _RTrazabilidadState({required this.decS});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String codigo = decS.trim().toUpperCase();
    String url =
        "https://dev.sanitrazab.plnmarina.com/trazabilidad?dec=$codigo";
    return Scaffold(
      appBar: AppBar(title: Text(decS)),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
