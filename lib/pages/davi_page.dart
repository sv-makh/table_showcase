import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'dart:math';

//https://pub.dev/packages/davi

class Person {
  Person(this.name, this.age, this.value);

  final String name;
  final int age;
  final int value;

  bool _valid = true;

  bool get valid => _valid;

  String _editable = '';

  String get editable => _editable;

  set editable(String value) {
    _editable = value;
    _valid = _editable.length < 6;
  }
}

class DaviPage extends StatefulWidget {
  const DaviPage({Key? key}) : super(key: key);

  @override
  State<DaviPage> createState() => _DaviPageState();
}

class _DaviPageState extends State<DaviPage> {
  DaviModel<Person>? _model;

  @override
  void initState() {
    super.initState();

    List<Person> rows = [];

    Random random = Random();
    for (int i = 1; i < 500; i++) {
      rows.add(Person('User $i', 20 + random.nextInt(50), random.nextInt(999)));
    }
    rows.shuffle();

    _model = DaviModel<Person>(
        rows: rows,
        columns: [
          DaviColumn(
            name: 'Name',
            stringValue: (data) => data.name,
            headerAlignment: Alignment.center,
          ),
          DaviColumn(
            name: 'Age',
            intValue: (data) => data.age,
            grow: 1,
            headerAlignment: Alignment.center,
          ),
          DaviColumn(
            name: 'Value',
            intValue: (data) => data.value,
            grow: 2,
            headerAlignment: Alignment.center,
          ),
          DaviColumn(
            name: 'Editable',
            sortable: false,
            cellBuilder: _buildField,
            cellBackground: (row) => row.data.valid ? null : Colors.red[800],
            headerAlignment: Alignment.center,
          )
        ],
        alwaysSorted: true,
        multiSortEnabled: true);
  }

  Widget _buildField(BuildContext context, DaviRow<Person> rowData) {
    return TextFormField(
        initialValue: rowData.data.editable,
        style:
            TextStyle(color: rowData.data.valid ? Colors.black : Colors.white),
        onChanged: (value) => _onFieldChange(value, rowData.data));
  }

  void _onFieldChange(String value, Person person) {
    final wasValid = person.valid;
    person.editable = value;
    if (wasValid != person.valid) {
      setState(() {
        // rebuild
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('davi')),
      body: DaviTheme(
        child: Davi<Person>(_model),
        data: DaviThemeData(
            row: RowThemeData(hoverBackground: (rowIndex) => Colors.blue[50]),
            header: HeaderThemeData(
              color: Colors.green[50],
              bottomBorderHeight: 4,
              //bottomBorderColor: Colors.blue
            ),
            headerCell: HeaderCellThemeData(
                height: 40,
                alignment: Alignment.center,
                textStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  //color: Colors.blue
                ),
                resizeAreaWidth: 10,
                resizeAreaHoverColor: Colors.blue.withOpacity(.5),
                sortIconColors: SortIconColors.all(Colors.green),
                expandableName: false)),
      ),
    );
  }
}
