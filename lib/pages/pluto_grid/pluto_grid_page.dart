import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoGridPage extends StatefulWidget {
  const PlutoGridPage({super.key});

  @override
  State<PlutoGridPage> createState() => _PlutoGridPageState();
}

class _PlutoGridPageState extends State<PlutoGridPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pluto_grid')),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString("jsonformatter.txt"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = jsonDecode(snapshot.data!);
            _getTableData(data["data"]["instancesWithRelation"]);
            //return PlutoGrid(columns: columns, rows: rows);
            return Text(data["data"]["instancesWithRelation"][0]["id"]);
          } else {
            return Center(child: Text('something went wrong'));
          }
        },
      ),
    );
  }

  Map<String, String> columnTitles = {
    'Наименование': 'name',
    'id не Онтологического продукта': 'id',
    'с:описание продукта': 'description',
    'с:системный код': 'code',
  };

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  void _getTableData(List<dynamic> data) {
    Set<String> columnNames = {};

    for (var el in data) {
      Map<String, PlutoCell> cells = {};

      List<dynamic> attributes = el["attributes"];
      print('ROW');
      for (var attr in attributes) {
        String? name = attr["name"];
        String? value = attr["value"];
        cells[columnTitles[name]!] = PlutoCell(value: value);
        print('${columnTitles[name]} - $value');
        //columnNames.add(name!);
      }

      print('attributes = ${attributes.length} cells.length = ${cells.length}');
      PlutoRow row = PlutoRow(cells: cells);
      rows.add(row);
      cells.clear();
    }

    for (var k in columnTitles.keys) {
      columns.add(PlutoColumn(title: k, field: columnTitles[k]!, type: PlutoColumnType.text()));
    }

    print('columns ${columns.length}');
  }
}
