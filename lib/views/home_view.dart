import 'package:flutter/material.dart';
import 'package:lap_timer_mvvm/utils/time_format.dart';
import 'package:lap_timer_mvvm/viewmodels/stopwatch_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StopwatchViewModel>();

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronômetro de Voltas'),
      ),
      body: SafeArea(
        child: Semantics(
          container: true,
          label:
              'Tela do cronômetro de voltas. Mostra tempo total e lista de voltas.',
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                
                Semantics(
                  label: 'Tempo decorrido',
                  value: vm.elapsedLabel,
                  liveRegion: true,
                  child: ExcludeSemantics(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        vm.elapsedLabel,
                        style: textTheme.displayMedium?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

              
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Semantics(
                      button: true,
                      label: vm.isRunning ? 'Pausar cronômetro' : 'Iniciar cronômetro',
                      child: ElevatedButton.icon(
                        onPressed: vm.toggle,
                        icon: Icon(vm.isRunning ? Icons.pause : Icons.play_arrow),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 48),
                        ),
                        label: Text(vm.isRunning ? 'Pausar' : 'Iniciar'),
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: 'Reiniciar cronômetro',
                      child: OutlinedButton.icon(
                        onPressed: vm.elapsed > Duration.zero ? vm.reset : null,
                        icon: const Icon(Icons.stop),
                        label: const Text('Reiniciar'),
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: 'Registrar volta',
                      child: FilledButton.icon(
                        onPressed: vm.isRunning ? vm.addLap : null,
                        icon: const Icon(Icons.flag),
                        label: const Text('Volta'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

           
                Semantics(
                  label:
                      'Lista de voltas. Cada item contém o número da volta, tempo da volta e tempo total.',
                  child: Expanded(
                    child: vm.laps.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhuma volta registrada',
                              style: textTheme.bodyLarge,
                            ),
                          )
                        : ListView.separated(
                            itemCount: vm.laps.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final lap = vm.laps[index];
                              final lapNo = vm.laps.length - index;
                              final lapStr = TimeFormat.mmssSSS(lap.lapDuration);
                              final totalStr = TimeFormat.mmssSSS(lap.totalElapsed);

                              return ListTile(
                                title: Text(
                                  'Volta $lapNo',
                                  semanticsLabel: 'Volta $lapNo',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  'Volta: $lapStr   •   Total: $totalStr',
                                  semanticsLabel:
                                      'Tempo da volta: $lapStr. Tempo total: $totalStr.',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
