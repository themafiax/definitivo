import 'package:flutter/material.dart';

class ExplicacionPavosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("¿Qué son los Pavos?")),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "¿Qué son los Pavos?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Los Pavos son la moneda ficticia del juego. Con ellos podrás comprar malos hábitos, como fumar, beber, salir de fiesta, etc.\n\n"
                  "Podrás ganar Pavos si cumples los retos diarios en cada área de tu vida y gastarlos en la tienda de malos hábitos.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tienda');
              },
              child: Text("Siguiente"),
            ),
          ],
        ),
      ),
    );
  }
}
