import 'package:flutter/material.dart';
import 'home_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController jugador1Controller = TextEditingController();
  final TextEditingController jugador2Controller = TextEditingController();
  final TextEditingController jugador3Controller = TextEditingController();
  final TextEditingController jugador4Controller = TextEditingController();

  void iniciarTorneo() {
    final jugador1 = jugador1Controller.text.trim().isEmpty
        ? 'Jugador 1'
        : jugador1Controller.text.trim();
    final jugador2 = jugador2Controller.text.trim().isEmpty
        ? 'Jugador 2'
        : jugador2Controller.text.trim();
    final jugador3 = jugador3Controller.text.trim().isEmpty
        ? 'Jugador 3'
        : jugador3Controller.text.trim();
    final jugador4 = jugador4Controller.text.trim().isEmpty
        ? 'Jugador 4'
        : jugador4Controller.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          jugador1: jugador1,
          jugador2: jugador2,
          jugador3: jugador3,
          jugador4: jugador4,
        ),
      ),
    );
  }

  @override
  void dispose() {
    jugador1Controller.dispose();
    jugador2Controller.dispose();
    jugador3Controller.dispose();
    jugador4Controller.dispose();
    super.dispose();
  }

  Widget campoJugador(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Torneo')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 700
                ? 560.0
                : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        campoJugador('Jugador 1', jugador1Controller),
                        campoJugador('Jugador 2', jugador2Controller),
                        campoJugador('Jugador 3', jugador3Controller),
                        campoJugador('Jugador 4', jugador4Controller),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: iniciarTorneo,
                            child: const Text(
                              'Iniciar Torneo',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
