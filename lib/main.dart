import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/introduccion_screen.dart';
import 'screens/menu_principal_screen.dart';
import 'screens/personalizacion_avatar_screen.dart';
import 'screens/configurar_areas_screen.dart';
import 'screens/explicacion_pavos_screen.dart';
import 'screens/tienda_malos_habitos_screen.dart';
import 'screens/configurar_tiempo_screen.dart';
import 'screens/reto_para_revivir_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool primeraVez = prefs.getBool('primeraVez') ?? true;

  runApp(MyApp(primeraVez: primeraVez));
}

class MyApp extends StatefulWidget {
  final bool primeraVez;

  const MyApp({super.key, required this.primeraVez});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _areasDeVida = [];
  Map<String, List<String>> _retosSeleccionados = {};
  Map<String, bool> _retosCumplidos = {}; // ✅ Se mantienen los retos cumplidos sin cambios
  Map<String, int> _nivelesAreas = {}; // ✅ Se mantienen los niveles de áreas sin cambios
  int _vida = 500;
  bool _cargando = true;
  bool _primeraVez = true;

  @override
  void initState() {
    super.initState();
    _verificarRutaInicial();
  }

  Future<void> _verificarRutaInicial() async {
    final prefs = await SharedPreferences.getInstance();
    bool primeraVez = prefs.getBool('primeraVez') ?? true;

    if (primeraVez) {
      await prefs.setBool('primeraVez', false);
    }

    setState(() {
      _primeraVez = primeraVez;
      _cargando = false;
    });
  }

  void actualizarAreasYRetos(List<String> nuevasAreas, Map<String, List<String>> nuevosRetos, Map<String, int> nuevosNiveles) {
    setState(() {
      _areasDeVida = nuevasAreas;
      _retosSeleccionados = nuevosRetos;
      _nivelesAreas = nuevosNiveles;
    });
  }

  void actualizarRetosCumplidos(Map<String, bool> nuevosRetosCumplidos) {
    setState(() {
      _retosCumplidos = nuevosRetosCumplidos;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Definitivo',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: _primeraVez
          ? IntroduccionScreen()
          : MenuPrincipalScreen(
        retosSeleccionados: _retosSeleccionados,

        areasDeVida: _areasDeVida,
        nivelesAreas: _nivelesAreas, // ✅ Se pasa correctamente a la pantalla 7
      ),
      routes: {
        '/personalizacion': (context) => PersonalizacionAvatarScreen(areasDeVida: _areasDeVida),
        '/configurarAreas': (context) => ConfigurarAreasScreen(actualizarAreasYRetos: actualizarAreasYRetos),
        '/explicacionPavos': (context) => ExplicacionPavosScreen(),
        '/tienda': (context) => TiendaMalosHabitosScreen(areasDeVida: _areasDeVida),
        '/configurarTiempo': (context) => ConfigurarTiempoScreen(
        ),
        '/retoRevivir': (context) => RetoParaRevivirScreen(vida: _vida),
      },
    );
  }
}
