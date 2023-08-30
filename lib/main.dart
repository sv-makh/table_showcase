import 'package:flutter/material.dart';
import 'package:tables_showcase/pages/data_table_2_page.dart';
import 'package:tables_showcase/pages/data_table_page.dart';
import 'package:tables_showcase/pages/my_home_page.dart';

void main() {
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
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/': (context) => const MyHomePage(),
        '/data_table': (context) => const DataTablePage(),
        '/data_table_2': (context) => const DataTable2Page(),
      },
    );
  }
}
