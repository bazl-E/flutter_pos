import 'package:flutter/material.dart';
import 'package:posapp/extras/side_draw.dart';
import 'package:posapp/provider/src.dart';
import 'package:posapp/provider/supplier/history_supplier_by_date.dart';
import 'package:posapp/provider/supplier/history_supplier_by_line.dart';
import 'package:posapp/screens/edit_menu/main.dart';
import 'package:posapp/screens/expense_journal/main.dart';
import 'package:posapp/screens/history/main.dart';
import 'package:posapp/screens/lobby/main.dart';
import 'package:posapp/storage_engines/connection_interface.dart';
import 'package:provider/provider.dart';

class NewHome extends StatefulWidget {
  final DatabaseConnectionInterface? database;
  const NewHome({Key? key, this.database}) : super(key: key);

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  @override
  void initState() {
    super.initState();
    pages = [
      DefaultTabController(
        length: 2,
        child: MultiProvider(
          providers: [
            // TODO: restructure to use parent model HistoryOrderSupplier
            ChangeNotifierProvider(
              create: (_) => HistorySupplierByDate(database: widget.database),
            ),
            ChangeNotifierProxyProvider<HistorySupplierByDate, HistorySupplierByLine>(
              create: (_) => HistorySupplierByLine(database: widget.database),
              update: (_, firstTab, lineChart) => lineChart!..update(firstTab),
            ),
          ],
          child: HistoryScreen(),
        ),
      ),
      EditMenuScreen(),
      LobbyScreen(),
      Container(),
      Container(),
      ChangeNotifierProvider<ExpenseSupplier>(
        create: (_) {
          return ExpenseSupplier(database: widget.database);
        },
        child: ExpenseJournalScreen(),
      ),
      Container(),
    ];
  }

  int pageNumber = 0;
  List pages = [];

  void setPageNumber(int i) {
    setState(() {
      pageNumber = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfff8f8f7),
      body: SafeArea(
        child: Flex(direction: Axis.horizontal, children: [
          Flexible(
            flex: 2,
            child: Container(
              color: Color(0xfff8f8f7),
              child: SideDraw(
                pageNumber: pageNumber,
                setpage: setPageNumber,
              ),
            ),
          ),
          Container(
            width: 1,
            height: double.infinity,
            color: Colors.grey,
          ),
          Flexible(
            flex: 8,
            child: Container(
              color: Color(0xfff8f8f7),
              child: pages[pageNumber],
            ),
          )
        ]),
      ),
    );
  }
}
