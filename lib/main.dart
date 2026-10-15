import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const AdivinaNumeroApp());
}

class AdivinaNumeroApp extends StatelessWidget {
  const AdivinaNumeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina el Número',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        fontFamily: 'Roboto',
      ),
      home: const AdivinaNumeroPage(),
    );
  }
}

enum Dificultad { facil, normal, dificil }

class IntentoRegistro {
  final int numero;
  final String resultado;
  final Color color;

  IntentoRegistro({
    required this.numero,
    required this.resultado,
    required this.color,
  });
}

class AdivinaNumeroPage extends StatefulWidget {
  const AdivinaNumeroPage({super.key});

  @override
  State<AdivinaNumeroPage> createState() => _AdivinaNumeroPageState();
}

class _AdivinaNumeroPageState extends State<AdivinaNumeroPage>
    with SingleTickerProviderStateMixin {
  late int _numeroSecreto;
  int _intentosRealizados = 0;
  late int _intentosMaximos;
  late int _intentosRestantes;
  late int _rangoMaximo;
  String _mensaje = '';
  String? _pista;

  Dificultad _dificultad = Dificultad.facil;
  int? _mejorPuntaje;

  final TextEditingController _controller = TextEditingController();
  final List<IntentoRegistro> _historial = [];

  bool _juegoTerminado = false;
  bool _juegoPerdido = false;

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    _configurarDificultad(_dificultad);
    _iniciarJuego();
  }

  void _configurarDificultad(Dificultad dif) {
    _dificultad = dif;
    if (dif == Dificultad.facil) {
      _rangoMaximo = 50;
      _intentosMaximos = 7;
    } else if (dif == Dificultad.normal) {
      _rangoMaximo = 100;
      _intentosMaximos = 5;
    } else {
      _rangoMaximo = 200;
      _intentosMaximos = 4;
    }
  }

  void _iniciarJuego() {
    setState(() {
      _configurarDificultad(_dificultad);
      _numeroSecreto = Random().nextInt(_rangoMaximo) + 1;
      _intentosRealizados = 0;
      _intentosRestantes = _intentosMaximos;
      _mensaje = '🚀 ¡Adivina un número entre 1 y $_rangoMaximo!';
      _pista = null;
      _historial.clear();
      _juegoTerminado = false;
      _juegoPerdido = false;
      _controller.clear();
    });
    _animController.forward(from: 0.0);
  }

  void _solicitarPista() {
    if (_juegoTerminado || _juegoPerdido) return;

    if (_intentosRestantes <= 1) {
      _mostrarAlerta('⚠️ No te quedan intentos suficientes para usar la pista.', Colors.orange);
      return;
    }

    setState(() {
      _intentosRestantes--;
      final esPar = _numeroSecreto % 2 == 0;
      _pista = esPar ? '💡 Pista: ¡El número es PAR!' : '💡 Pista: ¡El número es IMPAR!';
      _mostrarAlerta('🔎 Pista activada (-1 intento)', Colors.blueGrey);
    });
  }

  void _verificarAdivinanza() {
    if (_juegoTerminado || _juegoPerdido) return;

    final String texto = _controller.text.trim();
    if (texto.isEmpty) {
      _mostrarAlerta('✍️ ¡Por favor ingresa un número!', Colors.amber.shade800);
      return;
    }

    final int? adivinanza = int.tryParse(texto);
    if (adivinanza == null || adivinanza < 1 || adivinanza > _rangoMaximo) {
      _mostrarAlerta('⚠️ Ingresa un número válido entre 1 y $_rangoMaximo', Colors.orange.shade800);
      return;
    }

    setState(() {
      _intentosRealizados++;
      _intentosRestantes--;
      _controller.clear();

      if (adivinanza == _numeroSecreto) {
        _mensaje = '🏆 ¡GENIAL! ¡ADIVINASTE! 🏆\nLo lograste en $_intentosRealizados intentos.';
        _juegoTerminado = true;
        _historial.insert(
          0,
          IntentoRegistro(numero: adivinanza, resultado: '¡Exacto! 🎉', color: Colors.green),
        );

        if (_mejorPuntaje == null || _intentosRealizados < _mejorPuntaje!) {
          _mejorPuntaje = _intentosRealizados;
        }
      } else if (_intentosRestantes == 0) {
        _mensaje = '💥 ¡FIN DEL JUEGO! 💥\nEl número secreto era el $_numeroSecreto.';
        _juegoPerdido = true;
        _historial.insert(
          0,
          IntentoRegistro(
            numero: adivinanza,
            resultado: adivinanza < _numeroSecreto ? 'Muy bajo' : 'Muy alto',
            color: Colors.red,
          ),
        );
      } else if (adivinanza < _numeroSecreto) {
        _mensaje = '📈 ¡Más ALTO! Te quedan $_intentosRestantes intentos';
        _historial.insert(
          0,
          IntentoRegistro(numero: adivinanza, resultado: 'Muy bajo ⬆️', color: Colors.deepOrange),
        );
      } else {
        _mensaje = '📉 ¡Más BAJO! Te quedan $_intentosRestantes intentos';
        _historial.insert(
          0,
          IntentoRegistro(numero: adivinanza, resultado: 'Muy alto ⬇️', color: Colors.indigo),
        );
      }
    });

    _animController.forward(from: 0.0);
  }

  void _mostrarAlerta(String mensaje, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _obtenerColorProgreso() {
    final double fraccion = _intentosRestantes / _intentosMaximos;
    if (fraccion > 0.5) return Colors.teal;
    if (fraccion > 0.25) return Colors.amber.shade700;
    return Colors.redAccent;
  }

  Color _obtenerColorMensaje() {
    if (_juegoTerminado) return Colors.green.shade800;
    if (_juegoPerdido) return Colors.red.shade800;
    if (_mensaje.contains('ALTO')) return Colors.deepOrange.shade800;
    if (_mensaje.contains('BAJO')) return Colors.indigo.shade800;
    return Colors.teal.shade900;
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progreso = (_intentosRestantes / _intentosMaximos).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Adivina el Número Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 3,
        actions: [
          IconButton(
            tooltip: 'Reiniciar Partida',
            icon: const Icon(Icons.refresh),
            onPressed: _iniciarJuego,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selector de Dificultad (Nivel 3)
              SegmentedButton<Dificultad>(
                segments: const [
                  ButtonSegment(
                    value: Dificultad.facil,
                    label: Text('Fácil (1-50)'),
                    icon: Icon(Icons.sentiment_satisfied),
                  ),
                  ButtonSegment(
                    value: Dificultad.normal,
                    label: Text('Medio (1-100)'),
                    icon: Icon(Icons.bolt),
                  ),
                  ButtonSegment(
                    value: Dificultad.dificil,
                    label: Text('Difícil (1-200)'),
                    icon: Icon(Icons.local_fire_department),
                  ),
                ],
                selected: {_dificultad},
                onSelectionChanged: (nuevaSeleccion) {
                  setState(() {
                    _dificultad = nuevaSeleccion.first;
                    _iniciarJuego();
                  });
                },
              ),
              const SizedBox(height: 16),

              // Récord
              if (_mejorPuntaje != null)
                Center(
                  child: Chip(
                    avatar: const Icon(Icons.star, color: Colors.amber),
                    label: Text(
                      'Récord actual: $_mejorPuntaje ${_mejorPuntaje == 1 ? 'intento' : 'intentos'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.amber.shade50,
                  ),
                ),
              const SizedBox(height: 12),

              // Icono animado
              Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _obtenerColorProgreso().withOpacity(0.25),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      _juegoTerminado
                          ? Icons.emoji_events
                          : (_juegoPerdido ? Icons.sentiment_very_dissatisfied : Icons.casino),
                      size: 56,
                      color: _juegoTerminado
                          ? Colors.amber.shade700
                          : (_juegoPerdido ? Colors.red : Colors.teal),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mensaje principal con AnimatedContainer (Nivel 3)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _obtenerColorMensaje().withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _mensaje,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _obtenerColorMensaje(),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Pista mostrada si se solicita
              if (_pista != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _pista!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),

              // Barra de progreso y contador (Nivel 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Intentos:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '$_intentosRestantes de $_intentosMaximos restantes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _obtenerColorProgreso(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progreso,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(_obtenerColorProgreso()),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de entrada
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                enabled: !_juegoTerminado && !_juegoPerdido,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Ingresa tu número',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.edit, color: Colors.teal),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _controller.clear(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.teal.shade200),
                  ),
                ),
                onSubmitted: (_) => _verificarAdivinanza(),
              ),
              const SizedBox(height: 14),

              // Botones de acción (Adivinar y Pista)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: (_juegoTerminado || _juegoPerdido) ? null : _verificarAdivinanza,
                      icon: const Icon(Icons.check),
                      label: const Text('Adivinar', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      onPressed: (_juegoTerminado || _juegoPerdido || _pista != null)
                          ? null
                          : _solicitarPista,
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text('Pista'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.amber.shade900,
                        side: BorderSide(color: Colors.amber.shade700),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Botón de nuevo juego si terminó
              if (_juegoTerminado || _juegoPerdido)
                ElevatedButton.icon(
                  onPressed: _iniciarJuego,
                  icon: const Icon(Icons.replay),
                  label: const Text('Jugar de nuevo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

              const SizedBox(height: 16),

              // Historial de intentos (Nivel 2)
              if (_historial.isNotEmpty) ...[
                const Text(
                  'Historial de intentos:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: _historial.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _historial[index];
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: item.color.withOpacity(0.15),
                          child: Text(
                            '${item.numero}',
                            style: TextStyle(color: item.color, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(item.resultado, style: TextStyle(color: item.color)),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
