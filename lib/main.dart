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

  void actualizarAreasYRetos(List<String> nuevasAreas, Map<String, List<String>> nuevosRetos) {
    setState(() {
      _areasDeVida = nuevasAreas;
      _retosSeleccionados = nuevosRetos;
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
        retosSeleccionados: _retosSeleccionados, // ✅ Ahora usa los retos seleccionados correctamente
        areasDeVida: _areasDeVida, // ✅ Se mantiene la selección de áreas
      ),
      routes: {
        '/personalizacion': (context) => PersonalizacionAvatarScreen(areasDeVida: _areasDeVida),
        '/configurarAreas': (context) => ConfigurarAreasScreen(actualizarAreasYRetos: actualizarAreasYRetos), // ✅ Se pasa la función correcta
        '/explicacionPavos': (context) => ExplicacionPavosScreen(),
        '/tienda': (context) => TiendaMalosHabitosScreen(areasDeVida: _areasDeVida),
        '/configurarTiempo': (context) => ConfigurarTiempoScreen(),
        '/retoRevivir': (context) => RetoParaRevivirScreen(vida: _vida),
      },
    );
  }
}
