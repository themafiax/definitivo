import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroduccionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "¡Bienvenido a taMEgochi, tu mayor aventura del año!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "¿Estás listo para convertir tu vida en un juego? En taMEgochi, tú eres el protagonista. Crea tu avatar, establece tus metas y conquista cada aspecto de tu vida. Desde tu salud y finanzas hasta tus relaciones y crecimiento personal, cada decisión que tomes influirá en tu progreso.\n\n"
                  "Gana experiencia al construir buenos hábitos y sube de nivel en cada área. Consigue \"Pavos\", la moneda del juego, para recompensarte con placeres controlados. Pero cuidado: los malos hábitos te restarán puntos de vida, y si llegas a cero… tendrás que completar un reto para revivir.\n\n"
                  "Este es el año en el que te conviertes en tu mejor versión. ¿Aceptas el desafío? 💪🎮",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('primeraVez', false);
                Navigator.pushReplacementNamed(context, '/personalizacion');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("¡Comenzar!"),
            ),
          ],
        ),
      ),
    );
  }
}
