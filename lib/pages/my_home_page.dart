import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage();

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
            const Text('Packages:', style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/data_table_2');
              },
              child: Text('data_table_2'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/responsive_table');
              },
              child: Text('responsive_table'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/crud_table');
              },
              child: Text('crud_table'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scrollable_table_view');
              },
              child: Text('scrollable_table_view'),
            ),
          ],
        ),
      ),
    );
  }
}
