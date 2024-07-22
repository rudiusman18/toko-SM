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
  bool isLoading = false;

  @override
  void initState() {
    _initcategory();
    super.initState();
  }

  _initcategory() async {
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      setState(() {
        isLoading = true;
      });
      if (await categoryProvider.getCategory(
          token: loginProvider.loginModel.token ?? "")) {
        setState(() {
          categoryModel = categoryProvider.categoryModel;
        });
      }
      setState(() {
        isLoading = false;
      });
    });
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

    return SafeArea(
      child: Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            header(),
            isLoading
                ? Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: backgroundColor1,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _initcategory();
                      },
                      color: backgroundColor1,
                      child: ListView(
                        children: [
                          for (var i = 0;
                              i < (categoryModel.data?.length ?? 0);
                              i++)
                            ExpandableNotifier(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    child:
                                                        ProductListSearchResultPage(
                                                      searchKeyword: "",
                                                      sort: "",
                                                      category:
                                                          "${categoryModel.data?[i].kat1Slug}",
                                                      categoryToShow:
                                                          "${categoryModel.data?[i].kat1}",
                                                    ),
                                                    type: PageTransitionType
                                                        .bottomToTop));
                                          },
                                          child: Text(
                                            "${categoryModel.data?[i].kat1}",
                                            style: poppins.copyWith(
                                              fontWeight: bold,
                                            ),
                                          ),
                                        )),
                                    collapsed: const SizedBox(),
                                    expanded: Column(
                                      children: [
                                        for (int j = 0;
                                            j <
                                                (categoryModel.data?[i].child
                                                        ?.length ??
                                                    0);
                                            j++)
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child:
                                                          ProductListSearchResultPage(
                                                        searchKeyword: "",
                                                        sort: "",
                                                        category:
                                                            "${categoryModel.data?[i].kat1Slug},${categoryModel.data?[i].child?[j].kat2Slug}",
                                                        categoryToShow:
                                                            "${categoryModel.data?[i].child?[j].kat2}",
                                                      ),
                                                      type: PageTransitionType
                                                          .bottomToTop));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${categoryModel.data?[i].child?[j].kat2}",
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
                  ),
          ],
        ),
      ),
    );
  }
}
