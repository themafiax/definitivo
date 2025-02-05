import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_principal_screen.dart';

class ConfigurarAreasScreen extends StatefulWidget {
  final Function(List<String>, Map<String, List<String>>, Map<String, int>) actualizarAreasYRetos;

  const ConfigurarAreasScreen({Key? key, required this.actualizarAreasYRetos}) : super(key: key);

  @override
  _ConfigurarAreasScreenState createState() => _ConfigurarAreasScreenState();
}

class _ConfigurarAreasScreenState extends State<ConfigurarAreasScreen> {
  List<String> _areasSeleccionadas = [];
  Map<String, List<String>> _retosSeleccionados = {};
  Map<String, bool> _retosMarcados = {};
  Map<String, TextEditingController> _controladoresRetos = {};

  final Map<String, List<String>> _retosPorArea = {
    "Salud Física 🏋️‍♂️": [
      "Hacer 10-20 minutos de ejercicio",
      "Beber al menos 8 vasos de agua",
      "Dormir 7-8 horas sin pantallas antes de dormir"
    ],
    "Desarrollo Personal 📖": [
      "Leer 10 páginas de un libro",
      "Aprender algo nuevo por 20 minutos",
      "Escribir en un diario o reflexionar"
    ],
    "Finanzas 💰": [
      "Anotar todos los gastos del día",
      "Ahorrar al menos \$1",
      "Evitar comprar algo innecesario"
    ],
    "Relaciones 👨‍👩‍👧‍👦": [
      "Llamar o escribir a un ser querido",
      "Comer con alguien sin distracciones",
      "Escuchar atentamente sin interrumpir"
    ],
    "Trabajo y Productividad 💼": [
      "Planificar el día con 3 tareas importantes",
      "Trabajar 25 minutos sin distracciones",
      "Desactivar notificaciones de redes sociales mientras trabajas"
    ],
    "Espiritualidad y Mindfulness 🧘‍♂️": [
      "Escribir 3 cosas por las que estás agradecido",
      "Meditar o respirar profundamente 5-10 minutos",
      "Realizar un acto de amabilidad"
    ],
    "Ocio y Diversión 🎨": [
      "Dedicar 30 minutos a un hobby",
      "Probar algo nuevo",
      "Pasar 1 hora sin redes sociales"
    ],
  };

  @override
  void initState() {
    super.initState();
    _cargarDatosGuardados();
  }

  Future<void> _cargarDatosGuardados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _areasSeleccionadas = _retosPorArea.keys.toList();
      _retosSeleccionados = {};
      _controladoresRetos = {};

      for (String area in _areasSeleccionadas) {
        _retosSeleccionados[area] = _retosPorArea[area] ?? [];
        for (String reto in _retosSeleccionados[area]!) {
          _controladoresRetos[reto] = TextEditingController(text: reto);
          _retosMarcados[reto] = prefs.getBool('reto_marcado_$reto') ?? false;
        }
      }
    });
  }

  void _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('areasSeleccionadas', _areasSeleccionadas);

    _retosMarcados.forEach((reto, marcado) {
      prefs.setBool('reto_marcado_$reto', marcado);
    });

    Map<String, List<String>> retosEnProgreso = {};
    _retosSeleccionados.forEach((area, retos) {
      retosEnProgreso[area] = retos.where((reto) => _retosMarcados[reto] == true).toList();
    });

    widget.actualizarAreasYRetos(_areasSeleccionadas, retosEnProgreso, {});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuPrincipalScreen(
          retosSeleccionados: retosEnProgreso,
          areasDeVida: _areasSeleccionadas,
          nivelesAreas: {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurar Áreas y Retos")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _areasSeleccionadas.length,
                itemBuilder: (context, index) {
                  String area = _areasSeleccionadas[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ExpansionTile(
                      title: Text(area, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      children: _retosSeleccionados[area]!.map((reto) {
                        return ListTile(
                          leading: Checkbox(
                            value: _retosMarcados[reto] ?? false,
                            onChanged: (bool? value) {
                              setState(() {
                                _retosMarcados[reto] = value ?? false;
                              });
                            },
                          ),
                          title: TextField(
                            controller: _controladoresRetos[reto],
                            decoration: InputDecoration(border: InputBorder.none),
                            onSubmitted: (nuevoReto) {
                              setState(() {
                                int idx = _retosSeleccionados[area]!.indexOf(reto);
                                _retosSeleccionados[area]![idx] = nuevoReto;
                                _controladoresRetos[nuevoReto] = TextEditingController(text: nuevoReto);
                              });
                            },
                          ),
                          subtitle: Text(
                            "+5 XP, +10 Vida, -15 Vida, +5 Pavos",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: _guardarDatos, child: Text("Guardar y Continuar")),
          ],
        ),
      ),
    );
  }
}
