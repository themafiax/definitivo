import 'package:flutter/material.dart';

class RetoParaRevivirScreen extends StatefulWidget {
  final int vida;

  RetoParaRevivirScreen({required this.vida});

  @override
  _RetoParaRevivirScreenState createState() => _RetoParaRevivirScreenState();
}

class _RetoParaRevivirScreenState extends State<RetoParaRevivirScreen> {
  TextEditingController _retoController = TextEditingController(text: "Atravesar mi ciudad de punta a punta corriendo");

  void revivir() {
    if (widget.vida <= 0) {
      Navigator.pop(context, 20); // Regresa al menú principal con 20 de vida
    }
  }

  @override
  Widget build(BuildContext context) {
    bool botonHabilitado = widget.vida <= 0;

    return Scaffold(
      appBar: AppBar(title: Text("Reto para Revivir")),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _retoController,
              decoration: InputDecoration(
                labelText: "Configura tu reto para revivir",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: botonHabilitado ? revivir : null,
              child: Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: botonHabilitado ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "REVIVIR",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Atravesar mi ciudad de punta a punta corriendo",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
