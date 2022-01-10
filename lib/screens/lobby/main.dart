import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../popup_del.dart';
import './table_icon.dart';
import '../../common/common.dart';
import '../../theme/rally.dart';
import '../../provider/src.dart';
import 'anim_longclick_fab.dart';

class LobbyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       // Tooltip(
      //       //   message: AppLocalizations.of(context)!.lobby_report,
      //       //   child: MaterialButton(
      //       //     onPressed: () {
      //       //       showBottomSheetMenu(context);
      //       //     },
      //       //     minWidth: MediaQuery.of(context).size.width / 2,
      //       //     shape: CustomShape(side: CustomShapeSide.left),
      //       //     child: Icon(Icons.menu),
      //       //   ),
      //       // ),
      //       Tooltip(
      //         message: AppLocalizations.of(context)!.lobby_menuEdit,
      //         child: MaterialButton(
      //           onPressed: () => Navigator.pushNamed(context, '/edit-menu'),
      //           minWidth: MediaQuery.of(context).size.width / 2,
      //           shape: CustomShape(side: CustomShapeSide.right),
      //           child: Icon(Icons.menu_book_sharp),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      // floatingActionButton: AnimatedLongClickableFAB(
      //   onPress: () {
      //     var supplier = Provider.of<Supplier>(context, listen: false);
      //     final tableid = supplier.addTable();
      //     final table = supplier.getTable(tableid);
      //     _addTable(context);
      //     Navigator.pushNamed(context, '/menu', arguments: {
      //       'heroTag': 'menu-subtag-table-$tableid',
      //       'model': table,
      //     });
      //   },
      //   // onPress: () => _addTable(context),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _InteractiveBody(),
    );
  }

  Future showBottomSheetMenu(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      // isScrollControlled combined with shrinkWrap for minimal height in bottom sheet
      isScrollControlled: true,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(
                AppLocalizations.of(context)?.lobby_report.toUpperCase() ?? 'HISTORY',
                textAlign: TextAlign.center,
              ),
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)?.lobby_journal.toUpperCase() ?? 'EXPENSE JOURNAL',
                textAlign: TextAlign.center,
              ),
              onTap: () => Navigator.pushNamed(context, '/expense'),
            ),
          ],
        );
      },
    );
  }
}

/// Allow panning & dragging widgets inside...
class _InteractiveBody extends StatelessWidget {
  /// The key to container (1), must be passed into all DraggableWidget widgets in Stack
  final GlobalKey bgKey = GlobalKey();

  final TransformationController transformController = TransformationController();

  builditem(Supplier supplier, i, context) {
    var supplier = Provider.of<Supplier>(context, listen: false);
    final tableid = supplier.tables[i].id;
    final table = supplier.getTable(tableid);
    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
            context: context,
            builder: (ctx) {
              return CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pushNamed(context, '/menu', arguments: {
                          'heroTag': 'menu-subtag-table-$tableid',
                          'model': table,
                        }).then((value) => Navigator.of(context).pop());
                      },
                      child: Text('Add item')),
                  CupertinoActionSheetAction(
                      onPressed:
                          //     table.status == TableStatus.occupied
                          // ?
                          () {
                        if (table.status == TableStatus.occupied) {
                          Navigator.pushNamed(context, '/order-details', arguments: {
                            'heroTag': 'details-subtag-table-${table.id}',
                            'state': table,
                            'from': 'lobby',
                          }).then((value) => Navigator.of(context).pop());
                        } else {
                          null;
                        }
                      },
                      // : null,
                      child: Text('Print Bill')),
                  CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _removeTable(context, table.id);
                      },
                      child: Text('Delete')),
                ],
                cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
              );
            });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        height: 150,
        width: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color:
                supplier.tables[i].status == TableStatus.occupied ? Color(0xFF045D56) : Colors.grey,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 1),
                  color: Colors.black.withAlpha(50))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Chip(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              label: Text(
                '${supplier.tables[i].totalPricePreDiscount}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            buildSimpleText('Discount', '${supplier.tables[i].discountPercent.toStringAsFixed(2)}'),
            buildSimpleText('Total Items', '${supplier.tables[i].totalMenuItemQuantity}'),
            Divider(
              color: Colors.white,
              thickness: 2,
            ),
            buildSimpleText(
                'Off price', supplier.tables[i].totalPriceAfterDiscount.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supplier = Provider.of<Supplier>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          reverse: true,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: .8,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          itemCount: supplier.tables.length + 1,
          itemBuilder: (ctx, i) => i == supplier.tables.length
              ? InkWell(
                  onTap: () {
                    var supplier = Provider.of<Supplier>(context, listen: false);
                    final tableid = supplier.addTable();
                    final table = supplier.getTable(tableid);
                    _addTable(context);
                    Navigator.pushNamed(context, '/menu', arguments: {
                      'heroTag': 'menu-subtag-table-$tableid',
                      'model': table,
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      height: 150,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF045D56),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                      )),
                )
              :
              // CupertinoContextMenu(

              //     actions: [
              //       CupertinoContextMenuAction(
              //         trailingIcon: Icons.add,
              //         // isDestructiveAction: true,
              //         child: Text('Add Items'),
              //       ),
              //       CupertinoContextMenuAction(
              //         trailingIcon: Icons.print,
              //         // isDestructiveAction: true,
              //         child: Text('Print Bill'),
              //       ),
              //       CupertinoContextMenuAction(
              //         trailingIcon: Icons.delete,
              //         isDestructiveAction: true,
              //         child: Text('Delete'),
              //       ),
              //     ],
              //     child:
              builditem(supplier, i, context)
          // ),
          ),
    );
    //  InteractiveViewer(
    //   maxScale: 2.0,
    //   transformationController: transformController,
    //   child: Stack(
    //     children: [
    //       // create a container (1) here to act as fixed background for the entire screen,
    //       // pan & scale effect from InteractiveViewer will actually interact with this container
    //       // thus also easily scale & pan all widgets inside the stack
    //       Container(key: bgKey),
    //       for (var model in supplier.tables)
    //         DraggableWidget(
    //           x: model.getOffset().x,
    //           y: model.getOffset().y,
    //           containerKey: bgKey,
    //           transformController: transformController,
    //           onDragEnd: (x, y) {
    //             model.setOffset(Coordinate(x, y), supplier);
    //           },
    //           key: ObjectKey(model),
    //           child: TableIcon(table: model),
    //         ),
    //     ],
    //   ),
    // );
  }
}

// ******************************* //
// int? tableid;
void _addTable(BuildContext context) {
  var supplier = Provider.of<Supplier>(context, listen: false);
}

Widget buildSimpleText(String frist, String trail) {
  return FittedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          frist,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 19),
        ),
        Text(
          ':',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 19),
        ),
        Text(
          trail,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 19),
        )
      ],
    ),
  );
}

void _removeTable(BuildContext context, int id) async {
  final supplier = Provider.of<Supplier>(context, listen: false);
  var delete = await popUpDelete(context);
  if (delete != null && delete) {
    supplier.removeTable(id);
  }
}
