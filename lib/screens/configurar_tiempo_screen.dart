import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurarTiempoScreen extends StatefulWidget {
  @override
  _ConfigurarTiempoScreenState createState() => _ConfigurarTiempoScreenState();
}

class _ConfigurarTiempoScreenState extends State<ConfigurarTiempoScreen> {
  Duration _tiempoRestante = Duration(hours: 24);
  bool _contadorActivo = false;
  bool _pausado = false;
  Timer? _timer;
  DateTime? _inicioTiempo;

  @override
  void initState() {
    super.initState();
    _cargarTiempoGuardado();
  }

  Future<void> _cargarTiempoGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    int? tiempoGuardado = prefs.getInt('tiempo_restante');
    bool? estadoPausado = prefs.getBool('estado_pausado');
    int? inicioGuardado = prefs.getInt('inicio_tiempo');

    setState(() {
      if (tiempoGuardado != null && tiempoGuardado > 0) {
        _contadorActivo = true;
        _pausado = estadoPausado ?? false;
        _inicioTiempo = inicioGuardado != null ? DateTime.fromMillisecondsSinceEpoch(inicioGuardado) : DateTime.now();

        if (!_pausado) {
          Duration tiempoTranscurrido = DateTime.now().difference(_inicioTiempo!);
          _tiempoRestante = Duration(seconds: tiempoGuardado) - tiempoTranscurrido;

          if (_tiempoRestante.isNegative) {
            _tiempoRestante = Duration(seconds: 0);
            _contadorActivo = false;
          }
        } else {
          _tiempoRestante = Duration(seconds: tiempoGuardado);
        }
      } else {
        _contadorActivo = false;
        _tiempoRestante = Duration(hours: 24);
      }
    });

    if (_contadorActivo && !_pausado) {
      _iniciarTemporizador();
    }
  }

  void _iniciarCuentaRegresiva() async {
    if (_contadorActivo) return;

    setState(() {
      _contadorActivo = true;
      _pausado = false;
      _tiempoRestante = Duration(hours: 24);
      _inicioTiempo = DateTime.now();
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tiempo_restante', _tiempoRestante.inSeconds);
    await prefs.setBool('estado_pausado', false);
    await prefs.setInt('inicio_tiempo', _inicioTiempo!.millisecondsSinceEpoch);

    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_tiempoRestante.inSeconds > 0 && !_pausado) {
        setState(() {
          _tiempoRestante -= Duration(seconds: 1);
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('tiempo_restante', _tiempoRestante.inSeconds);
      } else {
        timer.cancel();
      }
    });
  }

  void _pausarCuenta() async {
    setState(() {
      _pausado = true;
    });

    _timer?.cancel();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('estado_pausado', true);
  }

  void _continuarCuenta() async {
    setState(() {
      _pausado = false;
      _inicioTiempo = DateTime.now();
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('estado_pausado', false);
    await prefs.setInt('inicio_tiempo', _inicioTiempo!.millisecondsSinceEpoch);

    _iniciarTemporizador();
  }

  void _reiniciarCuenta() async {
    setState(() {
      _contadorActivo = false;
      _pausado = false;
      _tiempoRestante = Duration(hours: 24);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tiempo_restante');
    await prefs.remove('estado_pausado');
    await prefs.remove('inicio_tiempo');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurar Tiempo de Retos"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Configurar Tiempo de Retos",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Tendrás 24 h para realizar los retos. Si no los cumples en ese plazo, perderás puntos de vida.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            _contadorActivo
                ? Column(
              children: [
                Text(
                  "${_tiempoRestante.inHours.toString().padLeft(2, '0')}:${(_tiempoRestante.inMinutes % 60).toString().padLeft(2, '0')}:${(_tiempoRestante.inSeconds % 60).toString().padLeft(2, '0')}",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _pausado ? null : _pausarCuenta,
                      child: Text("Pausar"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _pausado ? _continuarCuenta : null,
                      child: Text("Continuar"),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _reiniciarCuenta,
                  child: Text("He acabado los retos"),
                ),
              ],
            )
                : ElevatedButton(
              onPressed: _iniciarCuentaRegresiva,
              child: Text("Iniciar Cuenta Regresiva"),
            ),
          ],
        ),
      ),
    );
  }
}
