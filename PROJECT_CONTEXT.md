# Estado del Proyecto

## Tecnologías
- Flutter
- Dart

## Sistema Operativo
- Windows 11

## Herramientas utilizadas
- VS Code (última versión)
- Flutter
- SDK Android
- Android Studio
- Dart

## Carpetas creadas a partir de BUILD en flutter: e:\raulo_domino\lib\
- screens
- services
- widgets
- models

## Estructura \lib\
- screens\setup_screen.dart
- screens\home_screen.dart
- widgets\team_panel.dart

## Funcionalidades actuales
- Rotaciones automáticas
- Tabla general
- Deshacer
- Confirmación
- Diferencial de puntos (llamado puntosencontra en backend)
- Resultados
- Lógica correcta

## Reglas del torneo

- Son 4 jugadores en equipo de dos (parejas)
- El torneo consta de 3 partidas.
- Cada jugador juega con todos los demás jugadores.
- La partida termina al llegar a 100 puntos o más.
- El ganador obtiene:
  - 6 pts si el rival termina en 0
  - 5 pts si el rival termina entre 1 y 50
  - 4 pts si el rival termina con más de 50
- El perdedor obtiene:
  - 0 pts
  - 1 pt
  - 2 pts respectivamente
- 50 exactos todavía cuenta como 5-1.
- El desempate global se decide por diferencial de puntos.

## Estado actual

- MVP funcional completo
- Sistema estable
- UI básica funcional
- Proyecto conectado a GitHub (https://github.com/markezz3/raulo-domino-torneo.git)

## Flujo actual

1. Usuario captura nombres
2. Se inicia torneo
3. Se juega partida
4. Se capturan puntos manualmente
5. Se confirma ganador
6. Se calculan puntos automáticamente
7. Se rota la siguiente partida
8. Al finalizar se muestra ganador global
9. Se pide de nuevo la pantalla de captura de nombres

## Próximos pasos

- Mejorar UI
- Animaciones
- Persistencia local
- Guardar historial de torneos
- Exportar resultados
- Publicación Play Store
- licencias

## Arquitectura

- setup_screen.dart:
  Configuración inicial del torneo.

- home_screen.dart:
  Lógica principal del torneo.

- team_panel.dart:
  Widget reutilizable de equipos.
