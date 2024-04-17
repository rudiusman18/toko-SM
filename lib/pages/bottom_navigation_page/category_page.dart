import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/category_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/home_page/product_list_search_result.dart';
import 'package:tokoSM/providers/category_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';

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
  CategoryModel categoryModel = CategoryModel();

  @override
  void initState() {
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      if (await categoryProvider.getCategory(
          token: loginProvider.loginModel.token ?? "")) {
        setState(() {
          categoryModel = categoryProvider.categoryModel;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
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

    Widget expandedItem({
      required int kat1Index,
      required int kat2Index,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0;
              i <
                  (categoryModel
                          .data?[kat1Index].child?[kat2Index].child1?.length ??
                      0);
              i++)
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: ProductListSearchResult(
                          searchKeyword:
                              "${categoryModel.data?[kat1Index].child?[kat2Index].child1?[i].kat3}",
                          isCategory: true,
                        ),
                        type: PageTransitionType.bottomToTop));
              },
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${categoryModel.data?[kat1Index].child?[kat2Index].child1?[i].kat3}",
                      style: poppins,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 1,
                    ),
                  ],
                ),
              ),
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
                  for (var i = 0; i < (categoryModel.data?.length ?? 0); i++)
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
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                              tapBodyToCollapse: true,
                            ),
                            header: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "${categoryModel.data?[i].kat1}",
                                  style: poppins.copyWith(
                                    fontWeight: bold,
                                  ),
                                )),
                            collapsed: const SizedBox(),
                            expanded: Column(
                              children: [
                                for (int j = 0;
                                    j <
                                        (categoryModel.data?[i].child?.length ??
                                            0);
                                    j++)
                                  ExpandableNotifier(
                                    child: ExpandablePanel(
                                      theme: const ExpandableThemeData(
                                        headerAlignment:
                                            ExpandablePanelHeaderAlignment
                                                .center,
                                        tapBodyToCollapse: true,
                                      ),
                                      header: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "${categoryModel.data?[i].child?[j].kat2}",
                                            style: poppins.copyWith(
                                              fontWeight: bold,
                                            ),
                                          )),
                                      collapsed: const SizedBox(),
                                      expanded: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        width: double.infinity,
                                        child: expandedItem(
                                          kat1Index: i,
                                          kat2Index: j,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            builder: (_, collapsed, expanded) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Expandable(
                                  collapsed: collapsed,
                                  expanded: expanded,
                                  theme: const ExpandableThemeData(
                                      crossFadePoint: 0),
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
