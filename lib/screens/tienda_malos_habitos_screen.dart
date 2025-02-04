import 'package:flutter/material.dart';
import 'menu_principal_screen.dart';

class TiendaMalosHabitosScreen extends StatefulWidget {
  final List<String> areasDeVida; // ✅ Se requiere este parámetro

  const TiendaMalosHabitosScreen({Key? key, required this.areasDeVida}) : super(key: key);

  @override
  _TiendaMalosHabitosScreenState createState() => _TiendaMalosHabitosScreenState();
}

class _TiendaMalosHabitosScreenState extends State<TiendaMalosHabitosScreen> {
  int pavos = 200; // Simulación de Pavos del usuario

  List<Map<String, dynamic>> malosHabitos = [
    {"nombre": "Beber una cerveza", "precio": 30},
    {"nombre": "Tomar un cubata", "precio": 40},
    {"nombre": "Fumar un cigarrillo", "precio": 15},
    {"nombre": "Comer comida rápida", "precio": 50},
    {"nombre": "Pasar 3 horas en redes sociales", "precio": 25},
    {"nombre": "Saltarse el gimnasio", "precio": 35},
    {"nombre": "Comer dulces en exceso", "precio": 20},
    {"nombre": "Dormir menos de 5 horas", "precio": 45},
  ];

  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = malosHabitos.map((habito) => TextEditingController(text: habito["nombre"])).toList();
  }

  void comprarMalHabito(int precio) {
    if (pavos >= precio) {
      setState(() {
        pavos -= precio;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("¡Compra realizada con éxito!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No tienes suficientes Pavos para esta compra.")),
      );
    }
  }

  void guardarCambios() {
    setState(() {
      for (int i = 0; i < malosHabitos.length; i++) {
        malosHabitos[i]["nombre"] = _controllers[i].text;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("¡Cambios guardados correctamente!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tienda de Malos Hábitos"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: malosHabitos.length,
                itemBuilder: (context, index) {
                  final habito = malosHabitos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: TextField(
                        controller: _controllers[index],
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                      subtitle: Text("${habito["precio"]} Pavos"),
                      trailing: ElevatedButton(
                        onPressed: () => comprarMalHabito(habito["precio"]),
                        child: Text("Comprar"),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: guardarCambios,
              child: Text("Guardar cambios"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          guardarCambios();
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
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
