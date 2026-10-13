import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await AppController.create();
  runApp(MyApp(controller: controller));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final dark = controller.darkMode;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'World News Map',
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF6538),
              brightness: Brightness.light,
              surface: const Color(0xFFF2F6FA),
            ),
            scaffoldBackgroundColor: const Color(0xFFF2F6FA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF2F6FA),
              foregroundColor: Color(0xFF10243A),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF6538),
              brightness: Brightness.dark,
              surface: const Color(0xFF071B2D),
            ),
            scaffoldBackgroundColor: const Color(0xFF071B2D),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF071B2D),
              foregroundColor: Colors.white,
            ),
          ),
          pageTransitionsTheme: controller.reduceMotion
              ? PageTransitionsTheme(
                  builders: {
                    for (final platform in TargetPlatform.values)
                      platform: const _NoAnimationPageTransitionsBuilder(),
                  },
                )
              : const PageTransitionsTheme(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(controller.largeText ? 1.12 : 1),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
          home: HomeScreen(controller: controller),
        );
      },
    );
  }
}

class _NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const _NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      child;
}
