import 'package:flutter/material.dart';
import 'package:money_managment/db/category/category_db.dart';
import 'package:money_managment/screens/category/widgets/expense_category_list.dart';
import 'package:money_managment/screens/category/widgets/income_category_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              text: 'Income',
            ),
            Tab(
              text: 'Expense',
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TabBarView(
              controller: _tabController,
              children: const [
                IncomeCategoryList(),
                ExpenseCategoryList(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
