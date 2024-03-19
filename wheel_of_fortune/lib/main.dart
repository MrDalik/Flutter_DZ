import 'package:flutter/material.dart';
import 'package:flutter_dz/pages/random_item_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final uri = Uri.tryParse(settings.name ?? '');

        return MaterialPageRoute(
          builder: (context) => RandomItemPage(
            namesInput: uri?.queryParametersAll['name'] ?? ['Влад','Ваня','Петя'],
          ),
        );
      },
    );
  }
}
