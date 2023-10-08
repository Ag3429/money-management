import 'package:flutter/material.dart';
import 'package:money_managment/db/category/category_db.dart';
import 'package:money_managment/db/transactions/transaction_db.dart';
import 'package:money_managment/models/category/category_model.dart';
import 'package:money_managment/models/transactions/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';

  /*
    Purpose
    Date
    Amount
    Income/Expense
    CategoryType

   */
  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  final _purpose = TextEditingController();
  final _amount = TextEditingController();

  String? _categoryID;

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //purpose
              TextFormField(
                controller: _purpose,
                decoration: const InputDecoration(
                  hintText: 'Purpose',
                ),
              ),
              //Amount
              TextFormField(
                controller: _amount,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              //Date
              TextButton.icon(
                onPressed: () async {
                  // ignore: no_leading_underscores_for_local_identifiers
                  final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );

                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    print(_selectedDateTemp.toString());
                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: const Icon(Icons.date_range),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : _selectedDate!.toString()),
              ),
              //CategoryType
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = newValue;
                            _categoryID = null;
                          });
                        },
                      ),
                      const Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = newValue;
                            _categoryID = null;
                          });
                        },
                      ),
                      const Text('Expense'),
                    ],
                  ),
                ],
              ),
              DropdownButton<String>(
                hint: const Text('Select Category'),
                value: _categoryID,
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDB.instance.incomeCategoryList
                        : CategoryDB.instance.expenseCategoryList)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      _selectedCategoryModel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedItem) {
                  setState(() {
                    _categoryID = selectedItem;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      addTransaction();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Submit'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purpose.text;
    final _amountText = _amount.text;

    if (_purposeText.isEmpty) return;
    if (_amountText.isEmpty) return;
    if (_categoryID == null) return;
    if (_selectedDate == null) return;
    if (_selectedCategoryModel == null) return;

    final parseAmount = double.tryParse(_amountText);

    if (parseAmount == null) return;

    final model = TransactionModel(
      purpose: _purposeText,
      amount: parseAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );
    Navigator.of(context).pop();

    await TransactionDB.instance.addTransaction(model);
    TransactionDB.instance.refreshTransactions();
  }
}
