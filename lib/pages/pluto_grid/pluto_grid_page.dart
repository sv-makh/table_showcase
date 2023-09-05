import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tables_showcase/data/pluto_grid/attribute_model.dart';

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
      _initialiseGrid();
    }
  }

  void _initialiseGrid() {
    var columnWidth = MediaQuery.of(context).size.width / columnTitles.length;
    for (var k in columnTitles.keys) {
      columns.add(PlutoColumn(
        title: columnTitles[k]!,
        field: k,
        type: PlutoColumnType.text(),
        width: columnWidth,
        enableEditingMode: false,
        backgroundColor: Colors.grey.shade100,
      ));
    }

    fetchRows().then((fetchedRows) {
      PlutoGridStateManager.initializeRowsAsync(columns, fetchedRows)
          .then((value) {
        sourceRows = [...value];
        stateManager.refRows.addAll(sourceRows);
        stateManager.setShowLoading(false);
      });
    });
  }

  Future<List<PlutoRow>> fetchRows() async {
    final List<PlutoRow> rowsToFetch = [];

    var rawData =
        await DefaultAssetBundle.of(context).loadString("jsonformatter.txt");

    Map<String, dynamic> data = jsonDecode(rawData);

    List<dynamic> instances = data["data"]["instancesWithRelation"];

    for (var element in instances) {
      Map<String, PlutoCell> cells = {};

      List<dynamic> attributes = element["attributes"];
      for (var attr in attributes) {
        AttributeModel model = AttributeModel.fromJson(attr);
        cells[model.programName!] = PlutoCell(value: model.value);
      }

      PlutoRow row = PlutoRow(cells: cells);
      rowsToFetch.add(row);
    }

    return rowsToFetch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pluto_grid')),
      body: LayoutBuilder(
        builder: (context, size) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: size.maxWidth,
              height: size.maxHeight,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      icon: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.search),
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
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
                      },
                      configuration: const PlutoGridConfiguration(
                        style: PlutoGridStyleConfig(
                          enableCellBorderVertical: false,
                          enableColumnBorderVertical: false,
                          columnTextStyle:
                              TextStyle(color: Colors.black, fontSize: 14),
                          defaultColumnTitlePadding: EdgeInsets.only(
                            left: 5,
                            right: 30,
                          ),
                        ),
                        localeText: PlutoGridLocaleText(),
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
    Set<PlutoRow> result = {};

    if (search == '') return sourceRows;

    for (var row in sourceRows) {
      for (var cell in row.cells.values) {
        if ((cell.value != null) &&
            ((cell.value as String)
                .toLowerCase()
                .contains(search.toLowerCase()))) {
          result.add(row);
          //break;
        }
      }
    }
    return result.toList();
  }
}
