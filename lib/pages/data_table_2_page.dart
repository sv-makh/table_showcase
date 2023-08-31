import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

//https://pub.dev/packages/data_table_2

class DataTable2Page extends StatefulWidget {
  const DataTable2Page();

  @override
  State<DataTable2Page> createState() => _DataTable2PageState();
}

class _DataTable2PageState extends State<DataTable2Page> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('data_table_2')),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable2(
            border: TableBorder.all(
              width: 1,
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            scrollController: _controller,
            fixedTopRows: 2,
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 600,
            columns: const [
              DataColumn2(
                label: Text('Column A'),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text('Column B'),
              ),
              DataColumn2(
                label: Text('Column C'),
              ),
              DataColumn2(
                label: Text('Column D'),
              ),
              DataColumn2(
                label: Text('Column NUMBERS'),
                numeric: true,
              ),
            ],
            rows: List<DataRow>.generate(
              100,
              (index) => DataRow(
                cells: [
                  DataCell(Text('A' * (10 - index % 10))),
                  DataCell(Text('B' * (10 - (index + 5) % 10))),
                  DataCell(Text('C' * (15 - (index + 5) % 10))),
                  DataCell(Text('D' * (15 - (index + 10) % 10))),
                  DataCell(Text(((index + 0.1) * 25.4).toString()))
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 0,
          child: OutlinedButton(
            onPressed: () {
              _controller.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
                foregroundColor: MaterialStateProperty.all(Colors.white)),
            child: Text('↑↑ go up ↑↑'),
          ),
        )
      ]),
    );
  }
}
