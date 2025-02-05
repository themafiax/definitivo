import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:fluttermoji/fluttermojiSaveWidget.dart';
import 'package:get/get.dart';
import 'package:fluttermoji/fluttermojiController.dart';
import 'configurar_areas_screen.dart';

class PersonalizacionAvatarScreen extends StatefulWidget {
  final List<String> areasDeVida;

  const PersonalizacionAvatarScreen({Key? key, required this.areasDeVida}) : super(key: key);

  @override
  _PersonalizacionAvatarScreenState createState() => _PersonalizacionAvatarScreenState();
}

class _PersonalizacionAvatarScreenState extends State<PersonalizacionAvatarScreen> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<FluttermojiController>()) {
      Get.put(FluttermojiController()); // 🔥 Inicializa el controlador solo si no está registrado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personaliza tu Avatar")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FluttermojiCustomizer(), // 🔥 Eliminando el parámetro 'controller'
          ),

          SizedBox(height: 20),

          FluttermojiSaveWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfigurarAreasScreen(
                  actualizarAreasYRetos: (nuevasAreas, nuevosRetos, nuevosNiveles) {},
                )),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Guardar y Continuar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
