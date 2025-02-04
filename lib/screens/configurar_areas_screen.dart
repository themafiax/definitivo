import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_principal_screen.dart';

class ConfigurarAreasScreen extends StatefulWidget {
  final Function(List<String>, Map<String, List<String>>) actualizarAreasYRetos;

  const ConfigurarAreasScreen({Key? key, required this.actualizarAreasYRetos}) : super(key: key);

  @override
  _ConfigurarAreasScreenState createState() => _ConfigurarAreasScreenState();
}

class _ConfigurarAreasScreenState extends State<ConfigurarAreasScreen> {
  List<String> _areasSeleccionadas = [];
  Map<String, List<String>> _retosSeleccionados = {};
  Map<String, List<bool>> _retosMarcados = {};

  final Map<String, List<String>> _areasPorDefecto = {
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
    ]
  };

  @override
  void initState() {
    super.initState();
    _cargarDatosGuardados();
  }

  Future<void> _cargarDatosGuardados() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? areasGuardadas = prefs.getStringList('areasSeleccionadas');

    if (areasGuardadas == null || areasGuardadas.isEmpty) {
      _areasSeleccionadas = _areasPorDefecto.keys.toList();
      _retosSeleccionados = Map.from(_areasPorDefecto);
    } else {
      _areasSeleccionadas = areasGuardadas;
      _retosSeleccionados = {};
      for (String area in _areasSeleccionadas) {
        _retosSeleccionados[area] = prefs.getStringList(area) ?? [];
      }
    }

    _retosMarcados = {
      for (var area in _areasSeleccionadas)
        area: List.filled(_retosSeleccionados[area]?.length ?? 0, false)
    };

    setState(() {});
  }

  void _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('areasSeleccionadas', _areasSeleccionadas);

    _retosSeleccionados.forEach((area, retos) {
      prefs.setStringList(area, retos);
    });

    widget.actualizarAreasYRetos(_areasSeleccionadas, _retosSeleccionados);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("¡Áreas y retos guardados correctamente!")),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MenuPrincipalScreen(
          retosSeleccionados: _retosSeleccionados,
          areasDeVida: _areasSeleccionadas,
        ),
      ),
          (Route<dynamic> route) => false,
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
                      title: Text(area, style: TextStyle(fontWeight: FontWeight.bold)),
                      children: _retosSeleccionados[area]!.asMap().entries.map((entry) {
                        int retoIndex = entry.key;
                        String reto = entry.value;
                        return Row(
                          children: [
                            Checkbox(
                              value: _retosMarcados[area]?[retoIndex] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  _retosMarcados[area]?[retoIndex] = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: Text(reto),
                            ),
                          ],
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
