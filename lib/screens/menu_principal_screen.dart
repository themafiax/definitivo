import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'personalizacion_avatar_screen.dart';
import 'configurar_areas_screen.dart';
import 'explicacion_pavos_screen.dart';
import 'tienda_malos_habitos_screen.dart';
import 'configurar_tiempo_screen.dart';
import 'reto_para_revivir_screen.dart';

class MenuPrincipalScreen extends StatefulWidget {
  final Map<String, List<String>> retosSeleccionados;
  final List<String> areasDeVida;

  const MenuPrincipalScreen({
    Key? key,
    required this.retosSeleccionados,
    required this.areasDeVida,
  }) : super(key: key);

  @override
  _MenuPrincipalScreenState createState() => _MenuPrincipalScreenState();
}

class _MenuPrincipalScreenState extends State<MenuPrincipalScreen> {
  int vidaActual = 500;
  int vidaMaxima = 1000;
  bool avatarPersonalizado = false;
  List<String> _areasDeVida = [];
  Map<String, List<String>> _retosSeleccionados = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      avatarPersonalizado = prefs.getString('avatar') != null;
      _areasDeVida = prefs.getStringList('areasSeleccionadas') ?? widget.areasDeVida;
      _retosSeleccionados = widget.retosSeleccionados;
    });
  }

  void _actualizarAreasYRetos(List<String> nuevasAreas, Map<String, List<String>> nuevosRetos) {
    setState(() {
      _areasDeVida = nuevasAreas;
      _retosSeleccionados = nuevosRetos;
    });
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalizacionAvatarScreen(areasDeVida: _areasDeVida),
                    ),
                  );
                  break;
                case 'Configurar Áreas de Vida':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigurarAreasScreen(
                        actualizarAreasYRetos: _actualizarAreasYRetos, // ✅ Ahora se actualiza correctamente
                      ),
                    ),
                  ).then((_) => _cargarDatos()); // ✅ Recargar datos después de actualizar
                  break;
                case 'Explicación Pavos':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ExplicacionPavosScreen()));
                  break;
                case 'Tienda de Malos Hábitos':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TiendaMalosHabitosScreen(areasDeVida: _areasDeVida),
                    ),
                  );
                  break;
                case 'Configurar Tiempo de Retos':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigurarTiempoScreen()));
                  break;
                case 'Reto para Revivir':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RetoParaRevivirScreen(vida: vidaActual),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'Personalizar Avatar', child: Text("Personalizar Avatar")),
              PopupMenuItem(value: 'Configurar Áreas de Vida', child: Text("Configurar Áreas de Vida")),
              PopupMenuItem(value: 'Explicación Pavos', child: Text("Explicación Pavos")),
              PopupMenuItem(value: 'Tienda de Malos Hábitos', child: Text("Tienda de Malos Hábitos")),
              PopupMenuItem(value: 'Configurar Tiempo de Retos', child: Text("Configurar Tiempo de Retos")),
              PopupMenuItem(value: 'Reto para Revivir', child: Text("Reto para Revivir")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: avatarPersonalizado
                  ? FluttermojiCircleAvatar(radius: 60)
                  : CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),

            Text(
              "Vida: $vidaActual / $vidaMaxima",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/configurarTiempo');
              },
              child: Text("Configurar Tiempo de Retos"),
            ),

            SizedBox(height: 20),

            Text(
              "Retos Seleccionados",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

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
                      title: Text(area, style: TextStyle(fontWeight: FontWeight.bold)),
                      children: retos.map((reto) => ListTile(title: Text(reto))).toList(),
                    ),
                  );
                },
              )
                  : Center(child: Text("No hay retos seleccionados")),
            ),
          ],
        ),
      ),
    );
  }
}
