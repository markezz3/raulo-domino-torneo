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
              ? 30.0
              : isCompact
              ? 38.0
              : 48.0;

          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isVeryCompact ? 6 : 10,
                    vertical: isVeryCompact
                        ? 4
                        : isCompact
                        ? 6
                        : 8,
                  ),
                  color: widget.color,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.teamName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.players,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isVeryCompact
                                    ? 11
                                    : isCompact
                                    ? 12
                                    : 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isVeryCompact ? 8 : 14),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isVeryCompact ? 8 : 14,
                      vertical: isVeryCompact ? 6 : 10,
                    ),
                    child: _scoreHistory(isCompact, isVeryCompact),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    isVeryCompact
                        ? 4
                        : isCompact
                        ? 6
                        : 8,
                  ),
                  child: isVeryCompact
                      ? Row(
                          children: [
                            Expanded(
                              child: _pointsField(isCompact, isVeryCompact),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _addButton(isCompact, isVeryCompact),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _undoButton(isCompact, isVeryCompact),
                            ),
                          ],
                        )
                      : isNarrow
                      ? Column(
                          children: [
                            _pointsField(isCompact, isVeryCompact),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: _addButton(isCompact, isVeryCompact),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: _undoButton(isCompact, isVeryCompact),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: _pointsField(isCompact, isVeryCompact),
                            ),
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
      height: isVeryCompact
          ? 34
          : isCompact
          ? 40
          : 48,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 260
            ? 3
            : constraints.maxWidth < 420
            ? 4
            : 5;

        return GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.puntos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: isVeryCompact ? 2.8 : 3.4,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            final puntos = widget.puntos[index];

            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.45),
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '+$puntos',
                maxLines: 1,
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
      },
    );
  }

  Widget _addButton(bool isCompact, bool isVeryCompact) {
    return SizedBox(
      height: isVeryCompact
          ? 32
          : isCompact
          ? 34
          : 38,
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
      height: isVeryCompact
          ? 32
          : isCompact
          ? 34
          : 38,
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
