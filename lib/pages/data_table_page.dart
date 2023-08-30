import 'package:flutter/material.dart';

List<DataRow> rows = List<DataRow>.generate(
  10,
  (index) => DataRow(
    cells: <DataCell>[
      DataCell(Text(index.toString())),
      DataCell(Text('$index-1 cell')),
      DataCell(Text('$index-2 cell')),
    ],
  ),
);

class DataTablePage extends StatefulWidget {
  const DataTablePage({super.key});

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  static const int numItems = 10;
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);
  final DataTableSource _dataTableSource = MyData();

  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  String _sortArrow = '⇩';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DataTable / PaginatedDataTable widgets')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataTable(columns: _createColumns(), rows: _createRows()),
            const SizedBox(height: 10),
            PaginatedDataTable(
              columns: [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('1 column')),
                DataColumn(label: Text('2 column')),
              ],
              source: _dataTableSource,
              columnSpacing: 100,
              horizontalMargin: 10,
              rowsPerPage: 4,
              showCheckboxColumn: true,
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _createRows() {
    return List<DataRow>.generate(
      numItems,
      (index) => DataRow(
          cells: rows[index].cells,
          selected: selected[index],
          onSelectChanged: (bool? sel) {
            setState(() {
              selected[index] = sel!;
            });
          }),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Text('#$_sortArrow'),
          onSort: (columnIndex, _) {
            setState(() {
              _currentSortColumn = columnIndex;
              if (_isSortAsc) {
                rows.sort(
                  (a, b) => (b.cells[0].child as Text)
                      .data!
                      .compareTo((a.cells[0].child as Text).data!),
                );
                _sortArrow = '⇧';
              } else {
                rows.sort(
                  (a, b) => (a.cells[0].child as Text)
                      .data!
                      .compareTo((b.cells[0].child as Text).data!),
                );
                _sortArrow = '⇩';
              }
              _isSortAsc = !_isSortAsc;
            });
          }),
      DataColumn(label: Text('1 column')),
      DataColumn(label: Text('2 column')),
    ];
  }
}

class MyData extends DataTableSource {
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  DataRow? getRow(int index) {
    return rows[index];
  }

  @override
  int get selectedRowCount => 0;
}
