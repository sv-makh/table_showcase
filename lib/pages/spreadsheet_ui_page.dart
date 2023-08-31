import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';

class SpreadsheetUiPage extends StatefulWidget {
  const SpreadsheetUiPage({super.key, this.title = 'flutter_spreadsheet_ui'});

  final String title;

  @override
  State<SpreadsheetUiPage> createState() => _SpreadsheetUiPageState();
}

class _SpreadsheetUiPageState extends State<SpreadsheetUiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FlutterSpreadsheetUI(
          config: const FlutterSpreadsheetUIConfig(
            enableColumnWidthDrag: true,
            enableRowHeightDrag: true,
            firstColumnWidth: 150,
            freezeFirstColumn: true,
            freezeFirstRow: true,
          ),
          columnWidthResizeCallback: (int columnIndex, double updatedWidth) {
            log("Column: $columnIndex's updated width: $updatedWidth");
          },
          rowHeightResizeCallback: (int rowIndex, double updatedHeight) {
            log("Row: $rowIndex's updated height: $updatedHeight");
          },
          columns: List.generate(
            10,
                (index) => FlutterSpreadsheetUIColumn(
              width: 110,
              cellBuilder: (context, cellId) => Text(cellId),
            ),
          ),
          rows: List.generate(
            30,
                (rowIndex) => FlutterSpreadsheetUIRow(
              cells: List.generate(
                10,
                    (colIndex) => FlutterSpreadsheetUICell(
                  cellBuilder: (context, cellId) => Text(
                    cellId,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}