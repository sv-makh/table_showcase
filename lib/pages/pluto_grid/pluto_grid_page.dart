import 'dart:async';
import 'dart:convert';

import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoGridPage extends StatefulWidget {
  const PlutoGridPage({super.key});

  @override
  State<PlutoGridPage> createState() => _PlutoGridPageState();
}

class _PlutoGridPageState extends State<PlutoGridPage> {
  late PlutoGridStateManager stateManager;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  @override
  void initState() {
    super.initState();

    for (var k in columnTitles.keys) {
      columns.add(PlutoColumn(
          title: columnTitles[k]!, field: k, type: PlutoColumnType.text()));
    }

    final List<PlutoRow> _rows = [];

    DefaultAssetBundle.of(context).loadString("jsonformatter.txt").then((rawData) {
      Map<String, dynamic> data = jsonDecode(rawData);

      List<dynamic> instances = data["data"]["instancesWithRelation"];

      for (var element in instances) {
        Map<String, PlutoCell> cells = {};
        List<dynamic> attributes = element["attributes"];

        for (var attr in attributes) {
          String? name = attr["programName"];
          String? value = attr["value"];
          cells[name!] = PlutoCell(value: value);
        }
        PlutoRow row = PlutoRow(cells: cells);
        _rows.add(row);
      }

      return _rows;
    }).then((fetchedRows) {
      PlutoGridStateManager.initializeRowsAsync(columns, fetchedRows).then((value) {
        stateManager.refRows.addAll(value);
        stateManager.setShowLoading(false);
      });
    });
  }

  Future<List<PlutoRow>> fetchRows() async {
    final List<PlutoRow> _rows = [];

    DefaultAssetBundle.of(context).loadString("jsonformatter.txt").then((rawData) {
      Map<String, dynamic> data = jsonDecode(rawData);

      List<dynamic> instances = data["data"]["instancesWithRelation"];

      for (var element in instances) {
        Map<String, PlutoCell> cells = {};
        List<dynamic> attributes = element["attributes"];

        for (var attr in attributes) {
          String? name = attr["programName"];
          String? value = attr["value"];
          cells[name!] = PlutoCell(value: value);
        }
        PlutoRow row = PlutoRow(cells: cells);
        _rows.add(row);
      }
    });
    return _rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pluto_grid')),
      body: PlutoGrid(
        columns: columns,
        rows: rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager.setShowLoading(true);
          event.stateManager.setShowColumnFilter(true);
        },
          configuration: PlutoGridConfiguration(
              columnFilter: PlutoGridColumnFilterConfig(
                  filters: const [
                    //...FilterHelper.defaultFilters,
                    CustomFilter(),
                  ],
                  resolveDefaultColumnFilter: (column, resolver) {
                    /*if (column.field == 'text') {
                      return resolver<PlutoFilterTypeContains>()
                            as PlutoFilterType;
                      } else if (column.field == 'number') {
                      return resolver<PlutoFilterTypeGreaterThan>()
                      as PlutoFilterType;
                    } else if (column.field == 'date') {
                      return resolver<PlutoFilterTypeLessThan>()
                      as PlutoFilterType;
                    }
                    else if (column.field == 'select') {
                  return resolver<ClassYouImplemented>() as PlutoFilterType;
                }*/
                    return resolver<CustomFilter>() as PlutoFilterType;
                    /*return resolver<PlutoFilterTypeContains>()
                    as PlutoFilterType;*/
                  }))
      )
    );
  }

  Map<String, String> columnTitles = {
    'name': 'Наименование',
    'productId': 'id не Онтологического продукта',
    'description': 'с:описание продукта',
    'systemCode': 'с:системный код',
  };

}

class CustomFilter implements PlutoFilterType {
  @override
  String get title => 'Custom contains';

  @override
  get compare => ({
    required String? base,
    required String? search,
    required PlutoColumn? column,
  }) {
    return RegExp(
      RegExp.escape(search!),
      caseSensitive: false,
    ).hasMatch(base!);
  }; //FilterHelper.compareContains;

  const CustomFilter();
}
