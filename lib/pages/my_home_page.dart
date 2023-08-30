import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/data_table');
              },
              child: Text('DataTable / PaginatedDataTable widgets'),
            ),
            const SizedBox(height: 10),
            const Text('Packages:'),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/data_table_2');
              },
              child: Text('data_table_2'),
            ),
          ],
        ),
      ),
    );
  }
}
