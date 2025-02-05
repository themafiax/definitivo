import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'menu_principal_screen.dart';

class TiendaMalosHabitosScreen extends StatefulWidget {
  final List<String> areasDeVida;

  const TiendaMalosHabitosScreen({Key? key, required this.areasDeVida}) : super(key: key);

  @override
  _TiendaMalosHabitosScreenState createState() => _TiendaMalosHabitosScreenState();
}

class _TiendaMalosHabitosScreenState extends State<TiendaMalosHabitosScreen> {
  int pavos = 0;
  int vidaActual = 1000;
  int vidaMaxima = 1000;
  List<Map<String, dynamic>> malosHabitos = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pavos = prefs.getInt('pavos') ?? 0;
      vidaActual = prefs.getInt('vidaActual') ?? vidaMaxima;

      List<String>? habitosGuardados = prefs.getStringList('malosHabitos');
      if (habitosGuardados != null) {
        malosHabitos = habitosGuardados.map((habito) {
          List<String> partes = habito.split('|');
          return {"nombre": partes[0], "precio": int.parse(partes[1])};
        }).toList();
      } else {
        malosHabitos = _obtenerHabitosIniciales();
      }
    });
  }

  List<Map<String, dynamic>> _obtenerHabitosIniciales() {
    return [
      {"nombre": "Beber una cerveza", "precio": 30},
      {"nombre": "Fumar un cigarrillo", "precio": 20},
      {"nombre": "Fumar un porro", "precio": 50},
      {"nombre": "Salir de fiesta toda la noche", "precio": 100},
      {"nombre": "Comer comida rápida", "precio": 40},
      {"nombre": "Saltarse el gimnasio", "precio": 25},
      {"nombre": "Beber un cubata", "precio": 45},
      {"nombre": "Ver Netflix toda la noche", "precio": 35},
      {"nombre": "Jugar videojuegos por más de 5 horas", "precio": 50},
      {"nombre": "Gastar dinero en apuestas", "precio": 70},
      {"nombre": "Comer demasiados dulces", "precio": 30},
      {"nombre": "Beber refresco azucarado", "precio": 25},
      {"nombre": "Tomar bebidas energéticas", "precio": 40},
      {"nombre": "Dormir menos de 5 horas", "precio": 60},
      {"nombre": "Comprar cosas innecesarias", "precio": 55},
    ];
  }

  Future<void> _guardarHabitos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> habitosParaGuardar = malosHabitos.map((habito) => "${habito["nombre"]}|${habito["precio"]}").toList();
    prefs.setStringList('malosHabitos', habitosParaGuardar);
  }

  void _agregarMalHabito() {
    int precioPromedio = malosHabitos.map((h) => h["precio"]).reduce((a, b) => a + b) ~/ malosHabitos.length;
    setState(() {
      malosHabitos.add({"nombre": "Nuevo mal hábito", "precio": precioPromedio});
    });
    _guardarHabitos();
  }

  void _eliminarMalHabito(int index) {
    setState(() {
      malosHabitos.removeAt(index);
    });
    _guardarHabitos();
  }

  Future<void> _pecar(int precio) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vidaActual = (vidaActual - precio).clamp(0, vidaMaxima);
    });

    await prefs.setInt('vidaActual', vidaActual);

    // 🔥 Actualizar la pantalla 7 en tiempo real
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MenuPrincipalScreen(
          retosSeleccionados: {},
          areasDeVida: widget.areasDeVida,
          nivelesAreas: {}, // ✅ Se añade este parámetro vacío
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("¡Has pecado! -$precio de vida")),
    );
  }

  Future<void> _comprarHabito(int precio) async {
    if (pavos >= precio) {
      setState(() {
        pavos -= precio;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('pavos', pavos);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("¡Has comprado este mal hábito!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No tienes suficientes pavos para comprar esto.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tienda de Malos Hábitos")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔥 Sección de "Mis Pavos"
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("💰 Mis Pavos: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("$pavos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: malosHabitos.length,
                itemBuilder: (context, index) {
                  final habito = malosHabitos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(habito["nombre"]),
                      subtitle: Text("${habito["precio"]} Pavos"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => _comprarHabito(habito["precio"]),
                            child: Text("Comprar"),
                          ),
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () => _pecar(habito["precio"]),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: Text("He Pecado"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: _agregarMalHabito,
              child: Text("Añadir nuevo mal hábito"),
            ),
          ],
        ),
      ),
    );
  }
}
