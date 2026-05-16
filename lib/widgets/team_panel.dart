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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 420;
          final isVeryCompact = constraints.maxHeight < 300;
          final isNarrow = constraints.maxWidth < 260;
          final scoreSize = isVeryCompact
              ? 34.0
              : isCompact
                  ? 42.0
                  : 64.0;

          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isVeryCompact ? 4 : isCompact ? 6 : 8),
                  color: widget.color,
                  child: Column(
                    children: [
                      Text(
                        widget.teamName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.players,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: isVeryCompact ? 11 : isCompact ? 12 : 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isVeryCompact ? 4 : 8,
                      vertical: isVeryCompact ? 2 : 6,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: isVeryCompact ? 56 : 72,
                          child: _scoreHistory(isCompact, isVeryCompact),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${widget.score}',
                                style: TextStyle(
                                  fontSize: scoreSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(isVeryCompact ? 4 : isCompact ? 6 : 8),
                  child: isVeryCompact
                      ? Row(
                          children: [
                            Expanded(child: _pointsField(isCompact, isVeryCompact)),
                            const SizedBox(width: 6),
                            Expanded(child: _addButton(isCompact, isVeryCompact)),
                            const SizedBox(width: 6),
                            Expanded(child: _undoButton(isCompact, isVeryCompact)),
                          ],
                        )
                      : isNarrow
                      ? Column(
                          children: [
                            _pointsField(isCompact, isVeryCompact),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(child: _addButton(isCompact, isVeryCompact)),
                                const SizedBox(width: 6),
                                Expanded(child: _undoButton(isCompact, isVeryCompact)),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _pointsField(isCompact, isVeryCompact)),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                _addButton(isCompact, isVeryCompact),
                                const SizedBox(height: 6),
                                _undoButton(isCompact, isVeryCompact),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _pointsField(bool isCompact, bool isVeryCompact) {
    return SizedBox(
      height: isVeryCompact ? 34 : isCompact ? 40 : 48,
      child: TextField(
        controller: puntosController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => agregarPuntos(),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Puntos',
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      ),
    );
  }

  Widget _scoreHistory(bool isCompact, bool isVeryCompact) {
    if (widget.puntos.isEmpty) {
      return Center(
        child: Text(
          '+0',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: isVeryCompact ? 12 : 14,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.puntos.length,
      itemBuilder: (context, index) {
        final puntos = widget.puntos[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Text(
            '+$puntos',
            maxLines: 1,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isVeryCompact
                  ? 13
                  : isCompact
                      ? 15
                      : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Widget _addButton(bool isCompact, bool isVeryCompact) {
    return SizedBox(
      height: isVeryCompact ? 32 : isCompact ? 34 : 38,
      child: ElevatedButton(
        onPressed: agregarPuntos,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        child: const FittedBox(child: Text('Agregar')),
      ),
    );
  }

  Widget _undoButton(bool isCompact, bool isVeryCompact) {
    return SizedBox(
      height: isVeryCompact ? 32 : isCompact ? 34 : 38,
      child: ElevatedButton(
        onPressed: widget.onUndo,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        child: const FittedBox(child: Text('Deshacer')),
      ),
    );
  }
}
