import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lap_timer_mvvm/services/notification_service.dart';
import 'package:lap_timer_mvvm/viewmodels/stopwatch_viewmodel.dart';
import 'package:lap_timer_mvvm/views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();

  runApp(const LapTimerApp());
}

class LapTimerApp extends StatelessWidget {
  const LapTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0066CC),
      brightness: Brightness.light,
      contrastLevel: 1.0, // Flutter 3.22+
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StopwatchViewModel()),
      ],
      child: MaterialApp(
        title: 'Cronômetro de Voltas',
        theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
          textTheme: const TextTheme().apply(
        
            bodyColor: Colors.black87,
            displayColor: Colors.black87,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        home: const HomePage(),
      ),
    );
  }
}
