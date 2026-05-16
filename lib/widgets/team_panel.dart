import 'package:flutter/material.dart';

class TeamPanel extends StatefulWidget {
  final String teamName;
  final String players;
  final int score;
  final List<int> puntos;
  final Color color;
  final Function(int) onAddPoints;
  final VoidCallback onUndo;

  const TeamPanel({
    super.key,
    required this.teamName,
    required this.players,
    required this.score,
    required this.puntos,
    required this.color,
    required this.onAddPoints,
    required this.onUndo,
  });

  @override
  State<TeamPanel> createState() => _TeamPanelState();
}

class _TeamPanelState extends State<TeamPanel> {
  final TextEditingController puntosController = TextEditingController();

  void agregarPuntos() {
    final puntos = int.tryParse(puntosController.text) ?? 0;

    if (puntos > 0) {
      widget.onAddPoints(puntos);
      puntosController.clear();
    }
  }

  @override
  void dispose() {
    puntosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all()),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: widget.color,
              child: Column(
                children: [
                  Text(
                    widget.teamName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.players),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: widget.puntos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                          child: Text(
                            widget.puntos[index].toString(),
                            style: const TextStyle(fontSize: 22),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '${widget.score}',
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: puntosController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Puntos',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: agregarPuntos,
                        child: const Text('Agregar'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: widget.onUndo,
                        child: const Text('Deshacer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ], // children
        ),
      ),
    );
  } // build
} // class TeamPanel
