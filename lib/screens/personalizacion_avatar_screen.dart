import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_principal_screen.dart';

class PersonalizacionAvatarScreen extends StatefulWidget {
  final List<String> areasDeVida; // ✅ Se requiere este parámetro

  const PersonalizacionAvatarScreen({Key? key, required this.areasDeVida}) : super(key: key);

  @override
  _PersonalizacionAvatarScreenState createState() => _PersonalizacionAvatarScreenState();
}

class _PersonalizacionAvatarScreenState extends State<PersonalizacionAvatarScreen> {
  bool _showCustomizer = false;

  Future<void> _guardarAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar', 'customizado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personaliza tu Avatar")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showCustomizer)
              Column(
                children: [
                  FluttermojiCircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 80,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showCustomizer = true;
                      });
                    },
                    child: Text("Personalizar Avatar"),
                  ),
                ],
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: FluttermojiCustomizer()),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _guardarAvatar();
                        setState(() {
                          _showCustomizer = false;
                        });
                      },
                      child: Text("Guardar y Volver"),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),

            if (!_showCustomizer) SizedBox(height: 40),

            if (!_showCustomizer)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/configurarAreas');
                    },
                    child: Text("Guardar y Continuar"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MenuPrincipalScreen(
                            retosSeleccionados: {},
                            areasDeVida: widget.areasDeVida, // ✅ Se pasa correctamente
                          ),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: Text("Menú Principal"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
