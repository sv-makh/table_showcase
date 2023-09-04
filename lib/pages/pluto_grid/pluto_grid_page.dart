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
  List<PlutoRow> sourceRows = [];

  Map<String, String> columnTitles = {
    'name': 'Наименование',
    'productId': 'id не Онтологического продукта',
    'systemCode': 'с:системный код',
    'description': 'с:описание продукта',
  };

  @override
  void initState() {
    super.initState();

  }

  bool initGrid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initGrid) {
      var columnWidth = MediaQuery.of(context).size.width/columnTitles.length;
      for (var k in columnTitles.keys) {
        columns.add(PlutoColumn(
          title: columnTitles[k]!,
          field: k,
          type: PlutoColumnType.text(),
          width: columnWidth,
          enableEditingMode: false,
        ));
      }

      final List<PlutoRow> _rows = [];

      DefaultAssetBundle.of(context)
          .loadString("jsonformatter.txt")
          .then((rawData) {
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
        PlutoGridStateManager.initializeRowsAsync(columns, fetchedRows)
            .then((value) {
          sourceRows = [...value];
          stateManager.refRows.addAll(value);
          stateManager.setShowLoading(false);
        });
      });
      print('initState ${sourceRows.length}');
    }
  }

  Future<List<PlutoRow>> fetchRows() async {
    final List<PlutoRow> _rows = [];

    DefaultAssetBundle.of(context)
        .loadString("jsonformatter.txt")
        .then((rawData) {
      Map<String, dynamic> data = jsonDecode(rawData);

      List<dynamic> instances = data["data"]["instancesWithRelation"];

      for (var element in instances) {
        Map<String, PlutoCell> cells = {};
        List<dynamic> attributes = element["attributes"];

        for (var attr in attributes) {
          String? name = attr["programName"];
          String value = attr["value"];
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
      body: LayoutBuilder(
        builder: (context, size) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: size.maxWidth,
              height: size.maxHeight,
              //padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(icon: Icon(Icons.search)),
                    onChanged: (value) {
                      //_filterRows(rows, value);
                      //rows.clear();
                      setState(() {
                        stateManager.refRows.clear();
                        stateManager.refRows.addAll(_filterRows(value));
                      });
                    },
                  ),
                  Expanded(
                    child: PlutoGrid(
                      columns: columns,
                      rows: rows,
                      onLoaded: (PlutoGridOnLoadedEvent event) {
                        stateManager = event.stateManager;
                        stateManager.setShowLoading(true);
                        //event.stateManager.setShowColumnFilter(true);
                      },
                      configuration: PlutoGridConfiguration(
                        columnFilter: PlutoGridColumnFilterConfig(
                          filters: const [
                            ...FilterHelper.defaultFilters,
                            CustomFilter(),
                          ],
                          resolveDefaultColumnFilter: (column, resolver) {
                            if (column.field == 'name') {
                              return resolver<PlutoFilterTypeContains>()
                                  as PlutoFilterType;
                            } else {
                              return resolver<CustomFilter>()
                                  as PlutoFilterType;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<PlutoRow> _filterRows(String search) {
    print('_filterRows ${sourceRows.length}');
    Set<PlutoRow> result = {};
    if (search == '') return sourceRows;
    for (var row in sourceRows) {
      for (var cell in row.cells.values) {
        if ((cell.value != null) &&
            ((cell.value as String)
                .toLowerCase()
                .contains(search.toLowerCase()))) {
          result.add(row);
          print('$search added ${cell.value}');
          //break;
        }
      }
    }
    return result.toList();
  }
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
