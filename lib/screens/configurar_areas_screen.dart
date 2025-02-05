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

  final Map<String, int> _xpPorReto = {
    "Salud Física 🏋️‍♂️": 5,
    "Desarrollo Personal 📖": 4,
    "Finanzas 💰": 3,
    "Relaciones 👨‍👩‍👧‍👦": 4,
    "Trabajo y Productividad 💼": 5,
    "Espiritualidad y Mindfulness 🧘‍♂️": 4,
    "Ocio y Diversión 🎨": 3,
  };

  final Map<String, int> _vidaGanadaPorReto = {
    "Salud Física 🏋️‍♂️": 10,
    "Desarrollo Personal 📖": 8,
    "Finanzas 💰": 5,
    "Relaciones 👨‍👩‍👧‍👦": 8,
    "Trabajo y Productividad 💼": 10,
    "Espiritualidad y Mindfulness 🧘‍♂️": 8,
    "Ocio y Diversión 🎨": 5,
  };

  final Map<String, int> _vidaPerdidaPorReto = {
    "Salud Física 🏋️‍♂️": 15,
    "Desarrollo Personal 📖": 12,
    "Finanzas 💰": 10,
    "Relaciones 👨‍👩‍👧‍👦": 12,
    "Trabajo y Productividad 💼": 15,
    "Espiritualidad y Mindfulness 🧘‍♂️": 10,
    "Ocio y Diversión 🎨": 8,
  };

  final Map<String, int> _pavosPorReto = {
    "Salud Física 🏋️‍♂️": 5,
    "Desarrollo Personal 📖": 4,
    "Finanzas 💰": 3,
    "Relaciones 👨‍👩‍👧‍👦": 4,
    "Trabajo y Productividad 💼": 5,
    "Espiritualidad y Mindfulness 🧘‍♂️": 4,
    "Ocio y Diversión 🎨": 3,
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
      for (String area in _areasSeleccionadas) {
        _retosSeleccionados[area] = _retosPorArea[area] ?? [];
      }
    });
  }

  void _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('areasSeleccionadas', _areasSeleccionadas);

    widget.actualizarAreasYRetos(_areasSeleccionadas, _retosSeleccionados, {});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuPrincipalScreen(
          retosSeleccionados: _retosSeleccionados,
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
                        return CheckboxListTile(
                          title: Text(reto),
                          subtitle: Text(
                            "+${_xpPorReto[area] ?? 0} XP, +${_vidaGanadaPorReto[area] ?? 0} Vida, -${_vidaPerdidaPorReto[area] ?? 0} Vida, +${_pavosPorReto[area] ?? 0} Pavos",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          value: _retosMarcados[reto] ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              _retosMarcados[reto] = value ?? false;
                            });
                          },
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
