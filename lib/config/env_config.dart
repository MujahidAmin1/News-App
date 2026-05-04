import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiKey {
    const fromEnv = String.fromEnvironment('API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    return dotenv.env['API_KEY'] ?? '';
  }
}