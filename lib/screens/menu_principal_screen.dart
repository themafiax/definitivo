import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'personalizacion_avatar_screen.dart';
import 'configurar_areas_screen.dart';
import 'explicacion_pavos_screen.dart';
import 'tienda_malos_habitos_screen.dart';
import 'configurar_tiempo_screen.dart';
import 'reto_para_revivir_screen.dart';

class MenuPrincipalScreen extends StatefulWidget {
  final Map<String, List<String>> retosSeleccionados;
  final List<String> areasDeVida;
  final Map<String, int> nivelesAreas;

  const MenuPrincipalScreen({
    Key? key,
    required this.retosSeleccionados,
    required this.areasDeVida,
    required this.nivelesAreas,
  }) : super(key: key);

  @override
  _MenuPrincipalScreenState createState() => _MenuPrincipalScreenState();
}

class _MenuPrincipalScreenState extends State<MenuPrincipalScreen> {
  int vidaActual = 1000;
  int vidaMaxima = 1000;
  int xpActual = 0;
  int nivelActual = 1;
  int pavos = 0;
  final int xpPorNivel = 100;
  Map<String, List<String>> _retosSeleccionados = {};
  Map<String, bool> _retosCumplidos = {};
  bool _contadorActivo = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vidaActual = prefs.getInt('vidaActual') ?? vidaMaxima;
      xpActual = prefs.getInt('xpActual') ?? 0;
      nivelActual = prefs.getInt('nivelActual') ?? 1;
      pavos = prefs.getInt('pavos') ?? 0;
      _retosSeleccionados = widget.retosSeleccionados;
      _contadorActivo = prefs.getBool('contadorActivo') ?? false;

      for (var area in _retosSeleccionados.keys) {
        for (var reto in _retosSeleccionados[area]!) {
          _retosCumplidos[reto] = prefs.getBool('reto_cumplido_$reto') ?? false;
        }
      }
    });
  }

  Future<void> _guardarRetoCumplido(String reto) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _retosCumplidos[reto] = !_retosCumplidos[reto]!;
    });
    prefs.setBool('reto_cumplido_$reto', _retosCumplidos[reto]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menú Principal"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Personalizar Avatar':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalizacionAvatarScreen(areasDeVida: widget.areasDeVida)));
                  break;
                case 'Configurar Áreas de Vida':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigurarAreasScreen(
                    actualizarAreasYRetos: (nuevasAreas, nuevosRetos, nuevosNiveles) {
                      setState(() {
                        _retosSeleccionados = nuevosRetos;
                      });
                    },
                  )));
                  break;
                case 'Explicación Pavos':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ExplicacionPavosScreen()));
                  break;
                case 'Tienda de Malos Hábitos':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TiendaMalosHabitosScreen(areasDeVida: widget.areasDeVida)));
                  break;
                case 'Reto para Revivir':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RetoParaRevivirScreen(vida: vidaActual)));
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'Personalizar Avatar', child: Text("Personalizar Avatar")),
              PopupMenuItem(value: 'Configurar Áreas de Vida', child: Text("Configurar Áreas de Vida")),
              PopupMenuItem(value: 'Explicación Pavos', child: Text("Explicación Pavos")),
              PopupMenuItem(value: 'Tienda de Malos Hábitos', child: Text("Tienda de Malos Hábitos")),
              PopupMenuItem(value: 'Reto para Revivir', child: Text("Reto para Revivir")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            FluttermojiCircleAvatar(radius: 60),
            SizedBox(height: 20),

            Text("Vida: $vidaActual / $vidaMaxima", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StepProgressIndicator(totalSteps: vidaMaxima, currentStep: vidaActual, size: 10, padding: 0),

            SizedBox(height: 20),

            Text("Nivel: $nivelActual", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StepProgressIndicator(totalSteps: xpPorNivel, currentStep: xpActual, size: 10, padding: 0),

            SizedBox(height: 20),

            Text("💰 Pavos: $pavos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellow[800])),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigurarTiempoScreen()));
              },
              child: Text("Configurar Tiempo de Retos"),
            ),

            SizedBox(height: 20),

            Text("Retos en progreso", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: _retosSeleccionados.isNotEmpty
                  ? ListView.builder(
                itemCount: _retosSeleccionados.length,
                itemBuilder: (context, index) {
                  String area = _retosSeleccionados.keys.elementAt(index);
                  List<String> retos = _retosSeleccionados[area] ?? [];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ExpansionTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(area, style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      children: retos.map((reto) => ListTile(
                        title: Text(reto),
                        subtitle: Row(
                          children: [
                            Text(
                              "En progreso",
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Checkbox(
                              value: _retosCumplidos[reto] ?? false,
                              onChanged: (bool? value) {
                                _guardarRetoCumplido(reto);
                              },
                            ),
                            Text("Marcar si cumplido", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      )).toList(),
                    ),
                  );
                },
              )
                  : Center(child: Text("No hay retos en progreso")),
            ),
          ],
        ),
      ),
    );
  }
}
