import 'package:flutter/material.dart';
import 'package:money_managment/screens/home/screen_home.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedIndex,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
          selectedItemColor: Colors.deepPurple,
          selectedFontSize: 10,
          unselectedFontSize: 0,
          unselectedItemColor: Colors.grey,
          currentIndex: updatedIndex,
          onTap: (newindex) {
            HomeScreen.selectedIndex.value = newindex;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories')
          ],
        );
      },
    );
  }
}
