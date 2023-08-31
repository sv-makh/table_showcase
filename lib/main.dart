import 'package:flutter/material.dart';
import 'package:tables_showcase/pages/crud_table/crud_table_page.dart';
import 'package:tables_showcase/pages/data_table_2_page.dart';
import 'package:tables_showcase/pages/data_table_page.dart';
import 'package:tables_showcase/pages/davi_page.dart';
import 'package:tables_showcase/pages/my_home_page.dart';
import 'package:tables_showcase/pages/pluto_grid_page.dart';
import 'package:tables_showcase/pages/responsive_table_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tables_showcase/pages/scrollable_table_view/scrollable_table_view_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tables_showcase/pages/spreadsheet_ui_page.dart';
import 'package:tables_showcase/pages/syncfusion_datagrid/syncfusion_page.dart';

void main() {
  runApp(const ProviderScope(child: const MyApp()),);
}

class MyApp extends StatelessWidget {
  const MyApp();

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
        '/responsive_table': (context) => ResponsiveTablePage(),
        '/crud_table': (context) => CrudTablePage(),
        '/scrollable_table_view': (context) => ScrollableTableViewPage(),
        //'/paged_datatable_page': (context) => PagedDatatablePage(),
        '/syncfusion_flutter_datagrid': (context) => SyncfusionPage(),
        '/spreadsheet_ui': (context) => SpreadsheetUiPage(),
        '/pluto_grid': (context) => PlutoGridPage(),
        '/davi': (context) => DaviPage(),
      },
    );
  }
}
