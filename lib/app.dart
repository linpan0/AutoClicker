import 'package:auto_clicker/home.dart';
import 'package:auto_clicker/theme.dart';
import 'package:auto_clicker/util.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Use with Google Fonts package to use downloadable fonts
    final textTheme = createTextTheme(context, "Inter Tight", "Inter");

    final theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AutoClicker",
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const Home(title: "AutoClicker"),
    );
  }
}
