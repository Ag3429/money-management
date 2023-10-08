import 'package:flutter/material.dart';
import 'package:money_managment/db/category/category_db.dart';
// import 'package:money_managment/db/category/category_db.dart';
// import 'package:money_managment/models/category/category_model.dart';
import 'package:money_managment/screens/add_transacttion/add_transaction_screen.dart';
import 'package:money_managment/screens/category/screen_category.dart';
import 'package:money_managment/screens/category/widgets/category_add_popup.dart';
import 'package:money_managment/screens/home/widgets/bottom_navigation.dart';
import 'package:money_managment/screens/transactions/screen_transaction.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  final _pages = const [
    TransactionScreen(),
    CategoryScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Money Manager',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndex,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndex.value == 0) {
            CategoryDB().refreshUI();
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            showCategoryShow(context);
            // final sample = CategoryModel(
            //   id: DateTime.now().microsecondsSinceEpoch.toString(),
            //   name: 'Travel',
            //   type: CategoryType.income,
            // );
            // CategoryDB().insertCategory(sample);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
