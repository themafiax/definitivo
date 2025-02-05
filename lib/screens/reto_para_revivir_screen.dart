import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pedometer/pedometer.dart';
import 'menu_principal_screen.dart';

class RetoParaRevivirScreen extends StatefulWidget {
  final int vida;

  const RetoParaRevivirScreen({Key? key, required this.vida}) : super(key: key);

  @override
  _RetoParaRevivirScreenState createState() => _RetoParaRevivirScreenState();
}

class _RetoParaRevivirScreenState extends State<RetoParaRevivirScreen> {
  int _pasosContados = 0;
  final int _metaPasos = 50000;
  bool _retoIniciado = false;
  bool _puedeRevivir = false;
  late Stream<StepCount> _stepCountStream;

  @override
  void initState() {
    super.initState();
    _cargarProgreso();
  }

  Future<void> _cargarProgreso() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pasosContados = prefs.getInt('pasosContados') ?? 0;
      _retoIniciado = prefs.getBool('retoIniciado') ?? false;
      _puedeRevivir = _pasosContados >= _metaPasos;
    });

    if (widget.vida <= 0 && _retoIniciado) {
      _iniciarContadorDePasos();
    }
  }

  void _iniciarContadorDePasos() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) async {
      setState(() {
        _pasosContados = event.steps;
        if (_pasosContados >= _metaPasos) {
          _puedeRevivir = true;
        }
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('pasosContados', _pasosContados);
      prefs.setBool('puedeRevivir', _puedeRevivir);
    }).onError((error) {
      print("Error al leer el sensor de pasos: $error");
    });
  }

  Future<void> _empezarReto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _retoIniciado = true;
      _pasosContados = 0;
      _puedeRevivir = false;
    });
    prefs.setBool('retoIniciado', true);
    prefs.setInt('pasosContados', 0);
    _iniciarContadorDePasos();
  }

  Future<void> _revivir() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('vidaActual', 50);
    prefs.setBool('retoIniciado', false);
    prefs.setInt('pasosContados', 0);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MenuPrincipalScreen(
        retosSeleccionados: {},
        areasDeVida: [],
        nivelesAreas: {},
      )),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reto para Revivir")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Debes completar este reto para revivir:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "🚶‍♂️ Dar 50,000 pasos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Pasos Contados: $_pasosContados / $_metaPasos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            _retoIniciado
                ? Text(
              "¡Caminando! Sigue avanzando para completar el reto.",
              style: TextStyle(fontSize: 16, color: Colors.green),
            )
                : ElevatedButton(
              onPressed: widget.vida <= 0 ? _empezarReto : null,
              child: Text("Empezar Reto"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _puedeRevivir ? _revivir : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _puedeRevivir ? Colors.green : Colors.grey,
              ),
              child: Text("Revivir"),
            ),
          ],
        ),
      ),
    );
  }
}
