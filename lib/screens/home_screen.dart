import 'package:flutter/material.dart';
import '../widgets/team_panel.dart';

class HomeScreen extends StatefulWidget {
  final String jugador1;
  final String jugador2;
  final String jugador3;
  final String jugador4;

  const HomeScreen({
    super.key,
    required this.jugador1,
    required this.jugador2,
    required this.jugador3,
    required this.jugador4,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, String>> partidas;
  late Map<String, int> puntosTorneo;
  late Map<String, int> puntosEnContra;

  @override
  void initState() {
    super.initState();

    partidas = [
      {
        'equipo1': '${widget.jugador1} + ${widget.jugador2}',

        'equipo2': '${widget.jugador3} + ${widget.jugador4}',
      },

      {
        'equipo1': '${widget.jugador1} + ${widget.jugador3}',

        'equipo2': '${widget.jugador2} + ${widget.jugador4}',
      },

      {
        'equipo1': '${widget.jugador1} + ${widget.jugador4}',

        'equipo2': '${widget.jugador2} + ${widget.jugador3}',
      },
    ];

    puntosTorneo = {
      widget.jugador1: 0,
      widget.jugador2: 0,
      widget.jugador3: 0,
      widget.jugador4: 0,
    };

    puntosEnContra = {
      widget.jugador1: 0,
      widget.jugador2: 0,
      widget.jugador3: 0,
      widget.jugador4: 0,
    };
  }

  List<int> puntosEquipo1 = [];
  List<int> puntosEquipo2 = [];
  int numeroPartida = 1;

  int get totalEquipo1 {
    return puntosEquipo1.fold(0, (total, item) => total + item);
  }

  int get totalEquipo2 {
    return puntosEquipo2.fold(0, (total, item) => total + item);
  }

  void sumarEquipo1(int puntos) {
    setState(() {
      puntosEquipo1.add(puntos);
    });
    verificarGanador();
  }

  void deshacerEquipo1() {
    if (puntosEquipo1.isEmpty) return;

    setState(() {
      puntosEquipo1.removeLast();
    });
  }

  void sumarEquipo2(int puntos) {
    setState(() {
      puntosEquipo2.add(puntos);
    });
    verificarGanador();
  }

  void deshacerEquipo2() {
    if (puntosEquipo2.isEmpty) return;

    setState(() {
      puntosEquipo2.removeLast();
    });
  }

  void verificarGanador() {
    if (totalEquipo1 < 100 && totalEquipo2 < 100) return;

    final ganadorPartida = totalEquipo1 >= 100 ? 'Equipo 1' : 'Equipo 2';
    final scorePerdedor = totalEquipo1 >= 100 ? totalEquipo2 : totalEquipo1;

    int puntosGanador;
    int puntosPerdedor;

    if (scorePerdedor == 0) {
      puntosGanador = 6;
      puntosPerdedor = 0;
    } else if (scorePerdedor <= 50) {
      puntosGanador = 5;
      puntosPerdedor = 1;
    } else {
      puntosGanador = 4;
      puntosPerdedor = 2;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Partida Terminada'),
          content: Text(
            '$ganadorPartida gano la partida\n\n'
            'Resultado:\n'
            '$puntosGanador pts vs $puntosPerdedor pts',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (totalEquipo1 >= 100 && puntosEquipo1.isNotEmpty) {
                    puntosEquipo1.removeLast();
                  }

                  if (totalEquipo2 >= 100 && puntosEquipo2.isNotEmpty) {
                    puntosEquipo2.removeLast();
                  }
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Regresar'),
            ),
            ElevatedButton(
              onPressed: () {
                final esUltimaPartida = numeroPartida == 3;

                Navigator.pop(dialogContext);

                setState(() {
                  registrarResultadoTorneo(
                    puntosGanador: puntosGanador,
                    puntosPerdedor: puntosPerdedor,
                    scoreEquipo1: totalEquipo1,
                    scoreEquipo2: totalEquipo2,
                  );

                  puntosEquipo1.clear();
                  puntosEquipo2.clear();

                  if (numeroPartida < 3) {
                    numeroPartida++;
                  }
                });

                if (esUltimaPartida) {
                  final ganador = obtenerGanadorTorneo();

                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (!mounted) return;

                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Torneo Finalizado'),
                          content: Text('El ganador es:\n\n$ganador'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void registrarResultadoTorneo({
    required int puntosGanador,
    required int puntosPerdedor,
    required int scoreEquipo1,
    required int scoreEquipo2,
  }) {
    final equipo1 = partidas[numeroPartida - 1]['equipo1']!.split(' + ');
    final equipo2 = partidas[numeroPartida - 1]['equipo2']!.split(' + ');

    if (scoreEquipo1 > scoreEquipo2) {
      for (final jugador in equipo1) {
        puntosTorneo[jugador] = puntosTorneo[jugador]! + puntosGanador;
        puntosEnContra[jugador] = puntosEnContra[jugador]! + scoreEquipo2;
      }

      for (final jugador in equipo2) {
        puntosTorneo[jugador] = puntosTorneo[jugador]! + puntosPerdedor;
      }
    } else {
      for (final jugador in equipo2) {
        puntosTorneo[jugador] = puntosTorneo[jugador]! + puntosGanador;
        puntosEnContra[jugador] = puntosEnContra[jugador]! + scoreEquipo1;
      }

      for (final jugador in equipo1) {
        puntosTorneo[jugador] = puntosTorneo[jugador]! + puntosPerdedor;
      }
    }
  }

  String obtenerGanadorTorneo() {
    final jugadores = puntosTorneo.keys.toList();

    jugadores.sort((a, b) {
      final puntosA = puntosTorneo[a]!;
      final puntosB = puntosTorneo[b]!;

      if (puntosA != puntosB) {
        return puntosB.compareTo(puntosA);
      }

      return puntosEnContra[a]!.compareTo(puntosEnContra[b]!);
    });

    return jugadores.first;
  }

  void reiniciarMarcador() {
    setState(() {
      puntosEquipo1.clear();
      puntosEquipo2.clear();
    });
  }

  void reiniciarTorneo() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Raulo Domino - Torneo')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 620;
            final isShort = constraints.maxHeight < 700;
            final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
            final hideTable = keyboardOpen || (isNarrow && isShort);
            final padding = isShort ? 8.0 : 12.0;

            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  _partidaHeader(isShort),
                  SizedBox(height: isShort ? 6 : 10),
                  Expanded(
                    flex: isShort ? 7 : 6,
                    child: isNarrow
                        ? Column(children: _teamPanels())
                        : Row(children: _teamPanels()),
                  ),
                  SizedBox(height: isShort ? 6 : 10),
                  _actionButtons(),
                  if (!hideTable) ...[
                    SizedBox(height: isShort ? 8 : 12),
                    _tablaGeneral(isShort),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _partidaHeader(bool isShort) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isShort ? 8 : 12),
      color: Colors.grey[300],
      child: Center(
        child: Text(
          '$numeroPartida Partida',
          style: TextStyle(
            fontSize: isShort ? 22 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<Widget> _teamPanels() {
    return [
      TeamPanel(
        teamName: 'Equipo 1',
        players: partidas[numeroPartida - 1]['equipo1']!,
        puntos: puntosEquipo1,
        score: totalEquipo1,
        color: Colors.blue.shade100,
        onAddPoints: sumarEquipo1,
        onUndo: deshacerEquipo1,
      ),
      TeamPanel(
        teamName: 'Equipo 2',
        players: partidas[numeroPartida - 1]['equipo2']!,
        puntos: puntosEquipo2,
        score: totalEquipo2,
        color: Colors.red.shade100,
        onAddPoints: sumarEquipo2,
        onUndo: deshacerEquipo2,
      ),
    ];
  }

  Widget _actionButtons() {
    final buttons = [
      Expanded(
        child: ElevatedButton(
          onPressed: reiniciarMarcador,
          child: const FittedBox(
            child: Text(
              'Reiniciar Marcador',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
      Expanded(
        child: ElevatedButton(
          onPressed: reiniciarTorneo,
          child: const FittedBox(
            child: Text(
              'Nuevo Torneo',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    ];

    return SizedBox(
      height: 44,
      child: Row(
        children: [
          buttons[0],
          const SizedBox(width: 8),
          buttons[1],
        ],
      ),
    );
  }

  Widget _tablaGeneral(bool isShort) {
    return Expanded(
      flex: isShort ? 2 : 3,
      child: Column(
        children: [
          Text(
            'Tabla General',
            style: TextStyle(
              fontSize: isShort ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView(
              children: _jugadoresOrdenados().map((jugador) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      jugador,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Diferencial: ${puntosEnContra[jugador]}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      '${puntosTorneo[jugador]} pts',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _jugadoresOrdenados() {
    final jugadores = puntosTorneo.keys.toList();

    jugadores.sort((a, b) {
      final puntosA = puntosTorneo[a]!;
      final puntosB = puntosTorneo[b]!;

      if (puntosA != puntosB) {
        return puntosB.compareTo(puntosA);
      }

      return puntosEnContra[a]!.compareTo(puntosEnContra[b]!);
    });

    return jugadores;
  }
}
