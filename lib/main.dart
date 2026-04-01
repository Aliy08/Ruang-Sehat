import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/splash/splash_screen.dart';
import 'package:ruang_sehat/features/auth/presentation/screens/auth.screen.dart';
import 'package:ruang_sehat/features/auth/providers/auth_provider.dart';
import 'package:ruang_sehat/features/home/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.manjariTextTheme(),
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        AuthScreen.routeName: (context) => const AuthScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
    );
  }
}
