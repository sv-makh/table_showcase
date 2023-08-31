import 'package:flutter/material.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';

import 'model.dart';

//https://pub.dev/packages/scrollable_table_view

class ScrollableTableViewPage extends StatelessWidget {
  const ScrollableTableViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: MyHomePage2(title: 'Scrollable Table View Example'),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  final PaginationController _paginationController = PaginationController(
    rowCount: many_products.length,
    rowsPerPage: 10,
  );

  @override
  Widget build(BuildContext context) {
    var columns = products.first.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: const TabBar(
          tabs: [
            Tab(text: "Simple"),
            Tab(text: "Paginated"),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          // simple
          ScrollableTableView(
            headers: columns.map((column) {
              return TableViewHeader(
                label: column,
              );
            }).toList(),
            rows: products.map((product) {
              return TableViewRow(
                height: 60,
                cells: columns.map((column) {
                  return TableViewCell(
                    child: Text(product[column] ?? ""),
                  );
                }).toList(),
              );
            }).toList(),
          ),
          // paginated
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ValueListenableBuilder(
                    valueListenable: _paginationController,
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          Text(
                              "${_paginationController.currentPage}  of ${_paginationController.pageCount}"),
                          Row(
                            children: [
                              IconButton(
                                onPressed:
                                _paginationController.currentPage <= 1
                                    ? null
                                    : () {
                                  _paginationController.previous();
                                },
                                iconSize: 20,
                                splashRadius: 20,
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: _paginationController.currentPage <= 1
                                      ? Colors.black26
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                              IconButton(
                                onPressed: _paginationController.currentPage >=
                                    _paginationController.pageCount
                                    ? null
                                    : () {
                                  _paginationController.next();
                                },
                                iconSize: 20,
                                splashRadius: 20,
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: _paginationController.currentPage >=
                                      _paginationController.pageCount
                                      ? Colors.black26
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              ),
              Expanded(
                child: ScrollableTableView(
                  paginationController: _paginationController,
                  headers: columns.map((column) {
                    return TableViewHeader(
                      label: column,
                    );
                  }).toList(),
                  rows: many_products.map((product) {
                    return TableViewRow(
                      height: 60,
                      cells: columns.map((column) {
                        return TableViewCell(
                          child: Text(product[column] ?? ""),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}