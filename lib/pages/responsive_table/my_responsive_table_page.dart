import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

//https://pub.dev/packages/responsive_table

class MyResponsiveTablePage extends StatefulWidget {
  MyResponsiveTablePage({Key? key}) : super(key: key);

  @override
  _MyResponsiveTablePageState createState() => _MyResponsiveTablePageState();
}

class _MyResponsiveTablePageState extends State<MyResponsiveTablePage> {
  late List<DatatableHeader> _headers;

  List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "name";

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];

  // ignore: unused_field
  String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = false;
  var random = new Random();

  _initializeData() async {
    _pullData();
  }

  _pullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    _sourceOriginal.clear();

    _sourceOriginal = await DefaultAssetBundle.of(context)
        .loadString("jsonformatter.txt")
        .then((rawData) {
      List<Map<String, dynamic>> _source = [];

      Map<String, dynamic> data = jsonDecode(rawData);

      List<dynamic> instances = data["data"]["instancesWithRelation"];

      for (var element in instances) {
        Map<String, dynamic> cells = {};
        List<dynamic> attributes = element["attributes"];

        for (var attr in attributes) {
          String? name = attr["programName"];
          String? value = attr["value"] ?? 'null';
          cells[name!] = value;
        }

        _source.add(cells);
      }

      return _source;
    });

    _sourceFiltered = _sourceOriginal;
    _total = _sourceFiltered.length;
    _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
    setState(() => _isLoading = false);
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  double initX = 0;
  double tableWidth = 1000;
  Map<String, String> columnTitles = {
    'name': 'Наименование',
    'productId': 'id не Онтологического продукта',
    'systemCode': 'с:системный код',
    'description': 'с:описание продукта',
  };

  @override
  void initState() {
    super.initState();

    _headers = [
      DatatableHeader(
        text: columnTitles['name']!,
        value: 'name',
        show: true,
        sortable: true,
        textAlign: TextAlign.center,
      ),
      DatatableHeader(
        text: columnTitles['productId']!,
        value: 'productId',
        show: true,
        sortable: true,
        textAlign: TextAlign.center,
      ),
      DatatableHeader(
        text: columnTitles['systemCode']!,
        value: 'systemCode',
        show: true,
        sortable: true,
        textAlign: TextAlign.center,
      ),
      DatatableHeader(
        text: columnTitles['description']!,
        value: 'description',
        show: true,
        sortable: true,
        textAlign: TextAlign.center,
        headerBuilder: (value) {
          return Stack(children: [
            Container(
              child: Text(columnTitles['description']!), // Header text
              //width: columnWidth,
              constraints: BoxConstraints(minWidth: 100),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onPanStart: (details) {
                  print('pan start ${details.globalPosition.dx}');
                  setState(() {
                    initX = details.globalPosition.dx;
                  });
                },
                onPanUpdate: (details) {
                  final increment = details.globalPosition.dx - initX;
                  final newWidth = tableWidth + increment;
                  setState(() {
                    initX = details.globalPosition.dx;
                    tableWidth = newWidth;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 10,
                  height: 10,
                  decoration:
                      BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                ),
              ),
            ),
          ]);
        },
      ),
    ];

    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("responsive_table"),
        actions: [
          IconButton(
            onPressed: _initializeData,
            icon: Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(
                maxHeight: 700,
                maxWidth: tableWidth,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: Text('responsive_table'),
                  /*TextButton.icon(
                        onPressed: () => {},
                        icon: Icon(Icons.add),
                        label: Text("new item"),
                      ),*/
                  reponseScreenSizes: [ScreenSize.xs],
                  actions: [
                    if (_isSearch)
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter search term based on ' +
                                _searchKey!
                                    .replaceAll(new RegExp('[\\W_]+'), ' ')
                                    .toUpperCase(),
                            prefixIcon: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = false;
                                  });
                                  _initializeData();
                                }),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.search), onPressed: () {})),
                        onSubmitted: (value) {
                          _filterData(value);
                        },
                      )),
                    if (!_isSearch)
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                          })
                  ],
                  headers: _headers,
                  source: _source,
                  selecteds: _selecteds,
                  showSelect: _showSelect,
                  autoHeight: false,
/*                  dropContainer: (data) {
                    if (int.tryParse(data['id'].toString())!.isEven) {
                      return Text("is Even");
                    }
                    return _DropDownContainer(data: data);
                  },*/
                  onChangedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onSubmittedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onTabRow: (data) {
                    print(data);
                  },
                  onSort: (value) {
                    setState(() => _isLoading = true);

                    setState(() {
                      _sortColumn = value;
                      _sortAscending = !_sortAscending;
                      if (_sortAscending) {
                        _sourceFiltered.sort((a, b) =>
                            b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                      } else {
                        _sourceFiltered.sort((a, b) =>
                            a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                      }
                      var _rangeTop = _currentPerPage! < _sourceFiltered.length
                          ? _currentPerPage!
                          : _sourceFiltered.length;
                      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                      _searchKey = value;

                      _isLoading = false;
                    });
                  },
                  expanded: _expanded,
                  sortAscending: _sortAscending,
                  sortColumn: _sortColumn,
                  isLoading: _isLoading,
/*                  onSelect: (value, item) {
                    print("$value  $item ");
                    if (value!) {
                      setState(() => _selecteds.add(item));
                    } else {
                      setState(
                          () => _selecteds.removeAt(_selecteds.indexOf(item)));
                    }
                  },
                  onSelectAll: (value) {
                    if (value!) {
                      setState(() => _selecteds =
                          _source.map((entry) => entry).toList().cast());
                    } else {
                      setState(() => _selecteds.clear());
                    }
                  },*/
                  footers: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Rows per page:"),
                    ),
                    if (_perPages.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton<int>(
                          value: _currentPerPage,
                          items: _perPages
                              .map((e) => DropdownMenuItem<int>(
                                    child: Text("$e"),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (dynamic value) {
                            setState(() {
                              _currentPerPage = value;
                              _currentPage = 1;
                              _resetData();
                            });
                          },
                          isExpanded: false,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child:
                          Text("$_currentPage - $_currentPerPage of $_total"),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                      ),
                      onPressed: _currentPage == 1
                          ? null
                          : () {
                              var _nextSet = _currentPage - _currentPerPage!;
                              setState(() {
                                _currentPage = _nextSet > 1 ? _nextSet : 1;
                                _resetData(start: _currentPage - 1);
                              });
                            },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: _currentPage + _currentPerPage! - 1 > _total
                          ? null
                          : () {
                              var _nextSet = _currentPage + _currentPerPage!;

                              setState(() {
                                _currentPage = _nextSet < _total
                                    ? _nextSet
                                    : _total - _currentPerPage!;
                                _resetData(start: _nextSet - 1);
                              });
                            },
                      padding: EdgeInsets.symmetric(horizontal: 15),
                    )
                  ],
/*                  headerDecoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border(
                          bottom: BorderSide(color: Colors.red, width: 1))),*/
/*                  selectedDecoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.green[300]!, width: 1)),
                    color: Colors.green,
                  ),*/
                  //headerTextStyle: TextStyle(color: Colors.white,),
                  //rowTextStyle: TextStyle(color: Colors.green),
                  //selectedTextStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ])),
    );
  }
}

class _DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;

  const _DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();

    return Container(
      /// height: 100,
      child: Column(
        /// children: [
        ///   Expanded(
        ///       child: Container(
        ///     color: Colors.red,
        ///     height: 50,
        ///   )),
        /// ],
        children: _children,
      ),
    );
  }
}
