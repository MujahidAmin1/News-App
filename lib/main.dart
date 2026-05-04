import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:news_app/features/articles/model/source_adapter.dart';
import 'package:news_app/features/nav_bar/navbar.dart';
import 'package:news_app/hive_registrar.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Try loading from assets folder first (bundled directory)
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    try {
      // Fallback to root (for legacy local setups)
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint("Info: No .env file found. Using environment variables via --dart-define.");
    }
  }
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(SourceAdapter());
  }
  Hive.registerAdapters();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F1724)),
        scaffoldBackgroundColor: const Color(0xFF0B0F16),
        useMaterial3: true,
      ),
      home: Navbar(),
    );
  }
}
