import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SideDraw extends StatefulWidget {
  final int? pageNumber;
  final Function(int i)? setpage;
  SideDraw({Key? key, this.pageNumber, this.setpage}) : super(key: key);

  @override
  State<SideDraw> createState() => _SideDrawState();
}

class _SideDrawState extends State<SideDraw> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   isSelected = true;

  //   // selectedTile = widget.pageNumber;
  // }

  bool? isSelected = true;
  // int? selectedTile;
  final drawData = {
    'Dashboard': Icons.dashboard,
    'Food&Drinks': Icons.fastfood,
    'Bills': Icons.calculate_rounded,
    'Settings': Icons.app_settings_alt_sharp,
    'Supportw': Icons.support_agent_rounded,
    'Expensejournal': Icons.library_books,
    'Support': Icons.support_agent_rounded,
  };

  final otherData = {
    'Expensejournal': Icons.library_books,
    'Support': Icons.support_agent_rounded,
  };

  // bool isOthSelected = false;

  // int? selectedOthTile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag,
                  color: Colors.red,
                  size: 35,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Smart',
                  style: GoogleFonts.alef(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                  ),
                ),
                Text(
                  'POS',
                  style: GoogleFonts.alef(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: drawData.length,
              itemBuilder: (ctx, i) => Container(
                decoration: BoxDecoration(
                  color: isSelected! && widget.pageNumber == i ? Colors.green[200] : null,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: i == 4
                      ? Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text('Other',
                              style: GoogleFonts.alef(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              )),
                        )
                      : ListTile(
                          onTap: () {
                            setState(() {
                              isSelected = true;
                              widget.setpage!(i);
                            });
                          },
                          leading: Icon(
                            drawData.values.toList()[i],
                            size: 30,
                          ),
                          title: Text(
                            drawData.keys.toList()[i],
                            style: GoogleFonts.alef(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  minRadius: 40,
                  child: Image(
                    image: AssetImage(
                      'assets/kimchi.png',
                    ),
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Theresa Webb',
                  style: GoogleFonts.alef(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xfff8f8f7),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      'Open profile',
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '©2022 smartPos App',
                textAlign: TextAlign.center,
                style: GoogleFonts.alef(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
