import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_managment/db/category/category_db.dart';
import 'package:money_managment/db/transactions/transaction_db.dart';
import 'package:money_managment/models/category/category_model.dart';
import 'package:money_managment/models/transactions/transaction_model.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshTransactions();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionsNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.separated(
            itemBuilder: (ctx, index) {
              final value = newList[index];
              return Slidable(
                key: Key(value.id!),
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
                      onPressed: (ctx) {
                        TransactionDB.instance.deleteTransaction(value.id!);
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                    )
                  ],
                ),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        foregroundColor: Colors.white,
                        radius: 50,
                        backgroundColor: value.type == CategoryType.expense
                            ? Colors.red
                            : Colors.green,
                        child: Text(
                          parseDate(value.date),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      title: Text('Rs ${value.amount}'),
                      subtitle: Text(value.category.name),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
            itemCount: newList.length,
          ),
        );
      },
    );
  }

  String parseDate(DateTime date) {
    // final date1 = .MMMd().format(date);
    // final splittedDate = date1.split(' ');

    // return '${splittedDate[1]}\n${splittedDate[0]}';
    return '${date.day}\n${date.month} ';
  }
}
