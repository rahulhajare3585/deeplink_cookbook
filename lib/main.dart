import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deeplink_cookbook/my_home_page.dart';
import 'package:deeplink_cookbook/second_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialRoute = await getLastRoute();
  runApp(MyApp(initialRoute: initialRoute));
}

// Function to get the last route from SharedPreferences
Future<String> getLastRoute() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastRoute') ?? '/';
}

// Function to save the last route to SharedPreferences
Future<void> saveLastRoute(String route) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastRoute', route);
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: initialRoute, // Set the initial route
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const MyHomePage(title: 'Flutter Demo Home Page'),
          routes: [
            GoRoute(
              path: 'details',
              builder: (context, state) => const SecondPage(),
            ),
          ],
        ),
      ],
      // Save the last route on navigation
      redirect: (context, state) async {
        await saveLastRoute(
            state.uri.toString()); // Use state.uri.toString() instead
        return null;
      },
    );

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
