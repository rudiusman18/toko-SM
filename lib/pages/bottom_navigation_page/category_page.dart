import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Item> generateItems(int numberOfItems) {
    return List.generate(numberOfItems, (int index) {
      return Item(
        headerValue: 'Book $index',
        expandedValue: 'Details for Book $index goes here',
      );
    });
  }
  late final List<Item> _books = generateItems(8);


  @override
  Widget build(BuildContext context) {
    Widget header(){
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: backgroundColor3,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "Kategori",
              style: poppins.copyWith(
                color: Colors.white,
                fontWeight: semiBold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      );
    }

    Widget expandedItem(){
      return Column(
        children: [
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: backgroundColor2,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Icon(Icons.person),
          ),
          Text(
            "Category",
            style: poppins,
          ),
        ],
      );
    }

    return SafeArea(
      child: Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            header(),
            Expanded(
              child: ListView(
                children: [
                  for (var i=0; i<10; i++)
              ExpandableNotifier(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Category ${i+1}",
                          style: poppins.copyWith(
                            fontWeight: bold,
                          ),
                        )),
                    collapsed: const SizedBox(),
                    expanded: Container(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 5,
                        children: [
                          for(var i=0; i<5; i++)
                          expandedItem(),
                        ],
                      ),
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
