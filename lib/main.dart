import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'features/home/screens/splash_screen.dart';
import 'features/journal/bloc/journal_bloc.dart';
import 'features/journal/bloc/journal_event.dart';
import 'features/journal/repository/journal_repository.dart';
import 'utils/constants/colors.dart';

late final Box<dynamic> journalBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  journalBox = await Hive.openBox<dynamic>('journals');
  runApp(const EchoInkApp());
}

class EchoInkApp extends StatelessWidget {
  const EchoInkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return JournalBloc(HiveJournalRepository(journalBox))..add(const LoadJournals());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EchoInk',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFD5A7FF),
            brightness: Brightness.dark,
            surface: AppColors.surface,
          ),
          scaffoldBackgroundColor: AppColors.background,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
